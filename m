Return-Path: <linux-kernel-owner+w=401wt.eu-S1752151AbXLXPZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbXLXPZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 10:25:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751007AbXLXPZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 10:25:15 -0500
Received: from yue.linux-ipv6.org ([203.178.140.15]:44343 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbXLXPZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 10:25:13 -0500
Date: Tue, 25 Dec 2007 00:25:53 +0900 (JST)
Message-Id: <20071225.002553.56248499.yoshfuji@linux-ipv6.org>
To: julia@diku.dk
Cc: jes@sgi.com, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/38] arch/ia64/sn: Use time_before, time_before_eq,
 etc.
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <Pine.LNX.4.64.0712241518040.23999@ask.diku.dk>
References: <Pine.LNX.4.64.0712241518040.23999@ask.diku.dk>
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

In article <Pine.LNX.4.64.0712241518040.23999@ask.diku.dk> (at Mon, 24 Dec 2007 15:18:56 +0100 (CET)), Julia Lawall <julia@diku.dk> says:

> diff -r -u -p a/arch/ia64/sn/kernel/xpc_main.c b/arch/ia64/sn/kernel/xpc_main.c
> --- a/arch/ia64/sn/kernel/xpc_main.c	2007-11-12 10:35:56.000000000 +0100
> +++ b/arch/ia64/sn/kernel/xpc_main.c	2007-12-23 20:32:54.000000000 +0100
> @@ -230,7 +231,7 @@ xpc_hb_beater(unsigned long dummy)
>  {
>  	xpc_vars->heartbeat++;
>  
> -	if (jiffies >= xpc_hb_check_timeout) {
> +	if (time_before_eq(jiffies, xpc_hb_check_timeout)) {
>  		wake_up_interruptible(&xpc_act_IRQ_wq);
>  	}
>  

time_after_eq()

> @@ -270,7 +271,7 @@ xpc_hb_checker(void *ignore)
>  
>  
>  		/* checking of remote heartbeats is skewed by IRQ handling */
> -		if (jiffies >= xpc_hb_check_timeout) {
> +		if (time_before_eq(jiffies, xpc_hb_check_timeout)) {
>  			dev_dbg(xpc_part, "checking remote heartbeats\n");
>  			xpc_check_remote_hb();
>  

ditto.

> @@ -305,7 +306,7 @@ xpc_hb_checker(void *ignore)
>  		/* wait for IRQ or timeout */
>  		(void) wait_event_interruptible(xpc_act_IRQ_wq,
>  			    (last_IRQ_count < atomic_read(&xpc_act_IRQ_rcvd) ||
> -					jiffies >= xpc_hb_check_timeout ||
> +			     time_before_eq(jiffies, xpc_hb_check_timeout) ||
>  						(volatile int) xpc_exiting));
>  	}
>  

ditto.

--yoshfuji
