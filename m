Return-Path: <linux-kernel-owner+w=401wt.eu-S1753448Ab0ADPhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab0ADPhO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 10:37:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107Ab0ADPhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 10:37:10 -0500
Received: from smtp.opengridcomputing.com ([209.198.142.2]:51589 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752833Ab0ADPhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 10:37:09 -0500
X-Greylist: delayed 1783 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Jan 2010 10:37:09 EST
Message-ID: <4B420483.1000606@opengridcomputing.com>
Date: Mon, 04 Jan 2010 09:08:51 -0600
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: linux-kernel@vger.kernel.org, swise@chelsio.com,
       Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH] drivers/infiniband/hw/cxgb3/iwch_cm.c: use %pM to show
 MAC address
References: <BD79186B4FD85F4B8E60E381CAEE19090200F66A@mi8nycmail19.Mi8.com>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE19090200F66A@mi8nycmail19.Mi8.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-by: Steve Wise <swise@opengridcomputing.com>


H Hartley Sweeten wrote:
> Use the %pM kernel extension to display the MAC address.
>
> The only difference in the output is that the MAC address is
> shown in the usual colon-separated hex notation.
>
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Steve Wise <swise@chelsio.com>
>
> ---
>
> diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
> index 66b4135..d94388b 100644
> --- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
> +++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
> @@ -1371,15 +1371,8 @@ static int pass_accept_req(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
>  	tim.mac_addr = req->dst_mac;
>  	tim.vlan_tag = ntohs(req->vlan_tag);
>  	if (tdev->ctl(tdev, GET_IFF_FROM_MAC, &tim) < 0 || !tim.dev) {
> -		printk(KERN_ERR
> -			"%s bad dst mac %02x %02x %02x %02x %02x %02x\n",
> -			__func__,
> -			req->dst_mac[0],
> -			req->dst_mac[1],
> -			req->dst_mac[2],
> -			req->dst_mac[3],
> -			req->dst_mac[4],
> -			req->dst_mac[5]);
> +		printk(KERN_ERR "%s bad dst mac %pM\n",
> +			__func__, req->dst_mac);
>  		goto reject;
>  	}
>   
>   

