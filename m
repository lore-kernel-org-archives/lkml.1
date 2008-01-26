Return-Path: <linux-kernel-owner+w=401wt.eu-S1754848AbYAZUOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbYAZUOp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 15:14:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbYAZUOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 15:14:36 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:25025 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbYAZUOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 15:14:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HUPA8bYypMFY2+kLmS5s+rtneT658eyTwh0Mo5Ie8KlzsgS974gBdyXqHl8e8/DXqLgk4xPDn7TujtPRbHgY40HafHYzPtMxWvkgVG2br3lMLgl8RPM1y8Hs61U3jYK0hZRaB8mf9F6lIikImAunpUfNsAWD4R76HOnI6uTcNh8=
Message-ID: <1ba2fa240801261214p42d53602o5be2a2cdbcc0d796@mail.gmail.com>
Date: Sat, 26 Jan 2008 22:14:29 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Subject: Re: [PATCH] wireless: iwlwifi3945/4965 - fix incorrect counting of memory
Cc: "Thomas Tuttle" <linux-kernel@ttuttle.net>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Michael Wu" <flamingice@sourmilk.net>,
       LWML <linux-wireless@vger.kernel.org>
In-Reply-To: <20080126160936.GB6738@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080126160936.GB6738@cvg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 26, 2008 6:09 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> This patch does fix incorrect counting of memory allocated by kmalloc.
> It seems that could lead to allocated memory overrun and corrupt
> nearlaid memory area.
>
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
>
> ---
>
>  iwl3945-base.c |    2 +-
>  iwl4965-base.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> Index: linux-2.6.git/drivers/net/wireless/iwlwifi/iwl3945-base.c
> ===================================================================
> --- linux-2.6.git.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c      2008-01-24 18:26:11.000000000 +0300
> +++ linux-2.6.git/drivers/net/wireless/iwlwifi/iwl3945-base.c   2008-01-26 18:45:03.000000000 +0300
> @@ -6631,7 +6631,7 @@ static void iwl_bg_request_scan(struct w
>          * that based on the direct_mask added to each channel entry */
>         scan->tx_cmd.len = cpu_to_le16(
>                 iwl_fill_probe_req(priv, (struct ieee80211_mgmt *)scan->data,
> -                       IWL_MAX_SCAN_SIZE - sizeof(scan), 0));
> +                       IWL_MAX_SCAN_SIZE - sizeof(*scan), 0));
>         scan->tx_cmd.tx_flags = TX_CMD_FLG_SEQ_CTL_MSK;
>         scan->tx_cmd.sta_id = priv->hw_setting.bcast_sta_id;
>         scan->tx_cmd.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
>
> Index: linux-2.6.git/drivers/net/wireless/iwlwifi/iwl4965-base.c
> ===================================================================
> --- linux-2.6.git.orig/drivers/net/wireless/iwlwifi/iwl4965-base.c      2008-01-26 18:45:38.000000000 +0300
> +++ linux-2.6.git/drivers/net/wireless/iwlwifi/iwl4965-base.c   2008-01-26 18:46:06.000000000 +0300
> @@ -6992,7 +6992,7 @@ static void iwl_bg_request_scan(struct w
>          * that based on the direct_mask added to each channel entry */
>         scan->tx_cmd.len = cpu_to_le16(
>                 iwl_fill_probe_req(priv, (struct ieee80211_mgmt *)scan->data,
> -                       IWL_MAX_SCAN_SIZE - sizeof(scan), 0));
> +                       IWL_MAX_SCAN_SIZE - sizeof(*scan), 0));
>         scan->tx_cmd.tx_flags = TX_CMD_FLG_SEQ_CTL_MSK;
>         scan->tx_cmd.sta_id = priv->hw_setting.bcast_sta_id;
>         scan->tx_cmd.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Thanks.

ACK
