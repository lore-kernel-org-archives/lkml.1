Return-Path: <linux-kernel-owner+w=401wt.eu-S1752732AbYIURY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbYIURY2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 13:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600AbYIURYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 13:24:17 -0400
Received: from relay.2ka.mipt.ru ([194.85.80.65]:49281 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbYIURYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 13:24:16 -0400
Date: Sun, 21 Sep 2008 21:23:17 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: ipw2100-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
       yi.zhu@intel.com, reinette.chatre@intel.com, jgarzik@pobox.com,
       linville@tuxdriver.com, davem@davemloft.net
Subject: Mark IPW2100 as BROKEN: Fatal interrupt. Scheduling firmware restart.
Message-ID: <20080921172316.GA6306@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Following bug exists in the ipw2100 driver/firmware for years and Intel
folks never responded to zillions bugzilla entries and forum notices in
the internet with some patch or firmware update (although did request
dmesg and debug info, and received them).

ipw2100: Fatal interrupt. Scheduling firmware restart.

I believe it is a firmware bug because after driver is unloaded and
loaded back again wireless adapter usually starts working (for small
amount of time though). My conspiracy feeling can suggest, that it may
be kind of a force to buy a new one, or trivial error in the firmware,
when it writes to the same place in the flash and essentially given cell
became dead or whatever else.

Intel folks, please fix this problem, I see no other way to force you to do
this than to mark ipw2100 driver as broken, since that is what it is.

Bug exists at least in .15 upto .24 kernels, just search above dmesg
line. I cought it with 2.6.24-19-386 ubuntu kernel, 1.3 firmware
version. lspci:

02:04.0 Network controller: Intel Corporation PRO/Wireless LAN 2100 3B Mini PCI Adapter (rev 04)
	Subsystem: Intel Corporation Samsung X10/P30 integrated WLAN
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (500ns min, 8500ns max), Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at 90080000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-

dmesg is pretty usual.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 9931b5a..c24fc6a 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -125,7 +125,7 @@ config PCMCIA_RAYCS
 
 config IPW2100
 	tristate "Intel PRO/Wireless 2100 Network Connection"
-	depends on PCI && WLAN_80211
+	depends on PCI && WLAN_80211 && BROKEN
 	select WIRELESS_EXT
 	select FW_LOADER
 	select IEEE80211

-- 
	Evgeniy Polyakov
