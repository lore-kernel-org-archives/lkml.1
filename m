Return-Path: <linux-kernel-owner+w=401wt.eu-S1757761AbZGHVke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757761AbZGHVke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 17:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757507AbZGHVkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 17:40:12 -0400
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:52218 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757830AbZGHVkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 17:40:10 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-wireless@vger.kernel.org
Subject: [regression] ath5k: Overrides regulatory domain set for cfg80211
Date: Wed, 8 Jul 2009 23:40:06 +0200
User-Agent: KMail/1.9.9
Cc: netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907082340.07787.elendil@planet.nl>
X-OriginalArrivalTime: 08 Jul 2009 21:40:08.0442 (UTC) FILETIME=[A9F7DDA0:01CA0014]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In /etc/modprobe.d I have a file containing:
options cfg80211 ieee80211_regdom=EU

During boot this results in:
<snip>
cfg80211: Using static regulatory domain info
cfg80211: Regulatory domain: EU
	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
	(2402000 KHz - 2482000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
	(5490000 KHz - 5710000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
cfg80211: Calling CRDA for country: EU
</snip>

But with 2.6.31-rc2 I then get (the lines marked with "!" are not there 
with .30):
<snip>
  ath5k 0000:02:00.0: enabling device (0000 -> 0002)
  ath5k 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
  ath5k 0000:02:00.0: registered as 'phy0'
! ath: EEPROM regdomain: 0x30
! ath: EEPROM indicates we should expect a direct regpair map
! ath: Country alpha2 being used: AM
! ath: Regpair used: 0x30
  phy0: Selected rate control algorithm 'minstrel'
  ath5k phy0: Atheros AR5213A chip found (MAC: 0x59, PHY: 0x43)
  ath5k phy0: RF2112B 2GHz radio found (0x46)
! cfg80211: Calling CRDA for country: AM
</snip>

So it looks as if ath5k has started to override the regdomain I want.

Cheers,
FJP
