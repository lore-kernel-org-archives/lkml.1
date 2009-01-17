Return-Path: <linux-kernel-owner+w=401wt.eu-S1764183AbZAQQSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764183AbZAQQSd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 11:18:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759919AbZAQQSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 11:18:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44012 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755569AbZAQQSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 11:18:24 -0500
Date: Sat, 17 Jan 2009 17:18:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mikael Pettersson <mikpe@it.uu.se>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: "eliminate warn_on_slowpath()" change causes many gcc-3.2.3
	warnings
Message-ID: <20090117161817.GA10825@elte.hu>
References: <200901171519.n0HFJZuf028704@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901171519.n0HFJZuf028704@harpo.it.uu.se>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3982]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mikael Pettersson <mikpe@it.uu.se> wrote:

> Commit ec5679e513305f1411753e5f5489935bd638af23 "eliminate warn_on_slowpath()"
> changed __WARN() to call warn_slowpath() with a NULL value for the format
> string parameter. Now every WARN_ON() triggers a warning from gcc-3.2.3:
> 
> In file included from include/linux/kmod.h:22,
>                  from include/linux/module.h:13,
>                  from include/linux/crypto.h:21,
>                  from arch/x86/kernel/asm-offsets_32.c:7,
>                  from arch/x86/kernel/asm-offsets.c:2:
> include/linux/gfp.h: In function `allocflags_to_migratetype':
> include/linux/gfp.h:104: warning: null format string
> 
> Compiling kernel 2.6.29-rc2 with a minimalistic .config for my 486
> generates 1767 'null format string' warnings.
> 
> warn_slowpath() is declared with attribute((format(printf, 3, 4))),
> and gcc-3.2.3 warns if the format string parameter is NULL. gcc-3.3
> and newer do not warn in that case.
> 
> Since gcc-3.2 is still a supported compiler for the kernel, this is
> a regression.
> 
> (Just FYI. I don't consider this serious enough to warrant reverting 
> that cleanup patch or declaring gcc-3.2.3 too old. I can always update 
> my 486 to gcc-3.3.6 if the warnings start to bug me too much.)

hm, that's unfortunate. GCC seems totally on crack for not accepting a 
NULL format string.

	Ingo
