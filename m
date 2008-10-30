Return-Path: <linux-kernel-owner+w=401wt.eu-S1755280AbYJ3TRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbYJ3TRU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 15:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbYJ3TQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 15:16:59 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34850 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbYJ3TQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 15:16:59 -0400
Date: Thu, 30 Oct 2008 20:18:29 +0100
From: Pavel Machek <pavel@suse.cz>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] w35und: move global wbsoft_enabled to struct
	wbsoft_priv
Message-ID: <20081030191829.GI22185@elf.ucw.cz>
References: <1225383127-16406-1-git-send-email-penberg@cs.helsinki.fi> <1225383127-16406-2-git-send-email-penberg@cs.helsinki.fi> <1225383127-16406-3-git-send-email-penberg@cs.helsinki.fi> <1225383127-16406-4-git-send-email-penberg@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225383127-16406-4-git-send-email-penberg@cs.helsinki.fi>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-10-30 18:12:04, Pekka Enberg wrote:
> This is a preparational step for moving packet_came() to wb35rx.c().

Acked-by: Pavel Machek <pavel@suse.cz>


> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  drivers/staging/winbond/core.h  |    2 ++
>  drivers/staging/winbond/wbusb.c |   11 ++++++-----
>  2 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/winbond/core.h b/drivers/staging/winbond/core.h
> index 64b73bb..c6dd223 100644
> --- a/drivers/staging/winbond/core.h
> +++ b/drivers/staging/winbond/core.h
> @@ -39,6 +39,8 @@ struct wbsoft_priv {
>  	struct iw_statistics iw_stats;
>  
>  	u8 LinkName[WB_MAX_LINK_NAME_LEN];
> +
> +	bool enabled;
>  };
>  
>  #endif /* __WINBOND_CORE_H */
> diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
> index 0f70101..246f20b 100644
> --- a/drivers/staging/winbond/wbusb.c
> +++ b/drivers/staging/winbond/wbusb.c
> @@ -46,8 +46,6 @@ static struct ieee80211_supported_band wbsoft_band_2GHz = {
>  	.n_bitrates	= ARRAY_SIZE(wbsoft_rates),
>  };
>  
> -int wbsoft_enabled;
> -
>  static int wbsoft_add_interface(struct ieee80211_hw *dev,
>  				 struct ieee80211_if_init_conf *conf)
>  {
> @@ -129,8 +127,10 @@ static int wbsoft_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
>  
>  static int wbsoft_start(struct ieee80211_hw *dev)
>  {
> -	wbsoft_enabled = 1;
> -	printk("wbsoft_start called\n");
> +	struct wbsoft_priv *priv = dev->priv;
> +
> +	priv->enabled = true;
> +
>  	return 0;
>  }
>  
> @@ -393,10 +393,11 @@ error:
>  
>  void packet_came(struct ieee80211_hw *hw, char *pRxBufferAddress, int PacketSize)
>  {
> +	struct wbsoft_priv *priv = hw->priv;
>  	struct sk_buff *skb;
>  	struct ieee80211_rx_status rx_status = {0};
>  
> -	if (!wbsoft_enabled)
> +	if (!priv->enabled)
>  		return;
>  
>  	skb = dev_alloc_skb(PacketSize);

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
