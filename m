Return-Path: <linux-kernel-owner+w=401wt.eu-S1757305AbZFQQpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305AbZFQQpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 12:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754355AbZFQQpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 12:45:06 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:49425 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbZFQQpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 12:45:05 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 17 Jun 2009 09:38:55 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Gregory Haskins <ghaskins@novell.com>
cc: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [KVM-RFC PATCH 1/2] eventfd: add an explicit srcu based notifier
 interface
In-Reply-To: <4A37CFDA.4000602@novell.com>
Message-ID: <alpine.DEB.1.10.0906170932290.7891@makko.or.mcafeemobile.com>
References: <20090616022041.23890.90120.stgit@dev.haskins.net> <20090616022956.23890.63776.stgit@dev.haskins.net> <20090616140240.GA9401@redhat.com> <4A37A7FC.4090403@novell.com> <20090616143816.GA18196@redhat.com> <4A37B0BB.3020005@novell.com>
 <20090616145502.GA1102@redhat.com> <4A37B832.6040206@novell.com> <20090616154150.GA17494@redhat.com> <4A37C592.2030407@novell.com> <alpine.DEB.1.10.0906160915340.25664@makko.or.mcafeemobile.com> <4A37CFDA.4000602@novell.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jun 2009, Gregory Haskins wrote:

> Davide Libenzi wrote:
> > On Tue, 16 Jun 2009, Gregory Haskins wrote:
> >
> >   
> >> Does this all make sense?
> >>     
> >
> > This conversation has been *really* long, and I haven't had time to look 
> > at the patch yet. But looking at the amount of changes, and the amount of 
> > even more changes talked in this thread, there's a very slim chance that 
> > I'll ACK the eventfd code.
> > You may want to consider a solution that does not litter eventfd code that 
> > much.
> >
> >
> > - Davide
> >
> >
> >   
> Hi Davide,
> 
> I understand your position and value your time/insight into looking at
> this things.
> 
> Despite the current ongoing discussion, I still stand that the current
> patch is my proposed solution (though I have yet to convince Michael). 
> But in any case,  if you have the time, please look it over because I
> still think its the right direction to head in.

I don't think so. You basically upload a bunch of stuff it could have been 
inside your irqfd into eventfd. Now the eventfd_signal() can magically 
sleep, or not, depending on what the signal functions do. This makes up a 
pretty aweful interface if you ask me.
A lot simpler and cleaner if eventfd_signal(), like all the wake up 
functions inside the kernel, can be called from atomic context. Always, 
not sometimes.



- Davide


