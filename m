Return-Path: <linux-kernel-owner+w=401wt.eu-S1765978AbYBMI0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765978AbYBMI0E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 03:26:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756647AbYBMIZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 03:25:52 -0500
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:58247 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755846AbYBMIZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 03:25:51 -0500
Message-ID: <47B2A98B.4050408@tiscali.nl>
Date: Wed, 13 Feb 2008 09:25:47 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: marcin.slusarz@gmail.com
CC: LKML <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: be*_add_cpu conversion
References: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com> <1202857582-15450-2-git-send-email-marcin.slusarz@gmail.com>
In-Reply-To: <1202857582-15450-2-git-send-email-marcin.slusarz@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

marcin.slusarz@gmail.com wrote:
> From: Marcin Slusarz <marcin.slusarz@gmail.com>
> 
> replace all:
> big_endian_variable = cpu_to_beX(beX_to_cpu(big_endian_variable) +
> 					expression_in_cpu_byteorder);
> with:
> 	beX_add_cpu(&big_endian_variable, expression_in_cpu_byteorder);
> generated with semantic patch
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David S. Miller <davem@davemloft.net>
> ---
>  crypto/lrw.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/crypto/lrw.c b/crypto/lrw.c
> index 9d52e58..4d93928 100644
> --- a/crypto/lrw.c
> +++ b/crypto/lrw.c
> @@ -92,7 +92,7 @@ struct sinfo {
>  static inline void inc(be128 *iv)
>  {
>  	if (!(iv->b = cpu_to_be64(be64_to_cpu(iv->b) + 1)))

maybe you also want instead of the line above:

	be64_add_cpu(&iv->b, 1);
	if (!iv->b)

> -		iv->a = cpu_to_be64(be64_to_cpu(iv->a) + 1);
> +		be64_add_cpu(&iv->a, 1);
>  }
>  
>  static inline void lrw_round(struct sinfo *s, void *dst, const void *src)

