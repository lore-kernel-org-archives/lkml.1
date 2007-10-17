Return-Path: <linux-kernel-owner+w=401wt.eu-S934609AbXJQVKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934609AbXJQVKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 17:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759904AbXJQVKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 17:10:38 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:36816 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758606AbXJQVKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 17:10:37 -0400
Date: Wed, 17 Oct 2007 14:10:04 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] hwmon/ibmpex.c: fix NULL dereference
Message-ID: <20071017211004.GA31309@tree.beaverton.ibm.com>
References: <20071017192902.GB3778@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017192902.GB3778@stusta.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2007 at 09:29:02PM +0200, Adrian Bunk wrote:
> Don't dereference "data" when we know for sure it's NULL.
> 
> Spotted by the Coverity checker.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 66bec2ef5c6d55fc30ef6ac5bb97fdfcfaf394f2 
> diff --git a/drivers/hwmon/ibmpex.c b/drivers/hwmon/ibmpex.c
> index c462824..e14ce3d 100644
> --- a/drivers/hwmon/ibmpex.c
> +++ b/drivers/hwmon/ibmpex.c
> @@ -457,7 +457,7 @@ static void ibmpex_register_bmc(int iface, struct device *dev)
>  	data = kzalloc(sizeof(*data), GFP_KERNEL);
>  	if (!data) {
>  		printk(KERN_ERR DRVNAME ": Insufficient memory for BMC "
> -		       "interface %d.\n", data->interface);
> +		       "interface.\n");
>  		return;
>  	}
> 
> 
ACK.

--D
