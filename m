Return-Path: <linux-kernel-owner+w=401wt.eu-S932466AbYD1H3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466AbYD1H3M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 03:29:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763172AbYD1H26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 03:28:58 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:7815 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbYD1H25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 03:28:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=aOgUKZpF/xPMvCNDiX4Vf2icUEhCzI6eS2r5vQ53sVHE+AHNf63Y63jgYywdyrr/ZE17hRd8kqilpZv3gj5yYr6Ndzv14G4HhJxkoZg/Z/udqHE/Z7/1u+aNuv+RKX4t1VyQyanfcJIbsSEuBY3W3/xfvCfp6WgNcK1ds6EC4+Y=
Date: Mon, 28 Apr 2008 04:32:14 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, reinette.chatre@intel.com,
       linville@tuxdriver.com, torvalds@linux-foundation.org
Subject: Re: [PATCH] iwlwifi: Fix build error in v2.6.25-5561-g064922a
Message-ID: <20080428073212.GA7260@Pilar.virtua.com.br>
References: <20080428054700.GA16177@Pilar.virtua.com.br> <20080427.233507.261574307.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080427.233507.261574307.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 27.Apr'08 at 23:35:07 -0700, David Miller wrote:
> From: "Carlos R. Mafra" <crmafra2@gmail.com>
> Date: Mon, 28 Apr 2008 02:47:01 -0300
> 
> > I've just tried to compile v2.6.25-5561-g064922a and it failed with
> > these messages:
> 
> Already fixed in net-2.6 by:
> 
> commit bd8fd21dfddf51299d782f598cb776b15b7d64cc
> Author: Luca Tettamanti <kronos.it@gmail.com>
> Date:   Sun Apr 27 15:34:55 2008 -0700
> 
>     wireless: Fix compile error with wifi & leds
>     
>     Fix build error caused by commit
>     e82404ad612ebabc65d15c3d59b971cb35c3ff36 ("iwlwifi: Select
>     LEDS_CLASS.") from David Miller:
>     
>     Since MAC80211_LEDS is selected by wireless drivers it must select its
>     own dependencies otherwise a build error may occur (kbuild will select
>     the symbol regardless of "depends" constraints).
>     
>     Signed-off-By: Luca Tettamanti <kronos.it@gmail.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
> index 520a518..a24b459 100644
> --- a/net/mac80211/Kconfig
> +++ b/net/mac80211/Kconfig
> @@ -73,7 +73,9 @@ config MAC80211_MESH
>  
>  config MAC80211_LEDS
>  	bool "Enable LED triggers"
> -	depends on MAC80211 && LEDS_TRIGGERS
> +	depends on MAC80211
> +	select NEW_LEDS
> +	select LEDS_TRIGGERS
>  	---help---
>  	  This option enables a few LED triggers for different
>  	  packet receive/transmit events.

Hmm, I just tested this patch and it does not solve the problem. 

I could create a .config using 'make menuconfig' in which I had

CONFIG_MAC80211_LEDS=y
CONFIG_RFKILL_LEDS=y
CONFIG_IWLWIFI_LEDS=y
CONFIG_IWL4965_LEDS=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

So I recompiled the kernel and got the same error message as before.

What my patch does is to make a .config with CONFIG_LEDS_CLASS=m and 
CONFIG_IWL4965_LEDS=y be impossible to exist, because it
appears that this combination is what causes the build error.

But anyways, I've just read about the Kconfig language a few hours
ago when I had this problem and tried to solve it, so my patch is
probably missing something. But it works for me in the sense that
IWL4965_LEDS doesn't even show as an option in 'make menuconfig' 
if LEDS_CLASS=m, so I user like me can not generate a .config which 
does not build correctly.



