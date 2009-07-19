Return-Path: <linux-kernel-owner+w=401wt.eu-S1751558AbZGSUQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558AbZGSUQi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 16:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751434AbZGSUQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 16:16:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:51789 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbZGSUQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 16:16:36 -0400
Date: Sun, 19 Jul 2009 13:18:08 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Siarhei Liakh <sliakh.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Ingo Molnar <mingo@elte.hu>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-cris-kernel@axis.com, Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH] x86: NX protection for kernel data
Message-ID: <20090719131808.77f986f3@infradead.org>
In-Reply-To: <817ecb6f0907191243m33cc7369qa09a24416fad7769@mail.gmail.com>
References: <817ecb6f0907191243m33cc7369qa09a24416fad7769@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Jul 2009 15:43:06 -0400
Siarhei Liakh <sliakh.lkml@gmail.com> wrote:

> This patch expands functionality of CONFIG_DEBUG_RODATA to set main
> (static) kernel data area as NX.
> The following steps are taken to achieve this:
> 1. Linker scripts are adjusted so .text always starts and end on a
> page boundary 2. Linker scripts are adjusted so .rodata and .data
> always starts and end on a page boundary
> 3. void mark_nxdata_nx(void) added to arch/x86/mm/init_64.c and
> arch/x86/mm/init_32.c with actual functionality: NX is set for all
> pages from _etext through _edata
> 4. mark_nxdata_nx() called from init_post(void) in init/main.c
> 
> The patch have been developed for Linux 2.6.30 x86 by Siarhei Liakh
> <sliakh.lkml@gmail.com> and Xuxian Jiang <jiang@cs.ncsu.edu>.

I like the idea, and am happy to see the lack of ifdefs ;)

I wonder if we should have a testcase for this though similar to 
how stackprotector and rodata get tested already....
