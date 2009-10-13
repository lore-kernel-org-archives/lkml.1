Return-Path: <linux-kernel-owner+w=401wt.eu-S1759116AbZJMHtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759116AbZJMHtr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 03:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759089AbZJMHtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 03:49:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759030AbZJMHtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 03:49:45 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <817ecb6f0910121803p52a4049ep4a712545d28bba76@mail.gmail.com>
References: <817ecb6f0910121803p52a4049ep4a712545d28bba76@mail.gmail.com>
To: Siarhei Liakh <sliakh.lkml@gmail.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Aristeu Rozanski <aris@redhat.com>
Subject: Re: [PATCH V5] x86: NX protection for kernel data
Date: Tue, 13 Oct 2009 08:48:38 +0100
Message-ID: <16086.1255420118@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Siarhei Liakh <sliakh.lkml@gmail.com> wrote:

> This patch expands functionality of CONFIG_DEBUG_RODATA to set main
> (static) kernel data area as NX.
> The following steps are taken to achieve this:
> 1. Linker script is adjusted so .text always starts and ends on a page boundary
> 2. Linker script is adjusted so .rodata and .data always start and
> end on a page boundary
> 3. void mark_nxdata_nx(void) added to arch/x86/mm/init.c with actual
> functionality: NX is set for all pages from _etext through _end.
> 4. mark_nxdata_nx() called from free_initmem() (after init has been released)
> 5. free_init_pages() sets released memory NX in arch/x86/mm/init.c
> 
> The patch have been developed for Linux 2.6.31-rc7 x86 by Siarhei Liakh
> <sliakh.lkml@gmail.com> and Xuxian Jiang <jiang@cs.ncsu.edu>.
> 
> V1:  initial patch for 2.6.30
> V2:  patch for 2.6.31-rc7
> V3:  moved all code into arch/x86, adjusted credits
> V4:  fixed ifdef, removed credits from CREDITS
> V5:  fixed an address calculation bug in mark_nxdata_nx()
> ---
> 
> Signed-off-by: Siarhei Liakh <sliakh.lkml@gmail.com>
> Signed-off-by: Xuxian Jiang <jiang@cs.ncsu.edu>

That seems to fix the problem, thanks.

Acked-by: David Howells <dhowells@redhat.com>
