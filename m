Return-Path: <linux-kernel-owner+w=401wt.eu-S1751508AbZGSUUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbZGSUUP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 16:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbZGSUUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 16:20:14 -0400
Received: from www.tglx.de ([62.245.132.106]:32957 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbZGSUUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 16:20:13 -0400
Date: Sun, 19 Jul 2009 22:18:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Siarhei Liakh <sliakh.lkml@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-cris-kernel@axis.com,
       Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH] x86: NX protection for kernel data
In-Reply-To: <817ecb6f0907191243m33cc7369qa09a24416fad7769@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0907192212100.11571@localhost.localdomain>
References: <817ecb6f0907191243m33cc7369qa09a24416fad7769@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Jul 2009, Siarhei Liakh wrote:

> This patch expands functionality of CONFIG_DEBUG_RODATA to set main
> (static) kernel data area as NX.
> The following steps are taken to achieve this:
> 1. Linker scripts are adjusted so .text always starts and end on a page boundary
> 2. Linker scripts are adjusted so .rodata and .data always starts and
> end on a page boundary
> 3. void mark_nxdata_nx(void) added to arch/x86/mm/init_64.c and
> arch/x86/mm/init_32.c with actual functionality: NX is set for all
> pages from _etext through _edata

Please avoid adding the identical function to both files.
arch/x86/mm/init.c is the correct place.

Thanks,

	tglx
