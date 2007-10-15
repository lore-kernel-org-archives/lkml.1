Return-Path: <linux-kernel-owner+w=401wt.eu-S1764799AbXJOQVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764799AbXJOQVr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 12:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759478AbXJOQVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 12:21:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:44411 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758102AbXJOQVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 12:21:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,278,1188802800"; 
   d="scan'208";a="299061890"
Message-ID: <47139367.9090400@intel.com>
Date: Mon, 15 Oct 2007 09:20:55 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070911)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Auke Kok <auke-jan.h.kok@intel.com>, Jeff Garzik <jeff@garzik.org>,
       e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] e1000e/ethtool.c: fix error checks
References: <20071014175104.GK4211@stusta.de>
In-Reply-To: <20071014175104.GK4211@stusta.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Oct 2007 16:21:14.0091 (UTC) FILETIME=[67EF9BB0:01C80F47]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> You want to check for the value, not for the address.
> 
> Spotted by the Coverity checker.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> --- a/drivers/net/e1000e/ethtool.c
> +++ b/drivers/net/e1000e/ethtool.c
> @@ -1451,11 +1451,11 @@ static int e1000_loopback_test(struct e1000_adapter *adapter, u64 *data)
>  	}
>  
>  	*data = e1000_setup_desc_rings(adapter);
> -	if (data)
> +	if (*data)
>  		goto out;
>  
>  	*data = e1000_setup_loopback_test(adapter);
> -	if (data)
> +	if (*data)
>  		goto err_loopback;
>  
>  	*data = e1000_run_loopback_test(adapter);

I'll forward this to Jeff,

thanks.

Auke
