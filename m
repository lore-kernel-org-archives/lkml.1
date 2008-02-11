Return-Path: <linux-kernel-owner+w=401wt.eu-S1759620AbYBKRRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620AbYBKRRl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 12:17:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759323AbYBKRRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 12:17:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:29981 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758437AbYBKRRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 12:17:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,334,1199692800"; 
   d="scan'208";a="338156814"
Message-ID: <47B082C5.5080207@intel.com>
Date: Mon, 11 Feb 2008 09:15:49 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: e1000-devel@lists.sourceforge.net, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [E1000-devel] [PATCH 6/8] drivers/net/igb: Use FIELD_SIZEOF
References: <Pine.LNX.4.64.0802102113480.23906@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0802102113480.23906@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Feb 2008 17:16:40.0107 (UTC) FILETIME=[DD8D9FB0:01C86CD1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Robert P.J. Day proposed to use the macro FIELD_SIZEOF in replace of code
> that matches its definition.


thanks for the (3) patches, I'll make sure they get merged.

Cheers,

Auke


> 
> The modification was made using the following semantic patch
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @haskernel@
> @@
> 
> #include <linux/kernel.h>
> 
> @depends on haskernel@
> type t;
> identifier f;
> @@
> 
> - (sizeof(((t*)0)->f))
> + FIELD_SIZEOF(t, f)
> 
> @depends on haskernel@
> type t;
> identifier f;
> @@
> 
> - sizeof(((t*)0)->f)
> + FIELD_SIZEOF(t, f)
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
> 
> diff -u -p a/drivers/net/igb/igb_ethtool.c b/drivers/net/igb/igb_ethtool.c
> --- a/drivers/net/igb/igb_ethtool.c 2008-02-02 15:28:20.000000000 +0100
> +++ b/drivers/net/igb/igb_ethtool.c 2008-02-10 18:06:35.000000000 +0100
> @@ -43,7 +43,7 @@ struct igb_stats {
>  	int stat_offset;
>  };
>  
> -#define IGB_STAT(m) sizeof(((struct igb_adapter *)0)->m), \
> +#define IGB_STAT(m) FIELD_SIZEOF(struct igb_adapter, m), \
>  		      offsetof(struct igb_adapter, m)
>  static const struct igb_stats igb_gstrings_stats[] = {
>  	{ "rx_packets", IGB_STAT(stats.gprc) },
> 
> -------------------------------------------------------------------------
> This SF.net email is sponsored by: Microsoft
> Defy all challenges. Microsoft(R) Visual Studio 2008.
> http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
> _______________________________________________
> E1000-devel mailing list
> E1000-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/e1000-devel

