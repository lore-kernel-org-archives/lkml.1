Return-Path: <linux-kernel-owner+w=401wt.eu-S1758955AbYJ3TQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955AbYJ3TQh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 15:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756788AbYJ3TQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 15:16:22 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34847 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728AbYJ3TQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 15:16:21 -0400
Date: Thu, 30 Oct 2008 20:17:54 +0100
From: Pavel Machek <pavel@suse.cz>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] w35und: remove unused ->ShutDowned member from
	struct LOCAL_PARA
Message-ID: <20081030191754.GH22185@elf.ucw.cz>
References: <1225383127-16406-1-git-send-email-penberg@cs.helsinki.fi> <1225383127-16406-2-git-send-email-penberg@cs.helsinki.fi> <1225383127-16406-3-git-send-email-penberg@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225383127-16406-3-git-send-email-penberg@cs.helsinki.fi>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-10-30 18:12:03, Pekka Enberg wrote:
> It's not actually read by anyone so we might as well remove it.

Acked-by: Pavel Machek <pavel@suse.cz>

> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  drivers/staging/winbond/localpara.h |    1 -
>  drivers/staging/winbond/wbusb.c     |    6 ------
>  2 files changed, 0 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/staging/winbond/localpara.h b/drivers/staging/winbond/localpara.h
> index a308ac2..607bb05 100644
> --- a/drivers/staging/winbond/localpara.h
> +++ b/drivers/staging/winbond/localpara.h
> @@ -149,7 +149,6 @@ typedef struct LOCAL_PARA
>  
>      //// power-save variables
>      u8  		  	iPowerSaveMode;     // 0 indicates it is on, 1 indicates it is off
> -	u8			ShutDowned;
>  	u8			ATIMmode;
>  	u8			ExcludeUnencrypted;
>  
> diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
> index 673875d..0f70101 100644
> --- a/drivers/staging/winbond/wbusb.c
> +++ b/drivers/staging/winbond/wbusb.c
> @@ -220,9 +220,6 @@ static unsigned char wb35_hw_init(struct ieee80211_hw *hw)
>  	pHwData = &priv->sHwData;
>  	hal_set_phy_type( pHwData, RF_DECIDE_BY_INF );
>  
> -	// Initial Software variable
> -	priv->sLocalPara.ShutDowned = false;
> -
>  	//added by ws for wep key error detection
>  	priv->sLocalPara.bWepKeyError= false;
>  	priv->sLocalPara.bToSelfPacketReceived = false;
> @@ -424,9 +421,6 @@ void packet_came(struct ieee80211_hw *hw, char *pRxBufferAddress, int PacketSize
>  
>  static void wb35_hw_halt(struct wbsoft_priv *adapter)
>  {
> -	//---------------------
> -	adapter->sLocalPara.ShutDowned = true;
> -
>  	Mds_Destroy( adapter );
>  
>  	// Turn off Rx and Tx hardware ability

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
