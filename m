Return-Path: <linux-kernel-owner+w=401wt.eu-S1758426AbYARB0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758426AbYARB0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 20:26:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759292AbYARB01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 20:26:27 -0500
Received: from yue.linux-ipv6.org ([203.178.140.15]:35489 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758858AbYARB0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 20:26:25 -0500
Date: Fri, 18 Jan 2008 10:26:35 +0900 (JST)
Message-Id: <20080118.102635.01689255.yoshfuji@linux-ipv6.org>
To: jengelh@computergmbh.de
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       ak@suse.de, vaf@cisco.com, yoshfuji@linux-ipv6.org
Subject: Re: [PATCH] IPv4: Enable use of 240/4 address space
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <Pine.LNX.4.64.0801180023450.18447@fbirervta.pbzchgretzou.qr>
References: <20080108011057.GA21168@cisco.com>
	<Pine.LNX.4.64.0801180023450.18447@fbirervta.pbzchgretzou.qr>
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

In article <Pine.LNX.4.64.0801180023450.18447@fbirervta.pbzchgretzou.qr> (at Fri, 18 Jan 2008 02:13:52 +0100 (CET)), Jan Engelhardt <jengelh@computergmbh.de> says:

> diff --git a/include/linux/in.h b/include/linux/in.h
> index 27d8a5a..b01bf75 100644
> --- a/include/linux/in.h
> +++ b/include/linux/in.h
> @@ -216,9 +216,6 @@ struct sockaddr_in {
>  #define	IN_MULTICAST(a)		IN_CLASSD(a)
>  #define IN_MULTICAST_NET	0xF0000000
>  
> -#define	IN_EXPERIMENTAL(a)	((((long int) (a)) & 0xf0000000) == 0xf0000000)
> -#define	IN_BADCLASS(a)		IN_EXPERIMENTAL((a))
> -
>  /* Address to accept any incoming messages. */
>  #define	INADDR_ANY		((unsigned long int) 0x00000000)
>  

No, please keep these macros.

> @@ -264,7 +261,7 @@ static inline bool ipv4_is_local_multicast(__be32 addr)
>  
>  static inline bool ipv4_is_badclass(__be32 addr)
>  {
> -	return (addr & htonl(0xf0000000)) == htonl(0xf0000000);
> +	return addr == 0xFFFFFFFF;
>  }
>  

To (un)align the IN_BADCLASS macro and ipv6_is_badclass() definition,
you should change the name anyway, e.g., ipv6_is_limited_broadcast()
or some something alike.

--yoshfuji
