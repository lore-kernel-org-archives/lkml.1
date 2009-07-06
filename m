Return-Path: <linux-kernel-owner+w=401wt.eu-S1757344AbZGFBMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344AbZGFBMq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 21:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbZGFBMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 21:12:35 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:58628 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750926AbZGFBMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 21:12:34 -0400
Date: Mon, 6 Jul 2009 09:12:30 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc: Eugene Kapun <abacabadabacaba@gmail.com>, maxk@qualcomm.com,
       linux-net@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: tun/tap crashes if open() /dev/net/tun and then
	poll() it.
Message-ID: <20090706011230.GC15156@gondor.apana.org.au>
References: <4A4F1480.70203@gmail.com> <20090706001114.2d4517be@mako-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090706001114.2d4517be@mako-desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 06, 2009 at 12:11:14AM +0200, Mariusz Kozlowski wrote:
>
> 	Can you try this patch?
> 
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 11a0ba4..c599327 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -486,12 +486,14 @@ static unsigned int tun_chr_poll(struct file *file, poll_table * wait)
>  {
>  	struct tun_file *tfile = file->private_data;
>  	struct tun_struct *tun = __tun_get(tfile);
> -	struct sock *sk = tun->sk;
> +	struct sock *sk;
>  	unsigned int mask = 0;
>  
>  	if (!tun)
>  		return POLLERR;
>  
> +	sk = tun->sk;
> +
>  	DBG(KERN_INFO "%s: tun_chr_poll\n", tun->dev->name);
>  
>  	poll_wait(file, &tun->socket.wait, wait);

Good catch.  Can you please resend with a sign-off?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
