Return-Path: <linux-kernel-owner+w=401wt.eu-S1752676AbYJ0S7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbYJ0S7s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 14:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbYJ0S7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 14:59:38 -0400
Received: from ox1.aei.mpg.de ([194.94.224.6]:56192 "EHLO ox1.aei.mpg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbYJ0S7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 14:59:37 -0400
Date: Mon, 27 Oct 2008 20:00:12 +0100
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Soeren Sonnenburg <kernel@nn7.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, tomas.winkler@intel.com,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org
Subject: Re: Suspend to RAM regression in 2.6.28-rc2 (bisected)
Message-ID: <20081027190011.GA3951@localhost.aei.mpg.de>
References: <20081027162054.GA4015@localhost.aei.mpg.de> <200810271832.40717.rjw@sisk.pl> <1225130844.4466.0.camel@localhost> <1225132278.3796.32.camel@johannes.berg> <1225133082.3796.35.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225133082.3796.35.camel@johannes.berg>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 27.Oct'08 at 19:44:42 +0100, Johannes Berg wrote:
> On Mon, 2008-10-27 at 19:31 +0100, Johannes Berg wrote:
> > On Mon, 2008-10-27 at 19:07 +0100, Soeren Sonnenburg wrote:
> > 
> > > > Johannes, can you pls have a look?
> > 
> > I did, and I have no idea. Makes no sense at all.
> 
> The only thing I can remotely think of is that iwlwifi doesn't like
> being called back from within the call that it did to mac80211, which
> obviously happens here. But I have no idea, the code as it stands is
> correct, just the interaction with iwlwifi's resume seems to be broken.
> 
> Try this patch instead:

Yep, with this patch it also works!


> --- everything.orig/drivers/net/wireless/iwlwifi/iwl-agn.c	2008-10-27 19:44:12.000000000 +0100
> +++ everything/drivers/net/wireless/iwlwifi/iwl-agn.c	2008-10-27 19:44:15.000000000 +0100
> @@ -2084,7 +2084,6 @@ static void iwl_alive_start(struct iwl_p
>  		iwl4965_error_recovery(priv);
>  
>  	iwl_power_update_mode(priv, 1);
> -	ieee80211_notify_mac(priv->hw, IEEE80211_NOTIFY_RE_ASSOC);
>  
>  	if (test_and_clear_bit(STATUS_MODE_PENDING, &priv->status))
>  		iwl4965_set_mode(priv, priv->iw_mode);
> 
> 
> johannes


