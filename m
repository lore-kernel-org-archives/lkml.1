Return-Path: <linux-kernel-owner+w=401wt.eu-S1752487AbYKRHtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbYKRHtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 02:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750810AbYKRHtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 02:49:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38489 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbYKRHtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 02:49:05 -0500
Date: Tue, 18 Nov 2008 08:48:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kernel/profile.c: Fix section mismatch warning.
Message-ID: <20081118074850.GC17838@elte.hu>
References: <b9df5fa10811172015w3dfb955bq115180d9d0808d82@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9df5fa10811172015w3dfb955bq115180d9d0808d82@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rakib Mullick <rakib.mullick@gmail.com> wrote:

> Impact: Fix section mismatch warning in kernel/profile.c
> 
> Here, profile_nop function has been called from a non-init function
> create_hash_tables(void). Which generetes a section mismatch warning.
> Previously, create_hash_tables(void) was a init function. So, removing
> __init from create_hash_tables(void) requires profile_nop to be
> non-init. This patch makes profile_nop function inline and fixes the
> following warning:
> 
> WARNING: vmlinux.o(.text+0x6ebb6): Section mismatch in reference from
> the function create_hash_tables() to the function
> .init.text:profile_nop()
> The function create_hash_tables() references
> the function __init profile_nop().
> This is often because create_hash_tables lacks a __init
> annotation or the annotation of profile_nop is wrong.
> 
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> 
> --- linux-2.6-orig/kernel/profile.c	2008-11-17 20:30:42.000000000 +0600
> +++ linux-2.6/kernel/profile.c	2008-11-18 09:39:58.000000000 +0600
> @@ -544,7 +544,7 @@ static const struct file_operations proc
>  };
> 
>  #ifdef CONFIG_SMP
> -static void __init profile_nop(void *unused)
> +static inline void profile_nop(void *unused)
>  {
>  }

applied to tip/core/urgent, thanks!

	Ingo
