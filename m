Return-Path: <linux-kernel-owner+w=401wt.eu-S932875AbXK2Q3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932875AbXK2Q3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 11:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761228AbXK2Q30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 11:29:26 -0500
Received: from mga09.intel.com ([134.134.136.24]:51367 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760442AbXK2Q3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 11:29:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,230,1194249600"; 
   d="scan'208";a="217913345"
Message-ID: <474EE8BF.3080107@intel.com>
Date: Thu, 29 Nov 2007 08:28:47 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: Roel Kluin <12o3l@tiscali.nl>
CC: "Kok, Auke" <auke-jan.h.kok@intel.com>,
       lkml <linux-kernel@vger.kernel.org>, e1000-devel@lists.sourceforge.net
Subject: Re: [PATCH] net/e1000: fix memcpy  in e1000_get_strings
References: <474E1BC3.807@tiscali.nl>
In-Reply-To: <474E1BC3.807@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Nov 2007 16:29:21.0378 (UTC) FILETIME=[FEF87420:01C832A4]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin wrote:
> drivers/net/e1000/e1000_ethtool.c:113:
> #define E1000_TEST_LEN sizeof(e1000_gstrings_test) / ETH_GSTRING_LEN
> 
> drivers/net/e1000e/ethtool.c:106:
> #define E1000_TEST_LEN sizeof(e1000_gstrings_test) / ETH_GSTRING_LEN
> 
> E1000_TEST_LEN*ETH_GSTRING_LEN will expand to 
> sizeof(e1000_gstrings_test) / (ETH_GSTRING_LEN * ETH_GSTRING_LEN)
> 
> Please confirm that the change is as wanted.


Thanks,

I'll take a look at this closely and post these to netdev-2.6.

thanks

Auke


> --
> A lack of parentheses around defines causes unexpected results due to operator
> precedences.
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/drivers/net/e1000/e1000_ethtool.c b/drivers/net/e1000/e1000_ethtool.c
> index 667f18b..b83ccce 100644
> --- a/drivers/net/e1000/e1000_ethtool.c
> +++ b/drivers/net/e1000/e1000_ethtool.c
> @@ -1923,7 +1923,7 @@ e1000_get_strings(struct net_device *netdev, uint32_t stringset, uint8_t *data)
>  	switch (stringset) {
>  	case ETH_SS_TEST:
>  		memcpy(data, *e1000_gstrings_test,
> -			E1000_TEST_LEN*ETH_GSTRING_LEN);
> +			sizeof(e1000_gstrings_test));
>  		break;
>  	case ETH_SS_STATS:
>  		for (i = 0; i < E1000_GLOBAL_STATS_LEN; i++) {
> diff --git a/drivers/net/e1000e/ethtool.c b/drivers/net/e1000e/ethtool.c
> index 6a39784..338c49d 100644
> --- a/drivers/net/e1000e/ethtool.c
> +++ b/drivers/net/e1000e/ethtool.c
> @@ -1739,7 +1739,7 @@ static void e1000_get_strings(struct net_device *netdev, u32 stringset,
>  	switch (stringset) {
>  	case ETH_SS_TEST:
>  		memcpy(data, *e1000_gstrings_test,
> -			E1000_TEST_LEN*ETH_GSTRING_LEN);
> +				sizeof(e1000_gstrings_test));
>  		break;
>  	case ETH_SS_STATS:
>  		for (i = 0; i < E1000_GLOBAL_STATS_LEN; i++) {
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
