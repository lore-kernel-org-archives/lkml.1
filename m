Return-Path: <linux-kernel-owner+w=401wt.eu-S1751690AbXLXPHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690AbXLXPHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 10:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750794AbXLXPHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 10:07:21 -0500
Received: from yue.linux-ipv6.org ([203.178.140.15]:44337 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbXLXPHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 10:07:19 -0500
Date: Tue, 25 Dec 2007 00:07:58 +0900 (JST)
Message-Id: <20071225.000758.105456929.yoshfuji@linux-ipv6.org>
To: julia@diku.dk
Cc: patrick@tykepenguin.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, yoshfuji@linux-ipv6.org
Subject: Re: [PATCH 31/38] net/decnet: Use time_before, time_before_eq, etc.
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <Pine.LNX.4.64.0712241547080.23999@ask.diku.dk>
References: <Pine.LNX.4.64.0712241547080.23999@ask.diku.dk>
Organization: USAGI/WIDE Project
X-URL: http://www.yoshifuji.org/%7Ehideaki/
X-Fingerprint: 9022 65EB 1ECF 3AD1 0BDF  80D8 4807 F894 E062 0EEA
X-PGP-Key-URL: http://www.yoshifuji.org/%7Ehideaki/hideaki@yoshifuji.org.asc
X-Face: "5$Al-.M>NJ%a'@hhZdQm:."qn~PA^gq4o*>iCFToq*bAi#4FRtx}enhuQKz7fNqQz\BYU]
 $~O_5m-9'}MIs`XGwIEscw;e5b>n"B_?j/AkL~i/MEa<!5P`&C$@oP>ZBLP
X-Mailer: Mew version 3.3 on Emacs 20.7 / Mule 4.1 (AOI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <Pine.LNX.4.64.0712241547080.23999@ask.diku.dk> (at Mon, 24 Dec 2007 15:47:32 +0100 (CET)), Julia Lawall <julia@diku.dk> says:

> From: Julia Lawall <julia@diku.dk>
> 
> The functions time_before, time_before_eq, time_after, and time_after_eq
> are more robust for comparing jiffies against other values.


> - jiffies >= E
> + time_after_eq(jiffies,E)


> diff -r -u -p a/net/decnet/af_decnet.c b/net/decnet/af_decnet.c
> --- a/net/decnet/af_decnet.c	2007-11-08 08:00:53.000000000 +0100
> +++ b/net/decnet/af_decnet.c	2007-12-23 20:30:40.000000000 +0100
:
> @@ -601,7 +602,7 @@ int dn_destroy_timer(struct sock *sk)
>  	if (sk->sk_socket)
>  		return 0;
>  
> -	if ((jiffies - scp->stamp) >= (HZ * decnet_time_wait)) {
> +	if (time_before_eq(jiffies, scp->stamp + HZ * decnet_time_wait)) {
>  		dn_unhash_sock(sk);
>  		sock_put(sk);
>  		return 1;

ugh?

> --- a/net/decnet/dn_timer.c	2006-11-30 19:05:46.000000000 +0100
> +++ b/net/decnet/dn_timer.c	2007-12-23 20:30:40.000000000 +0100
> @@ -21,6 +21,7 @@
>  #include <linux/netdevice.h>
>  #include <linux/timer.h>
>  #include <linux/spinlock.h>
> +#include <linux/jiffies.h>
>  #include <net/sock.h>
>  #include <asm/atomic.h>
>  #include <net/flow.h>
> @@ -96,7 +97,7 @@ static void dn_slow_timer(unsigned long 
>  	 * since the last successful transmission.
>  	 */
>  	if (scp->keepalive && scp->keepalive_fxn && (scp->state == DN_RUN)) {
> -		if ((jiffies - scp->stamp) >= scp->keepalive)
> +		if (time_before_eq(jiffies, scp->stamp + scp->keepalive))
>  			scp->keepalive_fxn(sk);
>  	}
>  

ugh?

--yoshfuji
