Return-Path: <linux-kernel-owner+w=401wt.eu-S1753575AbXDREmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbXDREmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 00:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbXDREmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 00:42:36 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1772 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558AbXDREmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 00:42:35 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 17 Apr 2007 21:42:34 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: William Lee Irwin III <wli@holomorphy.com>
cc: Matt Mackall <mpm@selenic.com>, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <npiggin@suse.de>, Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       ck list <ck@vds.kolivas.org>, Bill Huey <billh@gnuppy.monkey.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
In-Reply-To: <20070418042904.GY8915@holomorphy.com>
Message-ID: <Pine.LNX.4.64.0704172141051.32323@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0704162317330.30516@alien.or.mcafeemobile.com>
 <20070417070949.GR8915@holomorphy.com> <20070417073308.GB30559@elte.hu>
 <20070417090538.GU8915@holomorphy.com> <20070417092422.GA19414@elte.hu>
 <20070417220809.GF11166@waste.org> <20070417223256.GP2986@holomorphy.com>
 <20070417223909.GO11115@waste.org> <20070417225902.GQ2986@holomorphy.com>
 <20070417225723.GP11115@waste.org> <20070418042904.GY8915@holomorphy.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2007, William Lee Irwin III wrote:

> 100**(1/39.0) ~= 1.12534 may do if so, but it seems a little weak, and
> even 1000**(1/39.0) ~= 1.19378 still seems weak.
> 
> I suspect that in order to get low nice numbers strong enough without
> making high nice numbers too strong something sub-exponential may need
> to be used. Maybe just picking percentages outright as opposed to some
> particular function.
> 
> We may also be better off defining it in terms of a share weighting as
> opposed to two tasks in competition. In such a manner the extension to
> N tasks is more automatic. f(n) would be a univariate function of nice
> numbers and two tasks in competition with nice numbers n_1 and n_2
> would get shares f(n_1)/(f(n_1)+f(n_2)) and f(n_2)/(f(n_1)+f(n_2)). In
> the exponential case f(n) = K*e**(r*n) this ends up as
> 1/(1+e**(r*(n_2-n_1))) which is indeed a function of n_1-n_2 but for
> other choices it's not so. f(n) = n+K for K >= 20 results in a share
> weighting of (n_1+K,n_2+K)/(n_1+n_2+2*K), which is not entirely clear
> in its impact. My guess is that f(n)=1/(n+1) when n >= 0 and f(n)=1-n
> when n <= 0 is highly plausible. An exponent or an additive constant
> may be worthwhile to throw in. In this case, f(-19) = 20, f(20) = 1/21,
> and the ratio of shares is 420, which is still arithmeticaly feasible.
> -10 vs. 0 and 0 vs. 10 are both 10:1.

This makes more sense, and the ratio at the extremes is something 
reasonable.



- Davide


