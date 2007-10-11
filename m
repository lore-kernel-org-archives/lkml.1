Return-Path: <linux-kernel-owner+w=401wt.eu-S1757531AbXJKLtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531AbXJKLtm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 07:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753746AbXJKLte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 07:49:34 -0400
Received: from emerald.lightlink.com ([205.232.34.14]:2254 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbXJKLtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 07:49:33 -0400
Date: Thu, 11 Oct 2007 07:45:56 -0400
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Roel Kluin <12o3l@tiscali.nl>, Jean Delvare <khali@linux-fr.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       haveblue@us.ibm.com
Subject: Re: [PATCH] ibmpex: Release IPMI user if hwmon registration fails
Message-ID: <20071011114556.GE3994@jupiter.solarsys.private>
References: <20070827211446.GG32667@tree.beaverton.ibm.com> <20070828015029.GA10107@khazad-dum.debian.net> <20070828131942.18449886@hyperion.delvare> <20070828164905.GM32667@tree.beaverton.ibm.com> <20070828232504.GP32667@tree.beaverton.ibm.com> <20070911132335.GJ31992@jupiter.solarsys.private> <20070914193346.GM30825@tree.beaverton.ibm.com> <20071009120044.GP3835@jupiter.solarsys.private> <470BAFD7.10305@tiscali.nl> <20071009220824.GL16752@tree.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071009220824.GL16752@tree.beaverton.ibm.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi:

* Darrick J. Wong <djwong@us.ibm.com> [2007-10-09 15:08:24 -0700]:
> Roel Kluin <12o3l@tiscali.nl> found a minor defect in the init code if
> hwmon device registration fails.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
>  drivers/hwmon/ibmpex.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hwmon/ibmpex.c b/drivers/hwmon/ibmpex.c
> index fe2c261..c462824 100644
> --- a/drivers/hwmon/ibmpex.c
> +++ b/drivers/hwmon/ibmpex.c
> @@ -498,8 +498,7 @@ static void ibmpex_register_bmc(int iface, struct device *dev)
>  		printk(KERN_ERR DRVNAME ": Error, unable to register hwmon "
>  		       "class device for interface %d\n",
>  		       data->interface);
> -		kfree(data);
> -		return;
> +		goto out_user;
>  	}
>  
>  	/* finally add the new bmc data to the bmc data list */

Applied to hwmon-2.6.git/testing, thanks.

-- 
Mark M. Hoffman
mhoffman@lightlink.com

