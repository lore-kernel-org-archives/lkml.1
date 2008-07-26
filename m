Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbYGZKRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbYGZKRj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 06:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbYGZKRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 06:17:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34736 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638AbYGZKRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 06:17:32 -0400
Date: Sat, 26 Jul 2008 12:17:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Barry Kasindorf <barry.kasindorf@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 24/24] x86/oprofile: Reanaming op_model_athlon.c to
	op_model_amd.c
Message-ID: <20080726101716.GK25890@elte.hu>
References: <1216753748-11261-1-git-send-email-robert.richter@amd.com> <1216753748-11261-25-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216753748-11261-25-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> +#define NUM_COUNTERS 4
> +#define NUM_CONTROLS 4
> +
> +#define CTR_IS_RESERVED(msrs, c) (msrs->counters[(c)].addr ? 1 : 0)
> +#define CTR_READ(l, h, msrs, c) do {rdmsr(msrs->counters[(c)].addr, (l), (h)); } while (0)
> +#define CTR_WRITE(l, msrs, c) do {wrmsr(msrs->counters[(c)].addr, -(unsigned int)(l), -1); } while (0)
> +#define CTR_OVERFLOWED(n) (!((n) & (1U<<31)))
> +
> +#define CTRL_IS_RESERVED(msrs, c) (msrs->controls[(c)].addr ? 1 : 0)
> +#define CTRL_READ(l, h, msrs, c) do {rdmsr(msrs->controls[(c)].addr, (l), (h)); } while (0)
> +#define CTRL_WRITE(l, h, msrs, c) do {wrmsr(msrs->controls[(c)].addr, (l), (h)); } while (0)
> +#define CTRL_SET_ACTIVE(n) (n |= (1<<22))
> +#define CTRL_SET_INACTIVE(n) (n &= ~(1<<22))
> +#define CTRL_CLEAR_LO(x) (x &= (1<<21))
> +#define CTRL_CLEAR_HI(x) (x &= 0xfffffcf0)
> +#define CTRL_SET_ENABLE(val) (val |= 1<<20)
> +#define CTRL_SET_USR(val, u) (val |= ((u & 1) << 16))
> +#define CTRL_SET_KERN(val, k) (val |= ((k & 1) << 17))
> +#define CTRL_SET_UM(val, m) (val |= (m << 8))
> +#define CTRL_SET_EVENT_LOW(val, e) (val |= (e & 0xff))
> +#define CTRL_SET_EVENT_HIGH(val, e) (val |= ((e >> 8) & 0xf))
> +#define CTRL_SET_HOST_ONLY(val, h) (val |= ((h & 1) << 9))
> +#define CTRL_SET_GUEST_ONLY(val, h) (val |= ((h & 1) << 8))

while at it, it would be nice to have a followup cleanup that aligns 
these vertically.

> +#ifdef CONFIG_OPROFILE_IBS

btw., why not include IBS support unconditionally in the _amd.ko module? 
It's all loadable anyway - and the size difference is small. That would 
get rid of a ton of #ifdef complexity.

	Ingo
