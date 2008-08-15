Return-Path: <linux-kernel-owner+w=401wt.eu-S1760700AbYHORPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760700AbYHORPU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 13:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754270AbYHORPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 13:15:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38892 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664AbYHORPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 13:15:06 -0400
Date: Fri, 15 Aug 2008 19:14:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2] x86: fix section mismatch warning - spp_getpage()
Message-ID: <20080815171451.GA23600@elte.hu>
References: <1218576186-31442-3-git-send-email-marcin.slusarz@gmail.com> <20080813111051.GA18660@elte.hu> <20080813140555.GA18523@elte.hu> <20080815123201.GB5285@joi> <20080815135027.GB14103@elte.hu> <20080815163212.GA5408@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080815163212.GA5408@joi>
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


* Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> -static __init void *spp_getpage(void)
> +/*
> + * NOTE: This function is marked __ref because it calls __init function
> + * (alloc_bootmem_pages). It's safe to do it ONLY when after_bootmem == 0.
> + */
> +static __ref void *spp_getpage(void)

perfect - applied to tip/x86/urgent, thanks Marcin.

	Ingo
