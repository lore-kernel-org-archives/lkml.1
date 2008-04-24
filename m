Return-Path: <linux-kernel-owner+w=401wt.eu-S1760215AbYDXRN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760215AbYDXRN3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 13:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753638AbYDXRNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 13:13:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110AbYDXRNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 13:13:19 -0400
Subject: Re: [PATCH] prism54: prism54_get_encode() test below 0 on unsigned
	index
From: Dan Williams <dcbw@redhat.com>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: mcgrof@gmail.com, linux-wireless@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <480F9481.2040303@tiscali.nl>
References: <480F9481.2040303@tiscali.nl>
Content-Type: text/plain
Date: Thu, 24 Apr 2008 13:09:33 -0400
Message-Id: <1209056973.5224.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-23 at 21:56 +0200, Roel Kluin wrote:
> previously in this function:
> 
> u32 index = (dwrq->flags & IW_ENCODE_INDEX) - 1;

Probably should just change that to an 'int' instead of a u32.

Dan

> index is unsigned, so if -1, the original test (below) didn't work.
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/drivers/net/wireless/prism54/isl_ioctl.c b/drivers/net/wireless/prism54/isl_ioctl.c
> index e5b3c28..5b375b2 100644
> --- a/drivers/net/wireless/prism54/isl_ioctl.c
> +++ b/drivers/net/wireless/prism54/isl_ioctl.c
> @@ -1186,7 +1186,7 @@ prism54_get_encode(struct net_device *ndev, struct iw_request_info *info,
>  	rvalue |= mgt_get_request(priv, DOT11_OID_DEFKEYID, 0, NULL, &r);
>  	devindex = r.u;
>  	/* Now get the key, return it */
> -	if ((index < 0) || (index > 3))
> +	if (index == -1 || index > 3)
>  		/* no index provided, use the current one */
>  		index = devindex;
>  	rvalue |= mgt_get_request(priv, DOT11_OID_DEFKEYX, index, NULL, &r);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

