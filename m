Return-Path: <linux-kernel-owner+w=401wt.eu-S1757494AbZA2WnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbZA2WnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 17:43:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753306AbZA2Wm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 17:42:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60977 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573AbZA2Wmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 17:42:55 -0500
Date: Thu, 29 Jan 2009 23:42:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: allow 8 more cpus could be used
Message-ID: <20090129224236.GD1465@elte.hu>
References: <49822B1D.9070708@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49822B1D.9070708@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> Impact: fix left out MARCO
> 
> X86_PC will be always enabled. so need to check if we have bigsmp 
> support built in before cut off more than 8 cpus.

ah, that's a leftover reference to X86_PC. It can now be removed, together 
with the Kconfig X86_PC option.

> -#if defined(CONFIG_X86_PC) && defined(CONFIG_X86_32)
> +#if defined(CONFIG_X86_PC) && !defined(CONFIG_X86_BIGSMP)
>  	if (def_to_bigsmp && nr_cpu_ids > 8) {
>  		unsigned int cpu;
>  		unsigned nr;

Could you please send a patch that removes both X86_PC and X86_BIGSMP - 
and removes the above cutoff code too, so that it will be built-in all the 
time?

	Ingo
