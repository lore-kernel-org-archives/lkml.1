Return-Path: <linux-kernel-owner+w=401wt.eu-S1756361AbZC0Scp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361AbZC0Scp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 14:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754295AbZC0Sch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 14:32:37 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:58309 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbZC0Scg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 14:32:36 -0400
Date: Fri, 27 Mar 2009 19:34:35 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: liqin.chen@sunplusct.com
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 4/13] score - New architecure port to SunplusCT S+CORE processor
Message-ID: <20090327183435.GA21149@uranus.ravnborg.org>
References: <OF7C8E38E6.732D64E1-ON48257586.0008A8A3-48257586.0008F44B@sunplusct.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF7C8E38E6.732D64E1-ON48257586.0008A8A3-48257586.0008F44B@sunplusct.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chen Liqin.

I have browsed throug the code and it generally looks good, especially
for a first posting to lkml.

I will not repeat the advices from Arnd and others.
But only add to that that running your patches through checkpatch
and with a critical mind fix the errors/warnings.
Especially for arch code you cannot blindly assume checkpatch is always right!

A few comments below.

	Sam

> diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
> linux-2.6-git.ori/arch/score/include/asm/pgtable-32.h 
> linux-2.6-git.new/arch/score/include/asm/pgtable-32.h
> --- linux-2.6-git.ori/arch/score/include/asm/pgtable-32.h       1970-01-01 
> 08:00:00.000000000 +0800
> +++ linux-2.6-git.new/arch/score/include/asm/pgtable-32.h       2009-03-23 
> 17:47:05.000000000 +0800
> @@ -0,0 +1,122 @@
> +#ifndef _ASM_PGTABLE_32_H
> +#define _ASM_PGTABLE_32_H
> +
> +#include <linux/linkage.h>
> +#include <asm-generic/pgtable-nopmd.h>
> +#include <asm/page.h>
> +#include <asm/fixmap.h>
> +
> +/* PGDIR_SHIFT determines what a third-level page table entry can map */
> +#define PGDIR_SHIFT    22
> +#define PGDIR_SIZE     (1UL << PGDIR_SHIFT)
> +#define PGDIR_MASK     (~(PGDIR_SIZE-1))

If you include <linux/const.h> then you can use:
#define PGDIR_SIZE (_AC(1,UL) << PGDIR_SHIFT)
This has the advantage that your headerfile is compatible with
assembler and you can use the symbol in your linker scrip too.

> +++ linux-2.6-git.new/arch/score/include/asm/scoreregs.h        2009-03-20 
> 10:43:48.000000000 +0800
> @@ -0,0 +1,65 @@
> +#include <linux/linkage.h>
> +
> +#define IRQ_TIMER (7)  /* IRQ  number of SPG300 */
> +
> +/* TIMER register */
> +#define TIME0Base      0x96080000
> +#define rTIMER0C       (*(volatile unsigned *)(TIME0Base+0x00))
> +#define rTIMER0CPPC    (*(volatile unsigned *)(TIME0Base+0x04))
> +#define rTIMER0CPR     (*(volatile unsigned *)(TIME0Base+0x08))
> +#define rTIMER0CPPR    (*(volatile unsigned *)(TIME0Base+0x0C))
> +#define rTIMER0UC      (*(volatile unsigned *)(TIME0Base+0x10))

The general opinion is that if you say volatile your are doing something
wrong. Explicit memory barriers is the right way to deal with things.
There are longer threads about that you should be able to google.

