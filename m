Return-Path: <linux-kernel-owner+w=401wt.eu-S1752495AbYKRH0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbYKRH0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 02:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbYKRH0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 02:26:06 -0500
Received: from gate.crashing.org ([63.228.1.57]:58823 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbYKRH0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 02:26:06 -0500
Subject: Re: Large stack usage in fs code (especially for PPC64)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <alpine.LFD.2.00.0811171522030.18283@nehalem.linux-foundation.org>
References: <alpine.DEB.1.10.0811171508300.8722@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.0811171300410.18283@nehalem.linux-foundation.org>
	 <1226963596.7178.254.camel@pasglop>
	 <alpine.LFD.2.00.0811171522030.18283@nehalem.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 18 Nov 2008 18:25:20 +1100
Message-Id: <1226993120.7178.287.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > It makes some sort of sense I suppose on very static embedded workloads
> > with no swap nor demand paging.
> 
> It makes perfect sense for anything that doesn't use any MMU. 

To a certain extent. There's two different aspects to having an MMU and
in embedded space it's useful to have one and not the other, ie,
protection & address space isolation vs. paging.

Thus, it does make sense for those embedded devices with few files
(mostly a statically linked busybox, a few /dev entries and some app
stuff) to use large page sizes. Of course, as soon as they try to
populate their ramfs with lots of small files they lose... but mostly,
the idea is that the entire working set fits in the TLB and thus the
cost of TLB miss becomes irrelevant.

Now, regarding the shortcomings of the powerpc server MMU, well, we know
them, we know your opinion and mostly share it, and until we can get the
HW to change we are stuck with it.

Cheers,
Ben.


