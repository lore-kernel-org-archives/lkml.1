Return-Path: <linux-kernel-owner+w=401wt.eu-S1761461AbYALFrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761461AbYALFrd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 00:47:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbYALFrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 00:47:24 -0500
Received: from yue.linux-ipv6.org ([203.178.140.15]:34818 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbYALFrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 00:47:23 -0500
Date: Sat, 12 Jan 2008 14:47:29 +0900 (JST)
Message-Id: <20080112.144729.67503025.yoshfuji@linux-ipv6.org>
To: vaf@cisco.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       yoshfuji@linux-ipv6.org, davem@davemloft.net
Subject: Re: [PATCH 001/001] ipv4: enable use of 240/4 address space
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <20080108011057.GA21168@cisco.com>
References: <20080108011057.GA21168@cisco.com>
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

Hello.

In article <20080108011057.GA21168@cisco.com> (at Mon, 7 Jan 2008 17:10:57 -0800), Vince Fuller <vaf@cisco.com> says:

>  #define IN_MULTICAST_NET	0xF0000000
>  
> +#define IN_CLASSE(a)		((((long int) (a)) & 0xf0000000) == 0xf0000000)
> +#define	IN_CLASSE_NET		0xffffff00
> +#define	IN_CLASSE_NSHIFT	8
> +#define	IN_CLASSE_HOST		(0xffffffff & ~IN_CLASSE_NET)
> +
> +/* 
> + * these are no longer used
>  #define	IN_EXPERIMENTAL(a)	((((long int) (a)) & 0xf0000000) == 0xf0000000)
>  #define	IN_BADCLASS(a)		IN_EXPERIMENTAL((a))
> +*/

Please do not remove this, but have these instead:

#define IN_EXPERIMENTAL(a)	IN_CLASSE((a))
#define IN_BADCASS(a)		IN_CLASSE((a))

And, I think it is good to remove BADCLASS() (inside
#ifdef __KERNEL__ .. #endif) because we do not have its users
any longer, right?

Regards,

--yoshfuji
