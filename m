Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933047Ab0CKPMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 10:12:24 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:60800 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932522Ab0CKPMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 10:12:23 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: Re: [PATCHv2] fs: fat: use pack_hex_byte() instead of custom one
References: <87iq93s013.fsf@devron.myhome.or.jp>
	<1268319614-21252-1-git-send-email-andy.shevchenko@gmail.com>
Date: Fri, 12 Mar 2010 00:12:18 +0900
In-Reply-To: <1268319614-21252-1-git-send-email-andy.shevchenko@gmail.com>
	(Andy Shevchenko's message of "Thu, 11 Mar 2010 17:00:14 +0200")
Message-ID: <87aaueopt9.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Shevchenko <andy.shevchenko@gmail.com> writes:

> From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
>
> Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Looks good to me.

	Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

(From 1/4 with previous patch, I guess it's series of patches) Or I
should take this patch into my tree?

Thanks.

> ---
>  fs/fat/dir.c |   14 +++++---------
>  1 files changed, 5 insertions(+), 9 deletions(-)
>
> diff --git a/fs/fat/dir.c b/fs/fat/dir.c
> index 530b4ca..5de1a70 100644
> --- a/fs/fat/dir.c
> +++ b/fs/fat/dir.c
> @@ -19,6 +19,7 @@
>  #include <linux/buffer_head.h>
>  #include <linux/compat.h>
>  #include <asm/uaccess.h>
> +#include <linux/kernel.h>
>  #include "fat.h"
>  
>  /*
> @@ -149,19 +150,14 @@ static int uni16_to_x8(unsigned char *ascii, const wchar_t *uni, int len,
>  
>  	while (*ip && ((len - NLS_MAX_CHARSET_SIZE) > 0)) {
>  		ec = *ip++;
> -		if ( (charlen = nls->uni2char(ec, op, NLS_MAX_CHARSET_SIZE)) > 0) {
> +		if ((charlen = nls->uni2char(ec, op, NLS_MAX_CHARSET_SIZE)) > 0) {
>  			op += charlen;
>  			len -= charlen;
>  		} else {
>  			if (uni_xlate == 1) {
> -				*op = ':';
> -				for (k = 4; k > 0; k--) {
> -					nc = ec & 0xF;
> -					op[k] = nc > 9	? nc + ('a' - 10)
> -							: nc + '0';
> -					ec >>= 4;
> -				}
> -				op += 5;
> +				*op++ = ':';
> +				op = pack_hex_byte(op, ec >> 8);
> +				op = pack_hex_byte(op, ec);
>  				len -= 5;
>  			} else {
>  				*op++ = '?';

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
