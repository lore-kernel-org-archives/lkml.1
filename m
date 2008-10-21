Return-Path: <linux-kernel-owner+w=401wt.eu-S1756506AbYJUV1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506AbYJUV1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 17:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbYJUV11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 17:27:27 -0400
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:40103 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752191AbYJUV10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 17:27:26 -0400
Message-ID: <48FDFCCA.8040604@lwfinger.net>
Date: Tue, 21 Oct 2008 09:01:14 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Jouni Malinen <jouni.malinen@atheros.com>
CC: wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       John Linville <linville@tuxdriver.com>
Subject: Regression in 2.6.27-git from commit 43ac2ca3840f64
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my x86_64 system, the mainline 2.6.27-git kernel (v2.6.27-6030-g6da0b38)
shows the following anomaly with the 'iwlist scan' command:

          Cell 03 - Address: 00:14:BF:85:49:FA
                    ESSID:"lwfdjf"
                    Mode:Master
                    Channel:1
                    Frequency:2.412 GHz (Channel 1)
                    Quality=66/100  Signal level:-62 dBm  Noise level=-68 dBm
                    Encryption key:on
                    IE: Unknown: 00066C7766646A66
                    IE: Unknown: 010882848B962430486C
                    IE: Unknown: 030101
                    IE: Unknown: 2A0104
                    IE: Unknown: 2F0104
                    IE: Unknown: 32040C121860
                    IE: Unknown: DD09001018020014000000
                    IE: WPA Version 1
                        Group Cipher : TKIP
                        Pairwise Ciphers (1) : TKIP
                        Authentication Suites (1) : PSK
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 18 Mb/s
                              24 Mb/s; 36 Mb/s; 54 Mb/s; 6 Mb/s; 9 Mb/s
                              12 Mb/s; 48 Mb/s
                    Extra:tsf=0000014488aeb18b
                    Extra: Last beacon: 448ms ago

This problem was bisected to commit 43ac2ca3840f64f699a239535c590fa7ebaaac27,
entitled "mac80211: Handle scan result IEs in one block". The same bug is
present in the wireless-testing tree.

Larry

