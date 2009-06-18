Return-Path: <linux-kernel-owner+w=401wt.eu-S1758245AbZFRWJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245AbZFRWJd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 18:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbZFRWJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 18:09:28 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:45800 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924AbZFRWJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 18:09:27 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 18 Jun 2009 15:03:19 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Gregory Haskins <ghaskins@novell.com>
cc: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [KVM-RFC PATCH 1/2] eventfd: add an explicit srcu based notifier
 interface
In-Reply-To: <4A3A8FBC.10905@novell.com>
Message-ID: <alpine.DEB.1.10.0906181500350.32646@makko.or.mcafeemobile.com>
References: <20090616022041.23890.90120.stgit@dev.haskins.net> <20090616022956.23890.63776.stgit@dev.haskins.net> <20090616140240.GA9401@redhat.com> <4A37A7FC.4090403@novell.com> <20090616143816.GA18196@redhat.com> <4A37B0BB.3020005@novell.com>
 <20090616145502.GA1102@redhat.com> <4A37B832.6040206@novell.com> <20090616154150.GA17494@redhat.com> <4A37C592.2030407@novell.com> <alpine.DEB.1.10.0906160915340.25664@makko.or.mcafeemobile.com> <4A37CFDA.4000602@novell.com>
 <alpine.DEB.1.10.0906170932290.7891@makko.or.mcafeemobile.com> <4A3927C0.5060607@novell.com> <alpine.DEB.1.10.0906171034030.7891@makko.or.mcafeemobile.com> <4A39415C.9060803@novell.com> <alpine.DEB.1.10.0906171247120.7891@makko.or.mcafeemobile.com>
 <4A39649C.4020602@novell.com> <alpine.DEB.1.10.0906171457000.7891@makko.or.mcafeemobile.com> <4A3A48AB.2080206@novell.com> <alpine.DEB.1.10.0906181011140.32646@makko.or.mcafeemobile.com> <4A3A8FBC.10905@novell.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Jun 2009, Gregory Haskins wrote:

> Davide Libenzi wrote:
> > On Thu, 18 Jun 2009, Gregory Haskins wrote:
> >
> >   
> >> Actually there is only one (the tx-thread) aside from the eventfd
> >> imposed workqueue one.  Incidentally, I would love to get rid of the
> >> other thread too, so I am not just picking on eventfd ;).  The other is
> >> a lot harder since it has to update the virtio-ring and may need to page
> >> in guest memory to do so.
> >>     
> >
> > No, there is the interface rx softirq too, that makes two.
> 
> Actually, I believe you are mistaken.  It normally executes the softirq
> in interrupt context, not a thread.
> 
> But I digress.  Lets just shelve the SRCU conversation for another day. 
> It was my bad for introducing it now prematurely to solve a mostly
> unrelated problem: the module-reference thing.  I didn't realize the
> SRCU change would be so controversial, and I didn't think to split
> things apart as I have done today.
> 
> But the fact is: I do not see any way to actually use your referenceless
> POLLHUP release code in a race free way without doing something like I
> propose in 3/4, 4/4.   Lets keep the discussion focused on that for now,
> if we could.

OK, since I got literally swamped by the amount of talks and patches over 
this theoretically simple topic, would you mind  1) posting the global 
patch over eventfd  2) describe exactly what races are you talking about 
3) explain why this should be any concern of eventfd at all?



- Davide


