Return-Path: <linux-kernel-owner+w=401wt.eu-S1752429AbYLYK7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429AbYLYK7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 05:59:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbYLYK7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 05:59:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44396 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbYLYK7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 05:59:30 -0500
Date: Thu, 25 Dec 2008 11:59:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH for -tip] proc: remove ifdef CONFIG_SPARSE_IRQ from
	stat.c
Message-ID: <20081225105915.GA11560@elte.hu>
References: <20081225194440.50ED.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081225194440.50ED.KOSAKI.MOTOHIRO@jp.fujitsu.com>
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


* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> 
> I confirmed by alpha cross compiler.
> 
> ==
> Subject: [PATCH] proc: remove ifdef CONFIG_SPARSE_IRQ from stat.c
> Impact: cleanup
> 
> commit 240d367b4e6c6e3c5075e034db14dba60a6f5fa7 has a bit strange analysis.
> The fact is, irq_desc() can be used old architecuture too. 
> but old code don't include <linux/irq.h>.
> 
> right fixing is here.

> +#include <linux/irq.h>

looks good, but linux/irq.h cannot be included on all architectures. (for 
example s390 has no notion of 'hardirqs'). But we created linux/irqnr.h 
for this purpose - so including that should work better.

	Ingo
