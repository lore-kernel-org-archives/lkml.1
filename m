Return-Path: <linux-kernel-owner+w=401wt.eu-S1756339AbYDJJAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339AbYDJJAe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 05:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754889AbYDJJAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 05:00:24 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:10569 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328AbYDJJAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 05:00:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:references:from:date:in-reply-to:message-id:user-agent:mime-version:content-type:sender;
        b=aWVmLYXuo4M6Dqbh6FgCzZGrhfgWpWooBfsPkeAnw5wERC1B1tIXcqYkzNsPaNpSP1lw0h03JtyT0UEu44wo76X0i+E8HcM0Ra9Bx/MRwHQdQCYvM5vIvY0N8BAOyWi1XFkcE8twa0s2DfJ9evlLwLmM1p/PCRurQjAAcMZr1QM=
To: Roel Kluin <12o3l@tiscali.nl>, jeff@garzik.org, dustin@sensoria.com
Cc: nico@cam.org, netdev@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] smc911x: test after postfix decrement fails in smc911x_{reset,drop_pkt}
References: <47FC922A.6030309@tiscali.nl>
From: Peter Korsgaard <jacmet@sunsite.dk>
Date: Thu, 10 Apr 2008 11:00:03 +0200
In-Reply-To: <47FC922A.6030309@tiscali.nl> (Roel Kluin's message of "Wed\, 09 Apr 2008 11\:53\:46 +0200")
Message-ID: <87abk2axv0.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Roel" == Roel Kluin <12o3l@tiscali.nl> writes:

 Roel> When timeout reaches 0 the postfix decrement still subtracts,
 Roel> so the test fails

Ahh, good catch. Notice that Nicolas isn't the author of smc911x,
Dustin McIntire is.

Acked-by: Peter Korsgaard <jacmet@sunsite.dk>

 Roel> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
 Roel> ---
 Roel> diff --git a/drivers/net/smc911x.c b/drivers/net/smc911x.c
 Roel> index 76cc1d3..2126d24 100644
 Roel> --- a/drivers/net/smc911x.c
 Roel> +++ b/drivers/net/smc911x.c
 Roel> @@ -243,7 +243,7 @@ static void smc911x_reset(struct net_device *dev)
 Roel>  		do {
 Roel>  			udelay(10);
 Roel>  			reg = SMC_GET_PMT_CTRL() & PMT_CTRL_READY_;
 Roel> -		} while ( timeout-- && !reg);
 Roel> +		} while ( --timeout && !reg);
 Roel>  		if (timeout == 0) {
 Roel>  			PRINTK("%s: smc911x_reset timeout waiting for PM restore\n", dev->name);
 Roel>  			return;
 Roel> @@ -267,7 +267,7 @@ static void smc911x_reset(struct net_device *dev)
 Roel>  				resets++;
 Roel>  				break;
 Roel>  			}
 Roel> -		} while ( timeout-- && (reg & HW_CFG_SRST_));
 Roel> +		} while ( --timeout && (reg & HW_CFG_SRST_));
 Roel>  	}
 Roel>  	if (timeout == 0) {
 Roel>  		PRINTK("%s: smc911x_reset timeout waiting for reset\n", dev->name);
 Roel> @@ -413,7 +413,7 @@ static inline void smc911x_drop_pkt(struct net_device *dev)
 Roel>  		do {
 Roel>  			udelay(10);
 Roel>  			reg = SMC_GET_RX_DP_CTRL() & RX_DP_CTRL_FFWD_BUSY_;
 Roel> -		} while ( timeout-- && reg);
 Roel> +		} while ( --timeout && reg);
 Roel>  		if (timeout == 0) {
 Roel>  			PRINTK("%s: timeout waiting for RX fast forward\n", dev->name);
 Roel>  		}
 Roel> --

-- 
Bye, Peter Korsgaard
