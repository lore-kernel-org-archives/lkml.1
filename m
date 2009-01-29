Return-Path: <linux-kernel-owner+w=401wt.eu-S1757411AbZA2Nd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411AbZA2Nd1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 08:33:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbZA2NdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 08:33:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33019 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbZA2NdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 08:33:17 -0500
Date: Thu, 29 Jan 2009 14:33:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] - UV fix compile error on IA64 & eliminate compiler
	warning
Message-ID: <20090129133308.GE24391@elte.hu>
References: <20090128212104.GA1156@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090128212104.GA1156@sgi.com>
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


* Jack Steiner <steiner@sgi.com> wrote:

> 
> The GRU driver is used on both IA64 & x86.
> The 2 architectures have different ways of detecting the
> platform type, ie. whether the platform is a UV system.
> Although it is possible to reconcile the 2 methods,
> only one place currently makes the test.
> 
> Also eliminate a warning message in uv.h.
> 
> Signed-off-by: Jack Steiner <steiner@sgi.com>
> 
> 
> ---
>  arch/x86/include/asm/uv/uv.h   |    1 +
>  drivers/misc/sgi-gru/gru.h     |    2 --
>  drivers/misc/sgi-gru/grufile.c |    1 +
>  3 files changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux/arch/x86/include/asm/uv/uv.h
> ===================================================================
> --- linux.orig/arch/x86/include/asm/uv/uv.h	2009-01-28 12:43:27.000000000 -0600
> +++ linux/arch/x86/include/asm/uv/uv.h	2009-01-28 15:13:58.000000000 -0600
> @@ -2,6 +2,7 @@
>  #define _ASM_X86_UV_UV_H
>  
>  enum uv_system_type {UV_NONE, UV_LEGACY_APIC, UV_X2APIC, UV_NON_UNIQUE_APIC};
> +struct mm_struct;

hm, why is this needed?

>  #define IS_UV()		is_uv_system()

btw., why is there an ugly IS_UV() macro. All code should be using 
is_uv_system() and IS_UV() should be removed.

	Ingo
