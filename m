Return-Path: <linux-kernel-owner+w=401wt.eu-S932217AbXFCAVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217AbXFCAVc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 20:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762288AbXFCAVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 20:21:24 -0400
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:35830 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760064AbXFCAVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 20:21:24 -0400
Message-ID: <46620979.9020901@punnoor.de>
Date: Sun, 03 Jun 2007 08:21:13 +0800
From: Prakash Punnoor <prakash@punnoor.de>
User-Agent: Thunderbird 2.0.0.0 (Macintosh/20070326)
MIME-Version: 1.0
To: Daniel Hazelton <dhazelton@enter.net>
CC: dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Trivial Patch] Remove JFFS2 dependency on internal Zlib header
References: <200706021520.36478.dhazelton@enter.net>
In-Reply-To: <200706021520.36478.dhazelton@enter.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Hazelton wrote:
> 
> Signed-off-by: Daniel Hazelton <dhazelton@enter.net>
> 
> DRH
> 
> diff --git a/fs/jffs2/compr_zlib.c b/fs/jffs2/compr_zlib.c
> index 2b87fcc..9f1b935 100644
> --- a/fs/jffs2/compr_zlib.c
> +++ b/fs/jffs2/compr_zlib.c
> @@ -16,7 +16,6 @@
>  #include <linux/kernel.h>
>  #include <linux/slab.h>
>  #include <linux/zlib.h>
> -#include <linux/zutil.h>
>  #include "nodelist.h"
>  #include "compr.h"
> 
> @@ -154,7 +153,7 @@ static int jffs2_zlib_decompress(unsigned char *data_in,
> 
>         /* If it's deflate, and it's got no preset dictionary, then
>            we can tell zlib to skip the adler32 check. */
> -       if (srclen > 2 && !(data_in[1] & PRESET_DICT) &&
> +       if (srclen > 2 && !(data_in[1] & 0x20) &&
>             ((data_in[0] & 0x0f) == Z_DEFLATED) &&
>             !(((data_in[0]<<8) + data_in[1]) % 31)) {
> 


Why not

#define PRESET_DICT 0x20

instead of obfuscating the code with a magic number ? (Or name it 
differently if it clashes with something else...)


Cheers,

Prakash
