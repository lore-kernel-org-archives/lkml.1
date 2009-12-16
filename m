Return-Path: <linux-kernel-owner+w=401wt.eu-S1761375AbZLPQ6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761375AbZLPQ6v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 11:58:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbZLPQ6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 11:58:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100AbZLPQ6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 11:58:48 -0500
Subject: Re: [PATCH] Libertas: fix buffer overflow in lbs_get_essid()
From: Dan Williams <dcbw@redhat.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, Holger Schurig <holgerschurig@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Maithili Hinge <maithili@marvell.com>,
       Kiran Divekar <dkiran@marvell.com>,
       Michael Hirsch <m.hirsch@raumfeld.com>, netdev@vger.kernel.org,
       libertas-dev@lists.infradead.org, linux-wireless@lists.infradead.org,
       stable@kernel.org
In-Reply-To: <1260936778-2096-1-git-send-email-daniel@caiaq.de>
References: <1260936778-2096-1-git-send-email-daniel@caiaq.de>
Content-Type: text/plain
Date: Wed, 16 Dec 2009 08:57:47 -0800
Message-Id: <1260982667.2179.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-16 at 05:12 +0100, Daniel Mack wrote:
> The libertas driver copies the SSID buffer back to the wireless core and
> appends a trailing NULL character for termination. This is
> 
> a) unnecessary because the buffer is allocated with kzalloc and is hence
>    already NULLed when this function is called, and
> 
> b) for priv->curbssparams.ssid_len == 32, it writes back one byte too
>    much which causes memory corruptions.
> 
> Fix this by removing the extra write.

Acked-by: Dan Williams <dcbw@redhat.com>

> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> Cc: Dan Williams <dcbw@redhat.com>
> Cc: Holger Schurig <holgerschurig@gmail.com>
> Cc: John W. Linville <linville@tuxdriver.com>
> Cc: Stephen Hemminger <shemminger@vyatta.com>
> Cc: Maithili Hinge <maithili@marvell.com>
> Cc: Kiran Divekar <dkiran@marvell.com>
> Cc: Michael Hirsch <m.hirsch@raumfeld.com>
> Cc: netdev@vger.kernel.org
> Cc: libertas-dev@lists.infradead.org
> Cc: linux-wireless@lists.infradead.org
> Cc: stable@kernel.org
> ---
>  drivers/net/wireless/libertas/wext.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
> index be837a0..01c738b 100644
> --- a/drivers/net/wireless/libertas/wext.c
> +++ b/drivers/net/wireless/libertas/wext.c
> @@ -1953,10 +1953,8 @@ static int lbs_get_essid(struct net_device *dev, struct iw_request_info *info,
>  	if (priv->connect_status == LBS_CONNECTED) {
>  		memcpy(extra, priv->curbssparams.ssid,
>  		       priv->curbssparams.ssid_len);
> -		extra[priv->curbssparams.ssid_len] = '\0';
>  	} else {
>  		memset(extra, 0, 32);
> -		extra[priv->curbssparams.ssid_len] = '\0';
>  	}
>  	/*
>  	 * If none, we may want to get the one that was set

