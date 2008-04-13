Return-Path: <linux-kernel-owner+w=401wt.eu-S1754148AbYDMHms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbYDMHms (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 03:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbYDMHml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 03:42:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40961 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbYDMHml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 03:42:41 -0400
Date: Sun, 13 Apr 2008 09:42:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jacek Luczak <difrost.kernel@gmail.com>
Cc: ijc@hellion.org.uk, tglx@linutronix.de,
       LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: *_pagetable_setup_[start,done] crap ?
Message-ID: <20080413074225.GF20332@elte.hu>
References: <4800E134.8040602@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4800E134.8040602@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0011]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jacek Luczak <difrost.kernel@gmail.com> wrote:

> Ohh... and prototypes are wrong:
> diff --git a/include/asm-x86/pgtable_32.h b/include/asm-x86/pgtable_32.h
> index 6cbc520..2167879 100644
> --- a/include/asm-x86/pgtable_32.h
> +++ b/include/asm-x86/pgtable_32.h
> @@ -204,8 +204,8 @@ do {                                                \
>   */
>  #define update_mmu_cache(vma, address, pte) do { } while (0)
> 
> -void native_pagetable_setup_start(pgd_t *base);
> -void native_pagetable_setup_done(pgd_t *base);
> +extern void native_pagetable_setup_start(pgd_t *base) __init;
> +extern void native_pagetable_setup_done(pgd_t *base) __init;

while generally it's nice to add 'extern' to prototypes, it's not an 
outright bug to not have it. Also, __init is a must-have in the 
definition only - it should not be added to the prototype.

	Ingo
