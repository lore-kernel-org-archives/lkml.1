Return-Path: <linux-kernel-owner+w=401wt.eu-S1758127AbZFVUAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127AbZFVUAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 16:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbZFVUAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 16:00:38 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:35636 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbZFVUAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 16:00:37 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 22 Jun 2009 12:54:27 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Gregory Haskins <gregory.haskins@gmail.com>
cc: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 3/3] eventfd: add internal reference counting to fix
 notifier race conditions
In-Reply-To: <4A3FD89A.8080809@gmail.com>
Message-ID: <alpine.DEB.1.10.0906221251330.10952@makko.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0906201508460.25534@makko.or.mcafeemobile.com> <alpine.DEB.1.10.0906201640380.25534@makko.or.mcafeemobile.com> <4A3D895C.7020605@novell.com> <alpine.DEB.1.10.0906210946560.18205@makko.or.mcafeemobile.com> <4A3E7E63.1070407@novell.com>
 <alpine.DEB.1.10.0906211613200.8816@makko.or.mcafeemobile.com> <4A3FABD9.7080108@novell.com> <alpine.DEB.1.10.0906220952090.10952@makko.or.mcafeemobile.com> <4A3FC2B1.4050107@novell.com> <alpine.DEB.1.10.0906221055480.10952@makko.or.mcafeemobile.com>
 <20090622184139.GG15228@redhat.com> <alpine.DEB.1.10.0906221146210.10952@makko.or.mcafeemobile.com> <4A3FD89A.8080809@gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jun 2009, Gregory Haskins wrote:

> Davide Libenzi wrote:
> > On Mon, 22 Jun 2009, Michael S. Tsirkin wrote:
> >
> >   
> >> On Mon, Jun 22, 2009 at 11:03:22AM -0700, Davide Libenzi wrote:
> >>     
> >>> In your case of kernel-to-kernel scenario, why would you need eventfd at 
> >>> all, if userspace role in that model is simply to create it?
> >>>       
> >> That's not 100% true. We have a mode where userspace is the producer
> >> and/or consumer (migration mode) and we switch between that and
> >> direct kernel-to-kernel communication.
> >>     
> >
> > Then you'd need to ask yourself how to handle your complex case inside the 
> > KVM code, so that other eventfd users are not affected by the extra fat 
> > needed to handle your scenarios. Thing that seem to be continuosly tried.
> > A file* based kernel-to-kernel interface is rather wrong IMO.
> >   
> 
> Well, I will point out that the interface in question is
> eventfd_signal(struct file *), and you were the one that invented it
> afaict.  Can't help it if we like it :)

Yes, I did. The case for eventfd was dual. First, it was a communication 
link between userspace and kernel, for things like KAIO. Second, it was a 
faster and smaller userspace replacement for things people used pipes 
before.
In all those cases, at least one reference of the file* is alive in 
userspace.
Even with the above case in mind, today I'd still use the eventfd_ctx as 
internal kernel API accessory.



- Davide


