Return-Path: <linux-kernel-owner+w=401wt.eu-S965304AbXJQU7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965304AbXJQU7E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 16:59:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759904AbXJQU6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 16:58:53 -0400
Received: from smtp-103-wednesday.nerim.net ([62.4.16.103]:62969 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757655AbXJQU6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 16:58:52 -0400
Date: Wed, 17 Oct 2007 22:58:50 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [2.6 patch] hwmon/ibmpex.c: fix NULL dereference
Message-ID: <20071017225850.7d8a9e88@hyperion.delvare>
In-Reply-To: <20071017192902.GB3778@stusta.de>
References: <20071017192902.GB3778@stusta.de>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007 21:29:02 +0200, Adrian Bunk wrote:
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

As a side note, dev_err() should be used instead of printk here, and
possibly in other places. Darrick, could you please send a patch fixing
this?

Thanks,
-- 
Jean Delvare
