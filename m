Return-Path: <linux-kernel-owner+w=401wt.eu-S932187AbZKRSVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187AbZKRSVK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 13:21:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758246AbZKRSVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 13:21:07 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:57155 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758217AbZKRSVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 13:21:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=N5wI8VbKpuc3tegB9BJq8csGwnBO1Z9IzaGAZDHegimrkdP3LAe68QS8lZjtT9gzgc
         wc2f0qGjOc+Sf5LkApYPOM06Y6OwJNnkkOClOa50OiZ73mzmei21FkJwIqrxOiKUKcCo
         EI3MHQ3/WoYU107mH6+GRnphNOZvSEcai+p/E=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 4/5] pata: Update experimental tags
Date: Wed, 18 Nov 2009 19:19:19 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20091117144450.15430.83450.stgit@localhost.localdomain> <20091117145137.15430.11229.stgit@localhost.localdomain>
In-Reply-To: <20091117145137.15430.11229.stgit@localhost.localdomain>
MIME-Version: 1.0
Message-Id: <200911181919.19127.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 November 2009 15:51:39 Alan Cox wrote:
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
> 
>  drivers/ata/Kconfig |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
> index f2df6e2..36931e0 100644
> --- a/drivers/ata/Kconfig
> +++ b/drivers/ata/Kconfig
> @@ -374,7 +374,7 @@ config PATA_HPT366
>  	  If unsure, say N.
>  
>  config PATA_HPT37X
> -	tristate "HPT 370/370A/371/372/374/302 PATA support (Experimental)"
> +	tristate "HPT 370/370A/371/372/374/302 PATA support"
>  	depends on PCI && EXPERIMENTAL
>  	help
>  	  This option enables support for the majority of the later HPT
> @@ -383,7 +383,7 @@ config PATA_HPT37X
>  	  If unsure, say N.
>  
>  config PATA_HPT3X2N
> -	tristate "HPT 372N/302N PATA support (Experimental)"
> +	tristate "HPT 372N/302N PATA support"
>  	depends on PCI && EXPERIMENTAL
>  	help
>  	  This option enables support for the N variant HPT PATA

Maybe they are 'stable' but when it comes to features they are behind hpt366
(i.e. they lack PCI PM), which is also much cleaner than your drivers, easier
to understand and much smaller..

 1609 drivers/ide/hpt366.c

  432 drivers/ata/pata_hpt366.c
 1041 drivers/ata/pata_hpt37x.c
  594 drivers/ata/pata_hpt3x2n.c
 2067 total

(we can still easily cut more than 100 LOC from hpt366)

Having separate drivers wasn't the best decisions from the maintainability
point-of-view.   It added needless complexity (different chips share the same
PCI IDs which make detection across multiple drivers extremely painful) and
confusion (i.e. would you have guessed that HPT302 is supported by pata_hpt37x
while HPT302N by pata_hpt3x2n?).

-- 
Bartlomiej Zolnierkiewicz
