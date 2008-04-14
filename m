Return-Path: <linux-kernel-owner+w=401wt.eu-S1760178AbYDNH1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760178AbYDNH1X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 03:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760005AbYDNH07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 03:26:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41388 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759681AbYDNH06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 03:26:58 -0400
Date: Mon, 14 Apr 2008 09:26:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jacek Luczak <difrost.kernel@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] x86: pgtable_32.h - prototype and section mismatch
	fixes
Message-ID: <20080414072645.GG16163@elte.hu>
References: <48022990.3060104@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48022990.3060104@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0016]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jacek Luczak <difrost.kernel@gmail.com> wrote:

> paravirt_pagetable_setup_[start,done]() is used by __init 
> pagetable_init(). Annotate both functions with __init.

>  #ifndef CONFIG_PARAVIRT
> -static inline void paravirt_pagetable_setup_start(pgd_t *base)
> +static inline void __init paravirt_pagetable_setup_start(pgd_t *base)
>  {
>  	native_pagetable_setup_start(base);
>  }

hm, that's an interesting case: we need those annotations probably 
because gcc decided to not inline those functions. (this is possible via 
the new CONFIG_OPTIMIZE_INLINING=y option) Sam, what's your take on 
that?

	Ingo
