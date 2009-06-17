Return-Path: <linux-kernel-owner+w=401wt.eu-S1758280AbZFQT41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280AbZFQT41 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 15:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbZFQT4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 15:56:18 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:44715 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbZFQT4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 15:56:17 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 17 Jun 2009 12:50:10 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Gregory Haskins <ghaskins@novell.com>
cc: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [KVM-RFC PATCH 1/2] eventfd: add an explicit srcu based notifier
 interface
In-Reply-To: <4A39415C.9060803@novell.com>
Message-ID: <alpine.DEB.1.10.0906171247120.7891@makko.or.mcafeemobile.com>
References: <20090616022041.23890.90120.stgit@dev.haskins.net> <20090616022956.23890.63776.stgit@dev.haskins.net> <20090616140240.GA9401@redhat.com> <4A37A7FC.4090403@novell.com> <20090616143816.GA18196@redhat.com> <4A37B0BB.3020005@novell.com>
 <20090616145502.GA1102@redhat.com> <4A37B832.6040206@novell.com> <20090616154150.GA17494@redhat.com> <4A37C592.2030407@novell.com> <alpine.DEB.1.10.0906160915340.25664@makko.or.mcafeemobile.com> <4A37CFDA.4000602@novell.com>
 <alpine.DEB.1.10.0906170932290.7891@makko.or.mcafeemobile.com> <4A3927C0.5060607@novell.com> <alpine.DEB.1.10.0906171034030.7891@makko.or.mcafeemobile.com> <4A39415C.9060803@novell.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jun 2009, Gregory Haskins wrote:

> Davide Libenzi wrote:
> 
> > How much the (possible, but not certain) kernel thread context switch time 
> > weighs in the overall KVM IRQ service time?
> >   
> 
> Generally each one is costing me about 7us on average.  For something
> like high-speed networking, we have a path that has about 30us of
> base-line overhead.  So one additional ctx-switch puts me at base+7 ( =
> ~37us), two puts me in base+2*7 (= ~44us).  So in that context (no pun
> intended ;), it hurts quite a bit.  I'll be the first to admit that not
> everyone (most?) will care about latency, though.  But FWIW, I do.

And how a frame reception is handled in Linux nowadays?



> True, but thats the notifiee's burden, not eventfd's.  And its always
> going to be opt-in.  Even today, someone is free to either try to sleep
> (which will oops on the might_sleep()), ...

No, today you just can't sleep. As you can't sleep in any 
callback-registered wakeups, like epoll, for example.



- Davide


