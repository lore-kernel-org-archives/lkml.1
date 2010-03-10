Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab0CJF4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 00:56:43 -0500
Received: from smtp.nokia.com ([192.100.122.233]:64731 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034Ab0CJF4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 00:56:41 -0500
Subject: Re: linux-next: build failure after merge of the wireless tree
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Paasikivi Teemu.3 (EXT-Ixonos/Tampere)" 
	<ext-teemu.3.paasikivi@nokia.com>,
       Coelho Luciano Roth <luciano.coelho@nokia.com>
In-Reply-To: <20100310143605.8a20d310.sfr@canb.auug.org.au>
References: <20100310143605.8a20d310.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Mar 2010 07:53:17 +0200
Message-ID: <1268200397.10120.459.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Mar 2010 05:55:50.0216 (UTC) FILETIME=[563D6C80:01CAC016]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thinking about it, the assumption is correct. The implementation can
currently work only on ARM, as the wl1271 requires and out-of-band IRQ
line which is currently implemented with GPIO's.

-Juuso

On Wed, 2010-03-10 at 04:36 +0100, ext Stephen Rothwell wrote:
> Hi John,
> 
> After merging the wireless tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/net/wireless/wl12xx/wl1271_sdio.c:31:23: error: plat/gpio.h: No such file or directory
> drivers/net/wireless/wl12xx/wl1271_sdio.c: In function 'wl1271_sdio_raw_read':
> drivers/net/wireless/wl12xx/wl1271_sdio.c:121: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'
> drivers/net/wireless/wl12xx/wl1271_sdio.c: In function 'wl1271_sdio_raw_write':
> drivers/net/wireless/wl12xx/wl1271_sdio.c:144: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'
> drivers/net/wireless/wl12xx/wl1271_sdio.c: In function 'wl1271_probe':
> drivers/net/wireless/wl12xx/wl1271_sdio.c:198: error: implicit declaration of function 'gpio_to_irq'
> 
> Caused by commit 5129dffebd4eab1749e63bb4a1b7abdc92903227 ("wl1271:
> Initial SDIO implementation").  I assume this is only meant to be built
> for arm?
> 
> I have used the version of the wireless tree from next-20100309 for today.
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
> 
> P.S. I also got the following warnings:
> 
> drivers/net/wireless/mwl8k.c: In function 'mwl8k_rxd_8366_ap_process':
> drivers/net/wireless/mwl8k.c:752: warning: 'noise' is deprecated (declared at include/net/mac80211.h:557)
> drivers/net/wireless/mwl8k.c: In function 'mwl8k_rxd_sta_process':
> drivers/net/wireless/mwl8k.c:854: warning: 'noise' is deprecated (declared at include/net/mac80211.h:557)
> drivers/net/wireless/libertas_tf/main.c: In function 'lbtf_rx':
> drivers/net/wireless/libertas_tf/main.c:497: warning: 'noise' is deprecated (declared at include/net/mac80211.h:557)
> drivers/net/wireless/rt2x00/rt2x00dev.c: In function 'rt2x00lib_rxdone':
> drivers/net/wireless/rt2x00/rt2x00dev.c:437: warning: 'noise' is deprecated (declared at include/net/mac80211.h:557)
> drivers/net/wireless/iwlwifi/iwl-3945.c: In function 'iwl3945_rx_reply_rx':
> drivers/net/wireless/iwlwifi/iwl-3945.c:682: warning: 'noise' is deprecated (declared at include/net/mac80211.h:557)
> drivers/net/wireless/iwlwifi/iwl-3945.c:685: warning: 'noise' is deprecated (declared at include/net/mac80211.h:557)
> drivers/net/wireless/iwlwifi/iwl-3945.c:689: warning: 'noise' is deprecated (declared at include/net/mac80211.h:557)
> drivers/net/wireless/iwlwifi/iwl-3945.c:697: warning: 'noise' is deprecated (declared at include/net/mac80211.h:557)
> drivers/net/wireless/iwlwifi/iwl-3945.c:711: warning: 'noise' is deprecated (declared at include/net/mac80211.h:557)
> drivers/net/wireless/p54/txrx.c: In function 'p54_rx_data':
> drivers/net/wireless/p54/txrx.c:353: warning: 'noise' is deprecated (declared at include/net/mac80211.h:557)
> drivers/net/wireless/ath/ar9170/main.c: In function 'ar9170_rx_phy_status':
> drivers/net/wireless/ath/ar9170/main.c:928: warning: 'noise' is deprecated (declared at include/net/mac80211.h:557)
> drivers/net/wireless/b43/xmit.c: In function 'b43_rx':
> drivers/net/wireless/b43/xmit.c:613: warning: 'noise' is deprecated (declared at include/net/mac80211.h:557)
> drivers/net/wireless/b43legacy/xmit.c: In function 'b43legacy_rx':
> drivers/net/wireless/b43legacy/xmit.c:551: warning: 'noise' is deprecated (declared at include/net/mac80211.h:557)
> drivers/net/wireless/wl12xx/wl1251_rx.c: In function 'wl1251_rx_status':
> drivers/net/wireless/wl12xx/wl1251_rx.c:80: warning: 'noise' is deprecated (declared at include/net/mac80211.h:557)
> drivers/net/wireless/ath/ath5k/base.c: In function 'ath5k_tasklet_rx':
> drivers/net/wireless/ath/ath5k/base.c:1941: warning: 'noise' is deprecated (declared at include/net/mac80211.h:557)
> drivers/net/wireless/ath/ath5k/base.c:1942: warning: 'noise' is deprecated (declared at include/net/mac80211.h:557)
> drivers/net/wireless/ath/ath9k/common.c: In function 'ath9k_cmn_rx_skb_preprocess':
> drivers/net/wireless/ath/ath9k/common.c:215: warning: 'noise' is deprecated (declared at include/net/mac80211.h:557)
> drivers/net/wireless/wl12xx/wl1271_rx.c: In function 'wl1271_rx_status':
> drivers/net/wireless/wl12xx/wl1271_rx.c:139: warning: 'noise' is deprecated (declared at include/net/mac80211.h:557)
> drivers/net/wireless/iwlwifi/iwl-rx.c: In function 'iwl_rx_reply_rx':
> drivers/net/wireless/iwlwifi/iwl-rx.c:1145: warning: 'noise' is deprecated (declared at include/net/mac80211.h:557)
> drivers/net/wireless/iwlwifi/iwl-rx.c:1147: warning: 'noise' is deprecated (declared at include/net/mac80211.h:557)
> drivers/net/wireless/iwlwifi/iwl-rx.c:1160: warning: 'noise' is deprecated (declared at include/net/mac80211.h:557)


