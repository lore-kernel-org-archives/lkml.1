Return-Path: <linux-kernel-owner+w=401wt.eu-S1757701AbXG3OxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701AbXG3OxV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 10:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbXG3OxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 10:53:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52410 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880AbXG3OxM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 10:53:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] APM support depends on CONFIG_PM_SLEEP
Date: Mon, 30 Jul 2007 17:01:45 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
References: <20070730201237.67f1a64a.sfr@canb.auug.org.au>
In-Reply-To: <20070730201237.67f1a64a.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707301701.45880.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 30 July 2007 12:12, Stephen Rothwell wrote:
> Commit 296699de6bdc717189a331ab6bbe90e05c94db06 broke building APM
> support if CONFIG_PM_SLEEP is not set.

Sorry for the breakage, my fault.

> Reported by Toralf Förster <toralf.foerster@gmx.de>
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  arch/i386/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --git a/arch/i386/Kconfig b/arch/i386/Kconfig
> index abb582b..7eefa7d 100644
> --- a/arch/i386/Kconfig
> +++ b/arch/i386/Kconfig
> @@ -938,7 +938,7 @@ source "drivers/acpi/Kconfig"
>  
>  menuconfig APM
>  	tristate "APM (Advanced Power Management) BIOS support"
> -	depends on PM && !X86_VISWS
> +	depends on PM && !X86_VISWS && PM_SLEEP

PM_SLEEP depends on PM, so I'd do

+	depends on PM_SLEEP && !X86_VISWS

>  	---help---
>  	  APM is a BIOS specification for saving power using several different
>  	  techniques. This is mostly useful for battery powered laptops with

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
