Return-Path: <linux-kernel-owner+w=401wt.eu-S1752131AbXHUUl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbXHUUl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 16:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbXHUUkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 16:40:45 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:40605 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbXHUUkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 16:40:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=dXYpx2vqqYEo0D6FX1E+HkyeeSIpQiDdfd56kz+nt188ntQCER1tNrOucyKhREyFrtNEFBly/9BuColnSgVzyCEFQQs0Bxxo6tovJF9ux0rro6gimx0WI8gMY4rUQnZ+etssEyTyHM9/QT3K/neaT+uG5A8BtDwSKXRRaJNypLs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 2/4] hpt366: UltraDMA filter for SATA cards (take 2)
Date: Tue, 21 Aug 2007 22:36:10 +0200
User-Agent: KMail/1.9.6
Cc: rah@bash.sh, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200708192300.35564.sshtylyov@ru.mvista.com>
In-Reply-To: <200708192300.35564.sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200708212236.10803.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 19 August 2007, Sergei Shtylyov wrote:
> The Marvell bridge chips used on HighPoint SATA cards do not seem to support
> the UltraDMA modes 1, 2, and 3 as well as any MWDMA modes, so the driver needs
> to account for this in the udma_filter() method.  In order to achieve that, do
> the following changes:
> 
> - install the method for all chips, not only HPT36x/370 and impove the code
>   formatting by killing the extra tabs while at it;

s/impove/improve/

> - add to the end of the 'switch' statement in the method cases for HPT372[AN]
>   and HPT374 chips upon which the known SATA cards are based;
> 
> - use hwif->ultra_mask as a default mask for the ide_dma_filter() method to
>   behave correctly;
> 
> - move the HPT370[A] cases below the HPT36x case for consistency.
> 
> While at it, replace the explicit UltraDMA mode masks with ATA_UDMA* constants
> all over the driver...
> 
> Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

applied

> ---
> This is against the current Linus tree and unfortunately I was able to only
> compile test it since that tree gives MODPOST warning and dies early on bootup.

Is this still case?  Not an IDE problem but definitely needs fixing especially
given that we are already in -rc3...

> Will hopefully finish with the patch series next weekend...
