Return-Path: <linux-kernel-owner+w=401wt.eu-S1761888AbYDBUSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761888AbYDBUSE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 16:18:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761080AbYDBUPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 16:15:53 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:16294 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761055AbYDBUPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 16:15:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RyUD0mV0tg5uGGDaeL1MoKgI6SMI9TbV6/4joh/n25yLHQtNUCqDyMA3FOPxwUWRRlWxrkdZyMpKRD2H28e1edI4JqXGBMrSQ/2gUPl8l+g8dNaeAmgHMZksC+8y4COyZAlbhFur5CSZng0S+PebKWn0uHIZwfYJS3tN946Wf/A=
Message-ID: <1ba2fa240804021315s399111d3ibbb1044e8964de5@mail.gmail.com>
Date: Wed, 2 Apr 2008 23:15:50 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] iwlwifi/Kconfg: make IWLWIFI_LEDS invisible
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Miles Lane" <miles.lane@gmail.com>, reinette.chatre@intel.com
In-Reply-To: <1207152604-22973-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0804020404k295ffc7ew8761cc0901996e20@mail.gmail.com>
	 <1207152604-22973-1-git-send-email-linville@tuxdriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 2, 2008 at 7:10 PM, John W. Linville <linville@tuxdriver.com> wrote:
> Select IWLWIFI_LEDS automatically when either IWL3945_LEDS or
>  IWL4965_LEDS is selected.  This avoids potential misconfigurations
>  which lead to build failures for iwl-led.c.
>
>  Cc: Miles Lane <miles.lane@gmail.com>
>  Cc: reinette.chatre@intel.com
>  Signed-off-by: John w. Linville <linville@tuxdriver.com>
>  ---
>   drivers/net/wireless/iwlwifi/Kconfig |   11 +++++------
>   1 files changed, 5 insertions(+), 6 deletions(-)
>
>  diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
>  index 4a5c8c0..8137690 100644
>  --- a/drivers/net/wireless/iwlwifi/Kconfig
>  +++ b/drivers/net/wireless/iwlwifi/Kconfig
>  @@ -3,11 +3,8 @@ config IWLCORE
>         depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
>
>   config IWLWIFI_LEDS
>  -       bool "Enable LEDS features in iwlwifi driver"
>  -       depends on IWLCORE && MAC80211_LEDS && LEDS_CLASS
>  -       ---help---
>  -         This option enables LEDS for the iwlwifi drivers
>  -
>  +       bool
>  +       default n
>
>   config IWLCORE_RFKILL
>         boolean "IWLWIFI RF kill support"
>  @@ -52,7 +49,8 @@ config IWL4965_HT
>
>   config IWL4965_LEDS
>         bool "Enable LEDS features in iwl4965 driver"
>  -       depends on IWL4965 && IWLWIFI_LEDS
>  +       depends on IWL4965 && MAC80211_LEDS && LEDS_CLASS
>  +       select IWLWIFI_LEDS
>         ---help---
>           This option enables LEDS for the iwlwifi drivers
>
>  @@ -137,6 +135,7 @@ config IWL3945_SPECTRUM_MEASUREMENT
>   config IWL3945_LEDS
>         bool "Enable LEDS features in iwl3945 driver"
>         depends on IWL3945 && MAC80211_LEDS && LEDS_CLASS
>  +       select IWLWIFI_LEDS

3945 is for now not dependent at all on this flag.
Otherwise looks OK
