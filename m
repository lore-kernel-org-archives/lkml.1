Return-Path: <linux-kernel-owner+w=401wt.eu-S1760857AbZBLVQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760857AbZBLVQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 16:16:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753560AbZBLVQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 16:16:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36831 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751003AbZBLVQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 16:16:09 -0500
Date: Thu, 12 Feb 2009 13:15:08 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
       Bryan Wu <cooloney@kernel.org>, uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [ltt-dev] [RFC git tree] Userspace RCU (urcu) for Linux
 (repost)
In-Reply-To: <20090212203924.GK6759@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.00.0902121247040.3099@localhost.localdomain>
References: <20090211214258.GA32407@Krystal> <20090212003549.GU6694@linux.vnet.ibm.com> <20090212023308.GA21157@linux.vnet.ibm.com> <20090212040824.GA12346@Krystal> <20090212050120.GA8317@linux.vnet.ibm.com> <20090212070539.GA15896@Krystal>
 <20090212164621.GC6759@linux.vnet.ibm.com> <20090212192941.GC2047@Krystal> <20090212200249.GG6759@linux.vnet.ibm.com> <alpine.LFD.2.00.0902121210120.3099@localhost.localdomain> <20090212203924.GK6759@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 12 Feb 2009, Paul E. McKenney wrote:
> 
> In other words, you are arguing for using ACCESS_ONCE() in the loops,
> but keeping the old ACCESS_ONCE() definition, and declaring BF hardware
> broken?

Well, I _also_ argue that if you have a busy loop, you'd better have a 
cpu_relax() in there somewhere anyway. If you don't, you have a bug.

So I think the BF approach is "borderline broken", but I think it should 
work, if BF just has whatever appropriate cache flush in its cpu_relax.

			Linus
