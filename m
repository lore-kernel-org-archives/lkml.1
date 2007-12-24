Return-Path: <linux-kernel-owner+w=401wt.eu-S1752380AbXLXP22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380AbXLXP22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 10:28:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750977AbXLXP2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 10:28:21 -0500
Received: from yue.linux-ipv6.org ([203.178.140.15]:44348 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbXLXP2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 10:28:20 -0500
Date: Tue, 25 Dec 2007 00:29:00 +0900 (JST)
Message-Id: <20071225.002900.00703855.yoshfuji@linux-ipv6.org>
To: julia@diku.dk
Cc: rolandd@cisco.com, mshefty@ichips.intel.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 15/38] drivers/infiniband: Use time_before,
 time_before_eq, etc.
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <Pine.LNX.4.64.0712241528140.23999@ask.diku.dk>
References: <Pine.LNX.4.64.0712241528140.23999@ask.diku.dk>
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

In article <Pine.LNX.4.64.0712241528140.23999@ask.diku.dk> (at Mon, 24 Dec 2007 15:28:42 +0100 (CET)), Julia Lawall <julia@diku.dk> says:

> diff -r -u -p a/drivers/infiniband/hw/ipath/ipath_mad.c b/drivers/infiniband/hw/ipath/ipath_mad.c
> --- a/drivers/infiniband/hw/ipath/ipath_mad.c	2007-10-22 11:25:09.000000000 +0200
> +++ b/drivers/infiniband/hw/ipath/ipath_mad.c	2007-12-23 20:35:37.000000000 +0100
> @@ -1334,7 +1334,8 @@ static int process_subn(struct ib_device
>  	}
>  
>  	/* Is the mkey in the process of expiring? */
> -	if (dev->mkey_lease_timeout && jiffies >= dev->mkey_lease_timeout) {
> +	if (dev->mkey_lease_timeout &&
> +	    time_before_eq(jiffies, dev->mkey_lease_timeout)) {
>  		/* Clear timeout and mkey protection field. */
>  		dev->mkey_lease_timeout = 0;
>  		dev->mkeyprot = 0;

time_after_eq()

--yoshfuji
