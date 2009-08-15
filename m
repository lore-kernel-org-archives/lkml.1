Return-Path: <linux-kernel-owner+w=401wt.eu-S1754428AbZHONsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbZHONsJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 09:48:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754253AbZHONsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 09:48:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:2359 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662AbZHONsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 09:48:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=sbzzIG//C9a5BIP5b9qIMzeYIN/yJNvrWvqmHlQvlnNJT4TWB7QQDM3NwbJWYZW9Yz
         HYRrIKPQYoIkMoyZXy5pbmffonbTs6Fz7RtJwVO32oQ1GgaGM4c+qX73iHCLxbu3HQoa
         /FUDWhrXvim5mBgtqNQN2igzIrVCDjQwosPLI=
Message-ID: <4A86BC96.9040702@gmail.com>
Date: Sat, 15 Aug 2009 15:48:06 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.1) Gecko/20090715 SUSE/3.0b3-7.4 Thunderbird/3.0b3
MIME-Version: 1.0
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make shr to divide by power of 2 (resend)
References: <20090815134312.GA7533@localdomain.by>
In-Reply-To: <20090815134312.GA7533@localdomain.by>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2009 03:43 PM, Sergey Senozhatsky wrote:
> Make an arithmetic right shift to divide by power of 2.

Why? Is out there a compiler not doing that?

Seems like it should be rather converted to DIV_ROUND_UP.

> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> ---
> diff --git a/drivers/video/console/bitblit.c b/drivers/video/console/bitblit.c
> index 69864b1..b816151 100644
> --- a/drivers/video/console/bitblit.c
> +++ b/drivers/video/console/bitblit.c
> @@ -144,7 +144,7 @@ static void bit_putcs(struct vc_data *vc, struct fb_info *info,
>  		      int fg, int bg)
>  {
>  	struct fb_image image;
> -	u32 width = (vc->vc_font.width + 7)/8;
> +	u32 width = (vc->vc_font.width + 7) >> 3;
>  	u32 cellsize = width * vc->vc_font.height;
>  	u32 maxcnt = info->pixmap.size/cellsize;
>  	u32 scan_align = info->pixmap.scan_align - 1;

