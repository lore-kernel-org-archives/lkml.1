Return-Path: <linux-kernel-owner+w=401wt.eu-S1755998AbYKITYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998AbYKITYO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 14:24:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755665AbYKITX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 14:23:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42314 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755647AbYKITX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 14:23:57 -0500
Date: Sun, 9 Nov 2008 11:23:39 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: [git pull] scheduler warning fix
In-Reply-To: <20081109071915.GA15556@elte.hu>
Message-ID: <alpine.LFD.2.00.0811091118590.3468@nehalem.linux-foundation.org>
References: <20081109071915.GA15556@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 9 Nov 2008, Ingo Molnar wrote:
> 
> Please pull the latest sched-fixes-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus
> 
> Fixes a silly build warning that slipped through yesterday, sorry 
> about that.

Whaa?

  In file included from /home/torvalds/v2.6/linux/arch/x86/include/asm/timex.h:6,
                   from include/linux/timex.h:202,
                   from include/linux/jiffies.h:8,
                   from include/linux/ktime.h:25,
                   from include/linux/timer.h:5,
                   from include/linux/workqueue.h:8,
                   from include/linux/slub_def.h:11,
                   from include/linux/slab.h:124,
                   from include/linux/percpu.h:5,
                   from include/linux/rcupdate.h:39,
                   from include/linux/tracepoint.h:18,
                   from include/linux/module.h:19,
                   from include/linux/crypto.h:21,
                   from arch/x86/kernel/asm-offsets_64.c:7,
                   from arch/x86/kernel/asm-offsets.c:4:
  /home/torvalds/v2.6/linux/arch/x86/include/asm/tsc.h: In function ¡vget_cycles¢:
  /home/torvalds/v2.6/linux/arch/x86/include/asm/tsc.h:46: error: ¡cycles¢ undeclared (first use in this function)
  /home/torvalds/v2.6/linux/arch/x86/include/asm/tsc.h:46: error: (Each undeclared identifier is reported only once
  /home/torvalds/v2.6/linux/arch/x86/include/asm/tsc.h:46: error: for each function it appears in.)
  make[1]: *** [arch/x86/kernel/asm-offsets.s] Error 1
  make: *** [prepare0] Error 2

That makes no sense. You've apparently done some idiotic rebasing of a 
patch that needs to be applied on top of an earlier patch into a tree that 
does _not_ need it, and then send it as a pull request.

What _are_ you doing?

			Linus
