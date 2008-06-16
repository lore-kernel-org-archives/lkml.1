Return-Path: <linux-kernel-owner+w=401wt.eu-S1761346AbYFPJRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761346AbYFPJRR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 05:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757101AbYFPJRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 05:17:00 -0400
Received: from [211.125.136.229] ([211.125.136.229]:58315 "EHLO
	ms13.sony.co.jp" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756864AbYFPJQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 05:16:59 -0400
Date: Mon, 16 Jun 2008 18:15:12 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/12]: Proper compat WEXT support.
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080612.225332.193703791.davem@davemloft.net>
References: <20080604184955.B033.40F06B3A@sm.sony.co.jp> <20080612.225332.193703791.davem@davemloft.net>
Message-Id: <20080616174509.B048.40F06B3A@sm.sony.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.46 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 12 Jun 2008 22:53:32 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> Here is a new version of patch 12, which should fix the problems
> you reported here.  The idea is simple, all references to
> IW_EV_LCP_LEN are replaced with calls to a new inline function
> named iwe_stream_lcp_len() which returns the compat value if
> necessary.
> 
> wext: Emit event stream entries correctly when compat.
> 
> Three major portions to this change:
> 
> 1) Add IW_EV_COMPAT_LCP_LEN, IW_EV_COMPAT_POINT_OFF,
>    and IW_EV_COMPAT_POINT_LEN helper defines.
> 
> 2) Delete iw_stream_check_add_*(), they are unused.
> 
> 3) Add iw_request_info argument to iwe_stream_add_*(), and use it to
>    size the event and pointer lengths correctly depending upon whether
>    IW_REQUEST_FLAG_COMPAT is set or not.
> 
> 4) The mechanical transformations to the drivers and wireless stack
>    bits to get the iw_request_info passed down into the routines
>    modified in #3.  Also, explicit references to IW_EV_LCP_LEN are
>    replaced with iwe_stream_lcp_len(info).
> 
> With a lot of help and bug fixes from Masakazu Mokuno.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  drivers/net/ps3_gelic_wireless.c           |   30 +++---
>  drivers/net/wireless/airo.c                |   43 +++++---
>  drivers/net/wireless/atmel.c               |   24 ++++-
>  drivers/net/wireless/hostap/hostap.h       |    3 +-
>  drivers/net/wireless/hostap/hostap_ap.c    |   32 +++---
>  drivers/net/wireless/hostap/hostap_ioctl.c |   58 ++++++-----
>  drivers/net/wireless/libertas/scan.c       |   36 ++++---
>  drivers/net/wireless/orinoco.c             |   23 +++--
>  drivers/net/wireless/prism54/isl_ioctl.c   |   49 +++++----
>  drivers/net/wireless/rndis_wlan.c          |   31 +++---
>  drivers/net/wireless/wl3501_cs.c           |   10 +-
>  drivers/net/wireless/zd1201.c              |   21 +++--
>  include/linux/wireless.h                   |   15 +++
>  include/net/iw_handler.h                   |  149 +++++++++-------------------
>  net/ieee80211/ieee80211_wx.c               |   48 +++++----
>  net/mac80211/ieee80211_i.h                 |    5 +-
>  net/mac80211/mlme.c                        |   45 +++++----
>  net/mac80211/wext.c                        |    2 +-
>  18 files changed, 323 insertions(+), 301 deletions(-)

Thank you again for updating the patch set!

With this new patch #12, it worked OK for me.   I tested on my PS3 with:

  - wireless_tools version 28 and 29.  Both 64 and 32-bit compiled
    iwlist and iwconfig
  - wpa_supplicant 0.6.x, 64 and 32-bit compiled
  - gelic and zd1211 driver
  

checkpatch.pl complained some error/warnings on the patches #7, #9 and
#12.  It seemed that most of them were inherited from the original code,
some seemed like newly created ones, like 80-characters over warnings in
net/mac80211/mlme.c.  We might want to fix them?

Anyway the code works fine.  Again, thank you!

-- 
Masakazu Mokuno

