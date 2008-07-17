Return-Path: <linux-kernel-owner+w=401wt.eu-S1760010AbYGQR20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760010AbYGQR20 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 13:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755363AbYGQR2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 13:28:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33593 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752088AbYGQR2R (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 13:28:17 -0400
Date: Thu, 17 Jul 2008 10:27:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "V.Radhakrishnan" <rk@atr-labs.com>, Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <Linux-kernel@vger.kernel.org>
Subject: Re: Patch [1/1] minor bugfix in 2.6.26/arch/x86/mm/pat.c - caused
 problems in mmap() of /dev/mem character file
In-Reply-To: <1216315516.2324.10.camel@atlas>
Message-ID: <alpine.LFD.1.10.0807171025110.2959@woody.linux-foundation.org>
References: <1216315516.2324.10.camel@atlas>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 17 Jul 2008, V.Radhakrishnan wrote:
> 
> The above #ifdef must be actually #ifndef and not #ifdef
> The bug does not allow a valid user (root) from accessing /dev/mem even
> though the CONFIG_PROMISC_DEVMEM is NOT selected.

The real bug is that we shouldn't have "double negatives", and certainly 
not negative config options. Making that "promiscuous /dev/mem" option a 
negated thing as a config option was bad.

Ingo, over to you..

		Linus

> --- arch/x86/mm/pat.c.orig	2008-07-17 22:04:18.000000000 +0530
> +++ arch/x86/mm/pat.c	2008-07-17 22:43:39.000000000 +0530
> @@ -471,7 +475,7 @@ pgprot_t phys_mem_access_prot(struct fil
>  	return vma_prot;
>  }
>  
> -#ifdef CONFIG_NONPROMISC_DEVMEM
> +#ifndef CONFIG_NONPROMISC_DEVMEM
>  /* This check is done in drivers/char/mem.c in case of NONPROMISC_DEVMEM*/
>  static inline int range_is_allowed(unsigned long pfn, unsigned long size)
>  {
> @@ -586,4 +590,3 @@ void unmap_devmem(unsigned long pfn, uns
