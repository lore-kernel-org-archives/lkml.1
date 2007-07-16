Return-Path: <linux-kernel-owner+w=401wt.eu-S1760076AbXGPKSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760076AbXGPKSv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 06:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760297AbXGPKSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 06:18:33 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1571 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760003AbXGPKSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 06:18:32 -0400
Date: Mon, 16 Jul 2007 12:18:05 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Ingo Molnar <mingo@elte.hu>
cc: James Bruce <bruce@andrew.cmu.edu>, Thomas Gleixner <tglx@linutronix.de>,
       Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrea Arcangeli <andrea@suse.de>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] CFS: Fix missing digit off in wmult table
In-Reply-To: <20070716070610.GA10907@elte.hu>
Message-ID: <Pine.LNX.4.64.0707161213500.1817@scrub.home>
References: <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu>
 <20070711211638.GE18767@one.firstfloor.org> <20070711214649.GK14435@v2.random>
 <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org>
 <Pine.LNX.4.64.0707130415520.1818@scrub.home> <1184302024.6709.11.camel@Homer.simpson.net>
 <Pine.LNX.4.64.0707131728070.1817@scrub.home> <1184355835.12353.321.camel@chaos>
 <469B0D9E.3030402@andrew.cmu.edu> <20070716070610.GA10907@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 16 Jul 2007, Ingo Molnar wrote:

> yes, the weight multiplier 1.25, but the actual difference in CPU 
> utilization, when running two CPU intense tasks, is ~10%:
> 
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>  8246 mingo     20   0  1576  244  196 R   55  0.0   0:11.96 loop
>  8247 mingo     21   1  1576  244  196 R   45  0.0   0:10.52 loop
> 
> so the first task 'wins' +10% CPU utilization (relative to the 50% it 
> had before), the second task 'loses' -10% CPU utilization (relative to 
> the 50% it had before).

As soon as you add another loop the difference changes again, while it's 
always correct to say it gets 25% more cpu time (which I still think is a 
little too much).

bye, Roman
