Return-Path: <linux-kernel-owner+w=401wt.eu-S1753892AbXLETZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbXLETZq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 14:25:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbXLETZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 14:25:38 -0500
Received: from mga03.intel.com ([143.182.124.21]:55420 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689AbXLETZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 14:25:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,255,1194249600"; 
   d="scan'208";a="333564875"
Message-ID: <4756FAAF.7010404@intel.com>
Date: Wed, 05 Dec 2007 11:23:27 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: Roel Kluin <12o3l@tiscali.nl>
CC: lkml <linux-kernel@vger.kernel.org>, e1000-devel@lists.sourceforge.net
Subject: Re: [PATCH] net/e1000: fix memcpy  in e1000_get_strings
References: <474E1BC3.807@tiscali.nl>
In-Reply-To: <474E1BC3.807@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Dec 2007 19:24:01.0062 (UTC) FILETIME=[63D3D460:01C83774]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
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


actually this was recently fixed (with a cleanup to use ARRAY_SIZE!), but I really
like the sizeof() safety in the memcpy anyway, so I'll push this patch anyway.

thanks,

Auke
