Return-Path: <linux-kernel-owner+w=401wt.eu-S1752147Ab0AYH2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab0AYH2B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 02:28:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031Ab0AYH2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 02:28:00 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48205 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab0AYH2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 02:28:00 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mark Seaborn <mrs@mythic-beasts.com>
Subject: Re: futex() on vdso makes process unkillable
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Darren Hart <dvhltc@us.ibm.com>
In-Reply-To: <20100125120459.4944.A69D9226@jp.fujitsu.com>
References: <20100124.000458.506212773266927716.mrs@deli> <20100125120459.4944.A69D9226@jp.fujitsu.com>
Message-Id: <20100125162733.BDB8.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 25 Jan 2010 16:27:56 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> CC to futex folks.
> 
> > I was experimenting with futexes and was a little surprised to
> > discover that futex() works on read-only pages.  This creates quite a
> > high bandwidth side channel that allows two processes to communicate
> > if, for example, they share a library.  (Mind you, this is not much
> > different from file locks, which also work on read-only file
> > descriptors.)
> > 
> > I also found a couple of differences between 2.6.24 (from Ubuntu
> > hardy) and 2.6.31 (from Ubuntu karmic).  The first is a definite bug
> > in 2.6.31:
> > 
> > 1) On 2.6.31 i686, using futex() on the vdso causes the process to get
> > stuck, consuming CPU in an unkillable state.  Both FUTEX_WAIT and
> > FUTEX_WAKE cause the problem.  The problem doesn't occur on 2.6.24.
> > (BTW, I was testing to see whether futex() on the vdso allows any two
> > processes to communicate.  This appears not to be the case on 2.6.24.)
> > 
> > A test program is below.
> > 
> > 
> > 2) Suppose a file is mapped into two processes with MAP_PRIVATE.  Can
> > the resulting mappings be used to communicate via futex()?  i.e. Does
> > futex() consider the mappings to be the same?
> > 
> > On 2.6.24, the futex wakeup is not transferred; pages must be mapped
> > with MAP_SHARED for futex to work.  On 2.6.31, the futex wakeup *is*
> > transferred; futex works with either MAP_SHARED or MAP_PRIVATE.
> > 
> > 2.6.24's behaviour seems more correct, because the mappings are
> > logically different, even if the underlying memory pages are the same
> > before copy-on-write is triggered.  Is 2.6.31's behaviour a
> > regression, or is the kernel's behaviour here supposed to be
> > undefined?

Futex should work both file anon anon. however I personally think 
vdso is not file nor anon. it is special mappings. nobody defined
futex spec on special mappings. (yes, undefined).

Personally, I think EINVAL or EFAULT are best result of vdso futexing, like as
futexing againt kernel address. but I guess another person have another thinking.

I'd like to hear futex folks's opinion.


Thanks.


