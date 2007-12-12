Return-Path: <linux-kernel-owner+w=401wt.eu-S1759525AbXLLLns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525AbXLLLns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 06:43:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757072AbXLLLng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 06:43:36 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42261 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755467AbXLLLnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 06:43:35 -0500
Date: Wed, 12 Dec 2007 03:43:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Joonwoo Park" <joonwpark81@gmail.com>
Cc: "'Zhu Yi'" <yi.zhu@intel.com>, <ipw3945-devel@lists.sourceforge.net>,
       <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/2] [net/wireless/iwlwifi] : iwlwifi 3945 Fix
 raceconditional panic.
Message-Id: <20071212034325.4a022320.akpm@linux-foundation.org>
In-Reply-To: <016401c83229$3302d250$9c94fea9@jason>
References: <00e501c831ab$2e78daa0$9c94fea9@jason>
	<1196298656.7614.77.camel@debian.sh.intel.com>
	<016401c83229$3302d250$9c94fea9@jason>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007 10:42:49 +0900 "Joonwoo Park" <joonwpark81@gmail.com> wrote:

> 2007/11/29, Zhu Yi <yi.zhu@intel.com>:
> > 
> > Good catch. But it will be better if you add it into
> > iwl_cancel_deferred_work().
> > 
> 
> Thanks.
> I agree with you. 
> Actually, I considered it, but I was afraid of side effect.
> Anyway, I'm attaching a new one.
> 
> Thanks.
> Joonwoo
> 
> [net/wireless/iwlwifi] : iwlwifi 3945 Fix race conditional panic.
> 
> Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
> ---
> diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> index 465da4f..e51e872 100644
> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> @@ -8270,6 +8270,7 @@ static void iwl_cancel_deferred_work(struct iwl_priv *priv)
>  {
>  	iwl_hw_cancel_deferred_work(priv);
>  
> +	cancel_delayed_work_sync(&priv->init_alive_start);
>  	cancel_delayed_work(&priv->scan_check);
>  	cancel_delayed_work(&priv->alive_start);
>  	cancel_delayed_work(&priv->post_associate);

Did drivers/net/wireless/iwlwifi/iwl4965-base.c get fixed in a simlar
fashion?
