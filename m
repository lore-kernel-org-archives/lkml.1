Return-Path: <linux-kernel-owner+w=401wt.eu-S1759187AbXJaAwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759187AbXJaAwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 20:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754520AbXJaAwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 20:52:30 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:47951 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478AbXJaAw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 20:52:29 -0400
Date: Wed, 31 Oct 2007 01:52:40 +0100
From: Pavel Machek <pavel@ucw.cz>
To: linux-wireless@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>,
       ipw3945-devel@lists.sourceforge.net, yi.zhu@intel.com
Subject: iwl3945 in 2.6.24-rc1 dies under load
Message-ID: <20071031005202.GA1534@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi!

...does not seem to work too well :-(. It connects with the AP
(good!), and survives some "normal" use, but it died at first big
tcpspray (baaaad!).

Oct 31 01:03:57 amd log1n[1411]: ROOT LOGIN on `tty6'
Oct 31 01:05:06 amd kernel: iwl3945: Intel(R) PRO/Wireless 3945ABG/BG
Network Connection driver for Linux, 1.1.17kds
Oct 31 01:05:06 amd kernel: iwl3945: Copyright(c) 2003-2007 Intel
Corporation
Oct 31 01:05:06 amd kernel: PCI: Setting latency timer of device
0000:03:00.0 to 64
Oct 31 01:05:06 amd kernel: iwl3945: Detected Intel PRO/Wireless
3945ABG Network Connection
Oct 31 01:05:07 amd kernel: iwl3945: Tunable channels: 11 802.11bg, 13
802.11a channels
Oct 31 01:05:07 amd kernel: phy4: Selected rate control algorithm
'simple'
Oct 31 01:06:05 amd kernel: wlan0: Initial auth_alg=0
Oct 31 01:06:05 amd kernel: wlan0: authenticate with AP
00:11:2f:0e:95:a0
Oct 31 01:06:05 amd kernel: wlan0: RX authentication from
00:11:2f:0e:95:a0 (alg=0 transaction=2 status=0)
Oct 31 01:06:05 amd kernel: wlan0: authenticated
Oct 31 01:06:05 amd kernel: wlan0: associate with AP 00:11:2f:0e:95:a0
Oct 31 01:06:05 amd kernel: wlan0: RX AssocResp from 00:11:2f:0e:95:a0
(capab=0x401 status=0 aid=1)
Oct 31 01:06:05 amd kernel: wlan0: associated
Oct 31 01:06:05 amd kernel: wlan0: switched to short barker preamble
(BSSID=00:11:2f:0e:95:a0)
Oct 31 01:06:05 amd kernel: iwl3945: iwl-3945-rs not selected as rate
control algo!
Oct 31 01:23:52 amd kernel: wlan0: RX deauthentication from
00:11:2f:0e:95:a0 (reason=4)
Oct 31 01:23:52 amd kernel: wlan0: deauthenticated
Oct 31 01:23:53 amd kernel: wlan0: authenticate with AP
00:11:2f:0e:95:a0
Oct 31 01:23:53 amd kernel: wlan0: RX authentication from
00:11:2f:0e:95:a0 (alg=0 transaction=2 status=0)
Oct 31 01:23:53 amd kernel: wlan0: authenticated
Oct 31 01:23:53 amd kernel: wlan0: associate with AP 00:11:2f:0e:95:a0
Oct 31 01:23:53 amd kernel: wlan0: RX ReassocResp from
00:11:2f:0e:95:a0 (capab=0x401 status=0 aid=1)
Oct 31 01:23:53 amd kernel: wlan0: associated
Oct 31 01:23:53 amd kernel: wlan0: switched to short barker preamble
(BSSID=00:11:2f:0e:95:a0)
Oct 31 01:23:53 amd kernel: iwl3945: iwl-3945-rs not selected as rate
control algo!
Oct 31 01:23:53 amd kernel: wlan0: CTS protection enabled
(BSSID=00:11:2f:0e:95:a0)
Oct 31 01:23:53 amd kernel: wlan0: switched to long barker preamble
(BSSID=00:11:2f:0e:95:a0)
Oct 31 01:35:44 amd -- MARK --
Oct 31 01:38:16 amd kernel: iwl3945: Microcode SW error detected.
Restarting 0x82000008.
Oct 31 01:38:16 amd kernel: iwl3945: Error Reply type 0x00000005 cmd
REPLY_TX (0x1C) seq 0x0267 ser 0x0000004B
Oct 31 01:38:18 amd kernel: iwl3945: Can't stop Rx DMA.

...unfortunately, microcode sources are not available so Intel should
fix this, right?

(Actually, it recovered after 3 minutes):

Oct 31 01:41:15 amd kernel: wlan0: RX deauthentication from
00:11:2f:0e:95:a0 (reason=4)
Oct 31 01:41:15 amd kernel: wlan0: deauthenticated
Oct 31 01:41:16 amd kernel: wlan0: authenticate with AP
00:11:2f:0e:95:a0
Oct 31 01:41:16 amd kernel: wlan0: RX authentication from
00:11:2f:0e:95:a0 (alg=0 transaction=2 status=0)
Oct 31 01:41:16 amd kernel: wlan0: authenticated
Oct 31 01:41:16 amd kernel: wlan0: associate with AP 00:11:2f:0e:95:a0
Oct 31 01:41:16 amd kernel: wlan0: RX ReassocResp from
00:11:2f:0e:95:a0 (capab=0x401 status=0 aid=1)
Oct 31 01:41:16 amd kernel: wlan0: associated
Oct 31 01:41:16 amd kernel: wlan0: CTS protection enabled
(BSSID=00:11:2f:0e:95:a0)
Oct 31 01:41:16 amd kernel: iwl3945: iwl-3945-rs not selected as rate
control algo!
Oct 31 01:41:16 amd kernel: wlan0: switched to short barker preamble
(BSSID=00:11:2f:0e:95:a0)

Hmm, and it is pretty reproducible, with:

tcpspray -n 1 -b 10000000 10.0.0.2

Oct 31 01:42:56 amd kernel: iwl3945: Microcode SW error detected.
Restarting 0x82000008.
Oct 31 01:42:56 amd kernel: iwl3945: Error Reply type 0x00000005 cmd
REPLY_TX (0x1C) seq 0x02C7 ser 0x0000004B
Oct 31 01:42:58 amd kernel: iwl3945: Can't stop Rx DMA.

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
