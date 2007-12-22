Return-Path: <linux-kernel-owner+w=401wt.eu-S1755708AbXLVIfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708AbXLVIfb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 03:35:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751107AbXLVIfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 03:35:25 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:45633 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922AbXLVIfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 03:35:24 -0500
Date: Sat, 22 Dec 2007 09:37:17 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Yuusei KUWANA <kuwana@nyanyan.to>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       mikael.starvik@axis.com
Subject: Re: [PATCH] arch/cris/arch-v10/vmlinux.lds.S fix boot problem
Message-ID: <20071222083717.GB22653@uranus.ravnborg.org>
References: <47636D45.6010006@nyanyan.to> <20071221151404.GM10888@axis.com> <20071221155446.GN10888@axis.com> <20071221160718.GO10888@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071221160718.GO10888@axis.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesper.

>  		__initramfs_end = .;
> -		/* We fill to the next page, so we can discard all init
> -		   pages without needing to consider what payload might be
> -		   appended to the kernel image.  */
> -		FILL (0); 
> -		. = ALIGN (8192);
>  	}
>  #endif
> -	
>  	__vmlinux_end = .;            /* last address of the physical file */
> -  	__init_end = .;
> +
> +	/*
> +	 * We fill to the next page, so we can discard all init
> +	 * pages without needing to consider what payload might be
> +	 * appended to the kernel image.
> +	 */
> +	.init.fill : {
> +		FILL (0);
> +		. = ALIGN (8192);
> +	}
> +
> +	__init_end = .;

Can we please have the hardcoded 8192 replaced with a proper constant.
I assume this is PAGESIZE?
See hwat other archs does to make PAGESIZE available for assembly
files and ldscripts. The macro AC is the key point here.

And then please explain why it make a diffrence to put the
alignment in a section like you do.
I do not see it used in the other archs.

	Sam
