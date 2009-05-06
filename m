Return-Path: <linux-kernel-owner+w=401wt.eu-S1753656AbZEFHUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbZEFHUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 03:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751310AbZEFHT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 03:19:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34391 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbZEFHT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 03:19:57 -0400
Date: Wed, 6 May 2009 09:18:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: printk %0*X is broken.
Message-ID: <20090506071839.GA14412@elte.hu>
References: <4A0136F4.4010504@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A0136F4.4010504@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Cc:-ed more folks who modified lib/vsprintf.c recently.

	Ingo

* Yinghai Lu <yinghai@kernel.org> wrote:

> it seems someone broke 
> 
> printk(   "%0*X\n", width, x);
> 
> looks like 0 is dumped.
> 
> YH
> 
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 0   00000000 mask FF0 00000000 write-back
> [    0.000000]   1 base 10  00000000 mask FFF 80000000 write-back
> [    0.000000]   2 base 0   80000000 mask FFF 80000000 uncachable
> [    0.000000]   3 base 0   7F800000 mask FFF FF800000 uncachable
> 
> 
> code:
>         for (i = 0; i < num_var_ranges; ++i) {
>                 if (mtrr_state.var_ranges[i].mask_lo & (1 << 11))
>                         printk(KERN_DEBUG "  %u base %0*X%05X000 mask %0*X%05X000 %s\n",
>                                i,
>                                high_width,
>                                mtrr_state.var_ranges[i].base_hi,
>                                mtrr_state.var_ranges[i].base_lo >> 12,
>                                high_width,
>                                mtrr_state.var_ranges[i].mask_hi,
>                                mtrr_state.var_ranges[i].mask_lo >> 12,
>                                mtrr_attrib_to_str(mtrr_state.var_ranges[i].base_lo & 0xff));
>                 else
>                         printk(KERN_DEBUG "  %u disabled\n", i);
>         }
> 
