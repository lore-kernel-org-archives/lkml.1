Return-Path: <linux-kernel-owner+w=401wt.eu-S1756193AbZFRRu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbZFRRu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 13:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbZFRRuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 13:50:13 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:45583 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbZFRRuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 13:50:12 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 18 Jun 2009 10:44:02 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Gregory Haskins <ghaskins@novell.com>
cc: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [KVM-RFC PATCH 1/2] eventfd: add an explicit srcu based notifier
 interface
In-Reply-To: <4A3A48AB.2080206@novell.com>
Message-ID: <alpine.DEB.1.10.0906181011140.32646@makko.or.mcafeemobile.com>
References: <20090616022041.23890.90120.stgit@dev.haskins.net> <20090616022956.23890.63776.stgit@dev.haskins.net> <20090616140240.GA9401@redhat.com> <4A37A7FC.4090403@novell.com> <20090616143816.GA18196@redhat.com> <4A37B0BB.3020005@novell.com>
 <20090616145502.GA1102@redhat.com> <4A37B832.6040206@novell.com> <20090616154150.GA17494@redhat.com> <4A37C592.2030407@novell.com> <alpine.DEB.1.10.0906160915340.25664@makko.or.mcafeemobile.com> <4A37CFDA.4000602@novell.com>
 <alpine.DEB.1.10.0906170932290.7891@makko.or.mcafeemobile.com> <4A3927C0.5060607@novell.com> <alpine.DEB.1.10.0906171034030.7891@makko.or.mcafeemobile.com> <4A39415C.9060803@novell.com> <alpine.DEB.1.10.0906171247120.7891@makko.or.mcafeemobile.com>
 <4A39649C.4020602@novell.com> <alpine.DEB.1.10.0906171457000.7891@makko.or.mcafeemobile.com> <4A3A48AB.2080206@novell.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Jun 2009, Gregory Haskins wrote:

> Actually there is only one (the tx-thread) aside from the eventfd
> imposed workqueue one.  Incidentally, I would love to get rid of the
> other thread too, so I am not just picking on eventfd ;).  The other is
> a lot harder since it has to update the virtio-ring and may need to page
> in guest memory to do so.

No, there is the interface rx softirq too, that makes two. Plus, the 
process of delivering (especially for KVM & Co.) does not involve only ctx 
switching, there's other stuff in the middle too.
You also talk about latency. Really? Probably RT people aren't looking 
into KVM if RT is even a mild requirement.



> To flip it around on you: try telling a group like the netdev guys that
> they should put extra context switches into the stack because they don't
> really matter.  Be sure to wear extra thick asbestos. ;)

They already do. So you've got to ask yourself why they can achieve Gbps 
throughput already, why can't KVM live with it and being compelled to 
litter an existing interface.



> The fact is that eventfd is a really neat general signaling idiom. 
> However, its currently geared towards "signaling = wakeup".  As we have
> proven with this KVM *fd effort, this is not necessarily accurate to
> describe all use cases, nor is it optimal.  I'd like to address that. 
> An alternative, of course, is that we make a private anon-fd solution
> within KVM.  However, it will be so similar to eventfd so it just seems
> wasteful if it can be avoided.

Even though you take that route, you'll have to prove with replicable real 
life benchmarks, that the bloating make sense.



- Davide


