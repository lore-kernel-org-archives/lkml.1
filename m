Return-Path: <linux-kernel-owner+w=401wt.eu-S1753616AbXDIXJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616AbXDIXJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 19:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624AbXDIXJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 19:09:54 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:45750 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753589AbXDIXJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 19:09:54 -0400
Date: Tue, 10 Apr 2007 01:10:00 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: problem in 2.6.21-rc6-mm1: i386-enable-4k-stacks-by-default.patch?
Message-ID: <20070409231000.GB28370@stusta.de>
References: <461ABF63.3040703@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <461ABF63.3040703@goop.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2007 at 03:34:11PM -0700, Jeremy Fitzhardinge wrote:
> --- a/arch/i386/Kconfig.debug~i386-enable-4k-stacks-by-default
> +++ a/arch/i386/Kconfig.debug
> @@ -57,14 +57,16 @@ config DEBUG_RODATA
>  	  If in doubt, say "N".
>  
>  config 4KSTACKS
> -	bool "Use 4Kb for kernel stacks instead of 8Kb"
> -	depends on DEBUG_KERNEL
> +	bool "Use 4Kb for kernel stacks instead of 8Kb" if DEBUG_KERNEL
> +	depends on n
> +	default y
> 
> 
> I don't see this option appear in my .config, and I guess its always
> using 8k stacks.  If I remove the "depends on n", it does what I expect
> it to do (ie, offers me the option).  Is "depends on n" supposed to do
> something, or is it just a bogon?

Looks bogus, and the "depends on n" wasn't in the patch when I sent it.

>     J

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

