Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbYJ0W2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbYJ0W2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 18:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754472AbYJ0W2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 18:28:21 -0400
Received: from ox1.aei.mpg.de ([194.94.224.6]:41633 "EHLO ox1.aei.mpg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083AbYJ0W2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 18:28:20 -0400
Date: Mon, 27 Oct 2008 23:28:52 +0100
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Johannes Berg <johannes@sipsolutions.net>,
       Soeren Sonnenburg <kernel@nn7.de>, linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org
Subject: Re: Suspend to RAM regression in 2.6.28-rc2 (bisected)
Message-ID: <20081027222852.GA3907@localhost.aei.mpg.de>
References: <20081027162054.GA4015@localhost.aei.mpg.de> <1225134823.3796.45.camel@johannes.berg> <20081027203925.GA4416@localhost.aei.mpg.de> <200810272151.01244.rjw@sisk.pl> <1ba2fa240810271407o15f1f150t2d2793f4e5ad6e5b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ba2fa240810271407o15f1f150t2d2793f4e5ad6e5b@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 27.Oct'08 at 23:07:00 +0200, Tomas Winkler wrote:
>[...]
> 
> Can someone try this one (it might be space broken I've just pasted
> that in) It's on top of 1d63e726408dfdb3e10ed8f00c383b30ebb333d3
> (latest linux-2.6.git)


Yes, this one also works for me (I applied it manually).


> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c
> b/drivers/net/wireless/iwlwifi/iwl-agn.c
> index 24a1aeb..321dbc8 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
> @@ -2090,7 +2090,6 @@ static void iwl_alive_start(struct iwl_priv *priv)
>                 iwl4965_error_recovery(priv);
> 
>         iwl_power_update_mode(priv, 1);
> -       ieee80211_notify_mac(priv->hw, IEEE80211_NOTIFY_RE_ASSOC);
> 
>         if (test_and_clear_bit(STATUS_MODE_PENDING, &priv->status))
>                 iwl4965_set_mode(priv, priv->iw_mode);
> @@ -2342,6 +2341,7 @@ static void iwl_bg_alive_start(struct work_struct *data)
>         mutex_lock(&priv->mutex);
>         iwl_alive_start(priv);
>         mutex_unlock(&priv->mutex);
> +       ieee80211_notify_mac(priv->hw, IEEE80211_NOTIFY_RE_ASSOC);
>  }
> 
>  static void iwl4965_bg_rf_kill(struct work_struct *work)
> 
> 
> Thanks
> Tomas
