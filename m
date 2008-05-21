Return-Path: <linux-kernel-owner+w=401wt.eu-S933220AbYEUAi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933220AbYEUAi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756377AbYEUAiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:38:46 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:56888 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbYEUAip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:38:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=h0CGNW9DRcwiHjDeTUl/0li6vJ0uWGZ7R8MK1e/5fBy3i9AmfAtq7FsbjqqSK7hOhF7m1qs+93gbqHcz+nqIJtT/bGW5iKQ/26ItG/HAkHYrR40Ows5gzIpzoyEWPrZIWrJ9dDfip0RuWtXYgxugM9/JnY6DE8QoHwJa4bbgCqo=
Subject: Re: [PATCH] bt8xx: unaligned access
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: mchehab@infradead.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
In-Reply-To: <E1JycFh-0004sc-Re@ZenIV.linux.org.uk>
References: <E1JycFh-0004sc-Re@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Tue, 20 May 2008 17:38:43 -0700
Message-Id: <1211330323.5915.226.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-05-21 at 01:32 +0100, Al Viro wrote:
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  drivers/media/video/bt8xx/bttv-cards.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/bt8xx/bttv-cards.c b/drivers/media/video/bt8xx/bttv-cards.c
> index f20a01c..8ef0424 100644
> --- a/drivers/media/video/bt8xx/bttv-cards.c
> +++ b/drivers/media/video/bt8xx/bttv-cards.c
> @@ -34,6 +34,7 @@
>  #include <linux/firmware.h>
>  #include <net/checksum.h>
>  
> +#include <asm/unaligned.h>
>  #include <asm/io.h>
>  
>  #include "bttvp.h"
> @@ -3858,7 +3859,7 @@ static void __devinit osprey_eeprom(struct bttv *btv, const u8 ee[256])
>  		ee += i;
>  
>  		/* found a valid descriptor */
> -		type = be16_to_cpup((u16*)(ee+4));
> +		type = get_unaligned_be16((__be16 *)(ee+4));

The casts aren't strictly necessary here.  Any reason to keep it?

>  
>  		switch(type) {
>  		/* 848 based */
> @@ -3918,7 +3919,7 @@ static void __devinit osprey_eeprom(struct bttv *btv, const u8 ee[256])
>  			       btv->c.nr, type);
>  			break;
>  		}
> -		serial = be32_to_cpup((u32*)(ee+6));
> +		serial = get_unaligned_be32((__be32 *)(ee+6));

Ditto.

Cheers,

Harvey

