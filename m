Return-Path: <linux-kernel-owner+w=401wt.eu-S1754540AbZKLVQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbZKLVQ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 16:16:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754532AbZKLVQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 16:16:52 -0500
Received: from trinity.develer.com ([83.149.158.210]:57752 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbZKLVQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 16:16:48 -0500
Subject: ath9k: DMA failed to stop in 10 ms AR_CR=0x00000024
 AR_DIAG_SW=0x40000020
From: Bernie Innocenti <bernie@codewiz.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: ath9k-devel@venema.h4ckr.net, lkml <linux-kernel@vger.kernel.org>,
       Danny Clark <dclark@fsf.org>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Sugar Labs - http://www.sugarlabs.org/
Date: Thu, 12 Nov 2009 16:16:45 -0500
Message-ID: <1258060605.2953.1029.camel@giskard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've recently replaced the built-in Intel 5300 AGN of my Lenovo X200s
with an Atheros AR5008 express card. The operation requires a hacked
BIOS with no hw whitelist check--Thanks for the DRM, Lenovo).

The ath9k driver works great, but occasionally the interface
disassociates spontaneously and won't get back to work until I manually
unload and reload the ath9k module. It's hard to reproduce, but seems to
happen more frequently with some access points.

I'm seeing it both in Ubuntu Karmic (linux-image_2.6.31.14.48) and
Fedora Rawhide (kernel-2.6.31.5-127).

Dmesg contains:

[46623.757586] wlan1: associated
[47222.920159] wlan1: no probe response from AP 00:14:a8:53:3c:80 - disassociating
[47223.063855] ath9k: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x40000020
[47224.042616] ath9k: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x40000020

lspci -vv says:

03:00.0 Network controller: Atheros Communications Inc. AR5008 Wireless Network Adapter (rev 01)
	Subsystem: Atheros Communications Inc. Device 0032
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 17
	Region 0: Memory at f2500000 (64-bit, non-prefetchable) [size=64K]
	Capabilities: <access denied>
	Kernel driver in use: ath9k
	Kernel modules: ath9k

Best regards,

-- 
   // Bernie Innocenti - http://codewiz.org/
 \X/  Sugar Labs       - http://sugarlabs.org/

