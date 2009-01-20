Return-Path: <linux-kernel-owner+w=401wt.eu-S1762187AbZATThd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762187AbZATThd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 14:37:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755388AbZATThY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 14:37:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36953 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292AbZATThX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 14:37:23 -0500
Date: Tue, 20 Jan 2009 20:37:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
       jeremy@xensource.com, chrisw@sous-sol.org, zach@vmware.com,
       rusty@rustcorp.com.au, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: lmbench lat_mmap slowdown with CONFIG_PARAVIRT
Message-ID: <20090120193703.GA27930@elte.hu>
References: <20090120110542.GE19505@wotan.suse.de> <20090120112634.GA20858@elte.hu> <20090120140324.GA26424@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090120140324.GA26424@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> -----------------------------------------------
> | Performance counter stats for './mmap-perf' |
> -----------------------------------------------
> |                |
> |  x86-defconfig |   PARAVIRT=y         
> |------------------------------------------------------------------
> |
> |    1311.554526 |  1360.624932  task clock ticks (msecs)    +3.74%
> |                |
> |              1 |            1  CPU migrations
> |             91 |           79  context switches
> |          55945 |        55943  pagefaults
> |    ............................................
> |     3781392474 |   3918777174  CPU cycles                  +3.63%
> |     1957153827 |   2161280486  instructions               +10.43%
> |       50234816 |     51303520  cache references            +2.12%
> |        5428258 |      5583728  cache misses                +2.86%
> |                |
> |    1314.782469 |  1363.694447  time elapsed (msecs)        +3.72%
> |                |
> -----------------------------------
> 
> The most surprising element is that in the paravirt_ops case we run 204 
> million more instructions - out of the ~2000 million instructions total.

So because this test does exactly 1 million MM syscalls, the average is 
easy to calculate:

The native kernel's average MM syscall cost is 1957 instructions - with 
CONFIG_PARAVIRT=y that increases by +10.43% to 2161 instructions. There's 
over 200 extra instructions executed per MM syscall that we only do due to 
CONFIG_PARAVIRT=y.

	Ingo
