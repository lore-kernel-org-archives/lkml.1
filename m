Return-Path: <linux-kernel-owner+w=401wt.eu-S1760340AbZC3U07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760340AbZC3U07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 16:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760405AbZC3U0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 16:26:35 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:21738 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbZC3U0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 16:26:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=fPnwmv0WXRUVhIozjBk6uygw4S92eSKpKR+60mUffUmFBhIhiXkCTup7kQqWiplhR7
         pnP/X3JSQk4JSmqit3vxTPhh14jCNl0+xnNGhj91USqjWJn+U2+LtpDGao1Ue/Cpbm2j
         dDMdVJqJF4Uy70HqbAKbLTfKSX4+kMtDT6New=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] de: drivers/ide/ide-atapi.c needs <linux/scatterlist.h>
Date: Mon, 30 Mar 2009 22:29:31 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090327-dirty; KDE/4.2.1; i686; ; )
Cc: linux-ide@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Dmitri Vorobiev <dmitri.vorobiev@movial.com>
References: <Pine.LNX.4.64.0903292229400.23398@anakin>
In-Reply-To: <Pine.LNX.4.64.0903292229400.23398@anakin>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903302229.31846.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 29 March 2009, Geert Uytterhoeven wrote:
> On m68k:
> | drivers/ide/ide-atapi.c: In function 'ide_io_buffers':
> | drivers/ide/ide-atapi.c:87: error: implicit declaration of function 'sg_page'
> | drivers/ide/ide-atapi.c:87: warning: passing argument 1 of 'PageHighMem' makes pointer from integer without a cast
> | drivers/ide/ide-atapi.c:91: warning: passing argument 1 of 'kmap_atomic' makes pointer from integer without a cast
> | drivers/ide/ide-atapi.c:96: error: implicit declaration of function 'sg_virt'
> | drivers/ide/ide-atapi.c:96: warning: assignment makes pointer from integer without a cast
> | drivers/ide/ide-atapi.c:107: error: implicit declaration of function 'sg_next'
> | drivers/ide/ide-atapi.c:107: warning: assignment makes pointer from integer without a cast
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

thanks, applied

[ Dmitri, sorry but m68k was faster than MIPS this time ;) ]

> ---
> No idea where it got introduced. 2.6.29 was fine.

Hmm... the issue went unnoticed because it was mitigated in linux-next
by ide_pio_bytes() conversion (resulting in ide_io_buffers() removal)...

>  drivers/ide/ide-atapi.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
> index 6adc5b4..445d157 100644
> --- a/drivers/ide/ide-atapi.c
> +++ b/drivers/ide/ide-atapi.c
> @@ -6,6 +6,8 @@
>  #include <linux/cdrom.h>
>  #include <linux/delay.h>
>  #include <linux/ide.h>
> +#include <linux/scatterlist.h>
> +
>  #include <scsi/scsi.h>
>  
>  #ifdef DEBUG
