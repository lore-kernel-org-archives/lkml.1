Return-Path: <linux-kernel-owner+w=401wt.eu-S934099AbXLQEOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934099AbXLQEOh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 23:14:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756838AbXLQEO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 23:14:27 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:2999 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755963AbXLQEO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 23:14:26 -0500
From: Roman Zippel <zippel@linux-m68k.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] initrd: Fix virtual/physical mix-up in overwrite test
Date: Mon, 17 Dec 2007 05:14:18 +0100
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
References: <Pine.LNX.4.64.0712161148340.5869@anakin>
In-Reply-To: <Pine.LNX.4.64.0712161148340.5869@anakin>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712170514.20465.zippel@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sunday 16 December 2007, Geert Uytterhoeven wrote:

> --- a/init/main.c
> +++ b/init/main.c
> @@ -598,9 +598,9 @@ asmlinkage void __init start_kernel(void
>
>  #ifdef CONFIG_BLK_DEV_INITRD
>  	if (initrd_start && !initrd_below_start_ok &&
> -			initrd_start < min_low_pfn << PAGE_SHIFT) {
> +			virt_to_pfn(initrd_start) < min_low_pfn) {
>  		printk(KERN_CRIT "initrd overwritten (0x%08lx < 0x%08lx) - "
> -		    "disabling it.\n",initrd_start,min_low_pfn << PAGE_SHIFT);
> +		    "disabling it.\n", virt_to_pfn(initrd_start), min_low_pfn);
>  		initrd_start = 0;
>  	}
>  #endif

BTW this is some really old code, so another option might be to remove this 
check completely as the same check is already done via bootmem.

bye, Roman
