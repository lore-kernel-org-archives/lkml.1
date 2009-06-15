Return-Path: <linux-kernel-owner+w=401wt.eu-S1755225AbZFONiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbZFONiY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 09:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbZFONiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 09:38:14 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:48554 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbZFONiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 09:38:13 -0400
In-Reply-To: <200906151530.10299.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       linux-arch-owner@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: Re: [PATCH] asm-generic: add EMAXERRNO
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF3F5B9A42.51E93417-ON482575D6.004A27E1-482575D6.004AE1D9@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Mon, 15 Jun 2009 21:33:21 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/06/15 ?? 09:33:21,
	Serialize complete at 2009/06/15 ?? 09:33:21
Content-Type: text/plain; charset="GB2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n5FDd154012487

linux-arch-owner@vger.kernel.org Ğ´ÓÚ 2009-06-15 21:30:09:

> Some architectures want to flag error returns from a syscall based on
> the return value. The range from zero to -511 is for errors that
> we can return to user space, so add a #define for this to
> include/asm-generic/errno.h.
> 
> Reported-by: Chen Liquin <liqin.chen@sunplusct.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  include/asm-generic/errno.h |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> On Monday 15 June 2009, liqin.chen@sunplusct.com wrote:
> 
> > Maybe I can don't use EMAXERRNO in score code. But I think define a 
> > maximum error number in asm-generic/errno.h is better.
> > 
> 
> How about this one?
> 
> diff --git a/include/asm-generic/errno.h b/include/asm-generic/errno.h
> index e8852c0..16bb31d 100644
> --- a/include/asm-generic/errno.h
> +++ b/include/asm-generic/errno.h
> @@ -106,4 +106,8 @@
>  #define   EOWNERDEAD   130   /* Owner died */
>  #define   ENOTRECOVERABLE   131   /* State not recoverable */
> 
> +#ifdef __KERNEL__
> +#define   EMAXERRNO   511   /* maximum errno value we return to user */
> +#endif
> +
>  #endif
> -- 
OK, it is easy to use.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
