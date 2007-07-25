Return-Path: <linux-kernel-owner+w=401wt.eu-S932487AbXGYXS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487AbXGYXS6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 19:18:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757042AbXGYXSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 19:18:51 -0400
Received: from cantor.suse.de ([195.135.220.2]:40216 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755561AbXGYXSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 19:18:50 -0400
From: Andreas Schwab <schwab@suse.de>
To: Satya <satyakiran@gmail.com>
Cc: linuxppc-dev@ozlabs.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: pte_offset_map for ppc assumes HIGHPTE
References: <acbcf3840707251516w301f834cj5f6a81a494d359ed@mail.gmail.com>
X-Yow: Those aren't WINOS--that's my JUGGLER, my AERIALIST,
 my SWORD SWALLOWER, and my LATEX NOVELTY SUPPLIER!!
Date: Thu, 26 Jul 2007 01:18:48 +0200
In-Reply-To: <acbcf3840707251516w301f834cj5f6a81a494d359ed@mail.gmail.com>
	(Satya's message of "Wed\, 25 Jul 2007 17\:16\:01 -0500")
Message-ID: <jewswodqcn.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satya <satyakiran@gmail.com> writes:

> hello,
> The implementation of pte_offset_map() for ppc assumes that PTEs are
> kept in highmem (CONFIG_HIGHPTE). There is only one implmentation of
> pte_offset_map() as follows (include/asm-ppc/pgtable.h):
>
> #define pte_offset_map(dir, addr)               \
>          ((pte_t *) kmap_atomic(pmd_page(*(dir)), KM_PTE0) + pte_index(addr))
>
> Shouldn't this be made conditional according to CONFIG_HIGHPTE is
> defined or not

kmap_atomic is always defined with or without CONFIG_HIGHPTE.

> (as implemented in include/asm-i386/pgtable.h) ?

I don't think that needs it either.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
