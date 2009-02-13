Return-Path: <linux-kernel-owner+w=401wt.eu-S1760291AbZBMPxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760291AbZBMPxf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 10:53:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbZBMPx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 10:53:27 -0500
Received: from styx.suse.cz ([82.119.242.94]:34417 "EHLO dhcp35"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751889AbZBMPx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 10:53:27 -0500
Date: Fri, 13 Feb 2009 16:53:22 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Miles Lane <miles.lane@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Reinette Chatre <reinette.chatre@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.29-rc4-git1 -- iwl3945: Does not suspend/resume
	successfully.
Message-ID: <20090213155322.GA5852@dhcp35.suse.cz>
References: <a44ae5cd0902091844m48a48e01i5c8d567279d70dff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a44ae5cd0902091844m48a48e01i5c8d567279d70dff@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 09-02-09 21:44:27, Miles Lane wrote:
> Before suspend:
> 
> [   13.441374] cfg80211: Using static regulatory domain info
> [   13.441378] cfg80211: Regulatory domain: US
> [   13.441381] 	(start_freq - end_freq @ bandwidth),
> (max_antenna_gain, max_eirp)
> [   13.441385] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
> [   13.441388] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> [   13.441392] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> [   13.441395] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> [   13.441398] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> [   13.441401] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
> [   13.441406] cfg80211: Calling CRDA for country: US
> [   13.453217] lib80211: common routines for IEEE802.11 drivers
> [   13.453297] lib80211_crypt: registered algorithm 'NULL'
> [   13.912922] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network
> Connection driver for Linux, 1.2.26kds
> [   13.912927] iwl3945: Copyright(c) 2003-2008 Intel Corporation
> [   13.913250] iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [   13.913271] iwl3945 0000:03:00.0: setting latency timer to 64
> [   13.959973] iwl3945: Tunable channels: 11 802.11bg, 13 802.11a channels
> [   13.959977] iwl3945: Detected Intel Wireless WiFi Link 3945ABG
> [   13.964994] iwl3945 0000:03:00.0: PCI INT A disabled
> [   13.975378] wmaster0 (iwl3945): not using net_device_ops yet
> [   13.978737] phy0: Selected rate control algorithm 'iwl-3945-rs'
> [   14.060342] wlan0 (iwl3945): not using net_device_ops yet
> [   49.848812] iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [   49.849038] iwl3945 0000:03:00.0: restoring config space at offset
> 0x1 (was 0x100102, writing 0x100106)
> [   49.849310] iwl3945 0000:03:00.0: irq 28 for MSI/MSI-X
> [   49.849651] iwl3945 0000:03:00.0: firmware: requesting iwlwifi-3945-2.ucode
> [   49.938202] iwl3945 loaded firmware version 15.28.2.8
> [   49.991919] Registered led device: iwl-phy0:radio
> [   49.992175] Registered led device: iwl-phy0:assoc
> [   49.992341] Registered led device: iwl-phy0:RX
> [   49.992482] Registered led device: iwl-phy0:TX
> [   50.017939] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [  108.695643] wlan0: authenticate with AP 00:1b:2f:0e:ed:ba
> [  108.697456] wlan0: authenticated
> [  108.697463] wlan0: associate with AP 00:1b:2f:0e:ed:ba
> [  108.700458] wlan0: RX AssocResp from 00:1b:2f:0e:ed:ba (capab=0x431
> status=0 aid=1)
> [  108.700506] wlan0: associated
> [  108.711195] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [  113.639727] apport used greatest stack depth: 3680 bytes left
> [  119.040046] wlan0: no IPv6 routers present
> 
> At resume:
> 
> [ 2619.951641] iwl3945 0000:03:00.0: PCI INT A disabled
> [ 2619.954113] wlan0: disassociating by local choice (reason=3)
> [ 2623.178462] iwl3945 0000:03:00.0: restoring config space at offset
> 0xf (was 0x100, writing 0x10b)
> [ 2623.178462] iwl3945 0000:03:00.0: restoring config space at offset
> 0x4 (was 0x0, writing 0xd6000000)
> [ 2623.178462] iwl3945 0000:03:00.0: restoring config space at offset
> 0x3 (was 0x0, writing 0x10)
> [ 2623.178462] iwl3945 0000:03:00.0: restoring config space at offset
> 0x1 (was 0x100000, writing 0x100102)
> [ 2627.612291] iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [ 2627.612646] iwl3945 0000:03:00.0: irq 28 for MSI/MSI-X
> [ 2629.644532] iwl3945: Wait for START_ALIVE timeout after 2000ms.
> [ 2629.644669] iwl3945 0000:03:00.0: PCI INT A disabled
> [ 2629.655349] iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [ 2629.655752] iwl3945 0000:03:00.0: irq 28 for MSI/MSI-X
> [ 2631.684143] iwl3945: Wait for START_ALIVE timeout after 2000ms.
> [ 2631.684281] iwl3945 0000:03:00.0: PCI INT A disabled
> [ 2701.336116] Hangcheck: hangcheck value past margin!
> 
> Result:  The device isn't responding to Network Manager (no APs listed).
> 
> When I "modprobe -r iwl3945" and "modprobe iwl3945", the log shows:
> 
> [ 2925.424158] lib80211_crypt: unregistered algorithm 'NULL'
> [ 2928.900488] cfg80211: Using static regulatory domain info
> [ 2928.900499] cfg80211: Regulatory domain: US
> [ 2928.900504] 	(start_freq - end_freq @ bandwidth),
> (max_antenna_gain, max_eirp)
> [ 2928.900513] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
> [ 2928.900520] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> [ 2928.900526] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> [ 2928.900533] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> [ 2928.900539] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> [ 2928.900546] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
> [ 2928.900554] cfg80211: Calling CRDA for country: US
> [ 2928.934992] lib80211: common routines for IEEE802.11 drivers
> [ 2928.935005] lib80211_crypt: registered algorithm 'NULL'
> [ 2929.006540] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network
> Connection driver for Linux, 1.2.26kds
> [ 2929.006547] iwl3945: Copyright(c) 2003-2008 Intel Corporation
> [ 2929.006672] iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [ 2929.006695] iwl3945 0000:03:00.0: setting latency timer to 64
> [ 2929.051497] iwl3945: Tunable channels: 11 802.11bg, 13 802.11a channels
> [ 2929.051503] iwl3945: Detected Intel Wireless WiFi Link 3945ABG
> [ 2929.054769] wmaster0 (iwl3945): not using net_device_ops yet
> [ 2929.060185] phy0: Selected rate control algorithm 'iwl-3945-rs'
> [ 2929.060283] wlan0 (iwl3945): not using net_device_ops yet
> 
> Device is working again.

I had similar problem and tried the patch suggested in
http://lkml.org/lkml/2009/2/12/239 and the patch seems to solve the
issue on my end.

-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
