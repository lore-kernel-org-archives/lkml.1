Return-Path: <linux-kernel-owner+w=401wt.eu-S1758254AbYLPPd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254AbYLPPd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 10:33:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755542AbYLPPdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 10:33:17 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43277 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753922AbYLPPdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 10:33:16 -0500
Subject: Re: [PATCH 8/11] drivers/net/wireless/libertas: Move a dereference
	below a NULL test
From: Dan Williams <dcbw@redhat.com>
To: Julia Lawall <julia@diku.dk>
Cc: libertas-dev@lists.infradead.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0812161614280.20444@pc-004.diku.dk>
References: <Pine.LNX.4.64.0812161614280.20444@pc-004.diku.dk>
Content-Type: text/plain
Date: Tue, 16 Dec 2008 10:32:16 -0500
Message-Id: <1229441536.7307.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-16 at 16:14 +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> In each case, if the NULL test is necessary, then the dereference should be
> moved below the NULL test.  I have also taken advantage of the availability
> of the value of priv->dev in the subsequent calls to netif_stop_queue and
> netif_carrier_off.
> 
> The semantic patch that makes this change is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @@
> type T;
> expression E;
> identifier i,fld;
> statement S;
> @@
> 
> - T i = E->fld;
> + T i;
>   ... when != E
>       when != i
>   if (E == NULL) S
> + i = E->fld;
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/main.c           |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
> index 73dc8c7..91c89da 100644
> --- a/drivers/net/wireless/libertas/main.c
> +++ b/drivers/net/wireless/libertas/main.c
> @@ -1311,7 +1311,7 @@ EXPORT_SYMBOL_GPL(lbs_start_card);
>  
>  void lbs_stop_card(struct lbs_private *priv)
>  {
> -	struct net_device *dev = priv->dev;
> +	struct net_device *dev;
>  	struct cmd_ctrl_node *cmdnode;
>  	unsigned long flags;
>  
> @@ -1319,9 +1319,10 @@ void lbs_stop_card(struct lbs_private *priv)
>  
>  	if (!priv)
>  		goto out;
> +	dev = priv->dev;
>  
> -	netif_stop_queue(priv->dev);
> -	netif_carrier_off(priv->dev);
> +	netif_stop_queue(dev);
> +	netif_carrier_off(dev);
>  
>  	lbs_debugfs_remove_one(priv);
>  	if (priv->mesh_tlv) {

