Return-Path: <linux-kernel-owner+w=401wt.eu-S1762527AbXK2BNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762527AbXK2BNA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 20:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761586AbXK2BMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 20:12:48 -0500
Received: from mga01.intel.com ([192.55.52.88]:16063 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760811AbXK2BMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 20:12:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,226,1194249600"; 
   d="scan'208";a="407040512"
Subject: Re: [PATCH 1/2] [net/wireless/iwlwifi] : iwlwifi 3945 Fix race
	conditional panic.
From: Zhu Yi <yi.zhu@intel.com>
To: Joonwoo Park <joonwpark81@gmail.com>
Cc: ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <00e501c831ab$2e78daa0$9c94fea9@jason>
References: <00e501c831ab$2e78daa0$9c94fea9@jason>
Content-Type: text/plain
Organization: Intel Corp.
Date: Thu, 29 Nov 2007 09:10:56 +0800
Message-Id: <1196298656.7614.77.camel@debian.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-11-28 at 19:41 +0900, Joonwoo Park wrote:
> [net/wireless/iwlwifi] : iwlwifi 3945 Fix race conditional panic.
> 
> Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
> ---
> diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> index 465da4f..ac6c4a9 100644
> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> @@ -8570,6 +8570,7 @@ static void iwl_pci_remove(struct pci_dev *pdev)
>         IWL_DEBUG_INFO("*** UNLOAD DRIVER ***\n");
>  
>         mutex_lock(&priv->mutex);
> +       cancel_delayed_work_sync(&priv->init_alive_start);
>         set_bit(STATUS_EXIT_PENDING, &priv->status);
>         __iwl_down(priv);
>         mutex_unlock(&priv->mutex);

Good catch. But it will be better if you add it into
iwl_cancel_deferred_work().

Thanks,
-yi
