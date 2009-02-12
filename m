Return-Path: <linux-kernel-owner+w=401wt.eu-S1760206AbZBLUPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760206AbZBLUPS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 15:15:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757483AbZBLUPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 15:15:03 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56811 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757158AbZBLUPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 15:15:02 -0500
Date: Thu, 12 Feb 2009 12:13:29 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
       Bryan Wu <cooloney@kernel.org>, uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [ltt-dev] [RFC git tree] Userspace RCU (urcu) for Linux
 (repost)
In-Reply-To: <20090212200249.GG6759@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.00.0902121210120.3099@localhost.localdomain>
References: <20090211185203.GA29852@Krystal> <20090211200903.GG6694@linux.vnet.ibm.com> <20090211214258.GA32407@Krystal> <20090212003549.GU6694@linux.vnet.ibm.com> <20090212023308.GA21157@linux.vnet.ibm.com> <20090212040824.GA12346@Krystal>
 <20090212050120.GA8317@linux.vnet.ibm.com> <20090212070539.GA15896@Krystal> <20090212164621.GC6759@linux.vnet.ibm.com> <20090212192941.GC2047@Krystal> <20090212200249.GG6759@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 12 Feb 2009, Paul E. McKenney wrote:
> 
> Actually the best way to do this would be:
> 
> 	while (ACCESS_ONCE(sig_done) < 1)
> 		continue;
> 
> If ACCESS_ONCE() needs to be made architecture-specific to make this
> really work on Blackfin, we should make that change.

I really wouldn't want to mix up compiler barriers and cache barriers this 
way. 

I think "cpu_relax()" is likely the right thing to piggy-back on for 
broken cache-coherency.

> And, now that you mention it, I have heard rumors that other CPU 
> families can violate cache coherence in some circumstances.

I personally suspect that the BF pseudo-SMP code is just broken, and that 
it likely has tons of subtle bugs and races - because we _do_ depend on 
cache coherency at least for accessing objects next to each other. I just 
never personally felt like I had the energy to care deeply enough.

But I draw the line at making ACCESS_ONCE() imply anything but a compiler 
optimization issue.

		Linus
