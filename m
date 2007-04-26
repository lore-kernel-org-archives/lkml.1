Return-Path: <linux-kernel-owner+w=401wt.eu-S1031150AbXDZKjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031150AbXDZKjK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 06:39:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031157AbXDZKjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 06:39:10 -0400
Received: from ara.aytolacoruna.es ([195.55.102.196]:42311 "EHLO
	mx.aytolacoruna.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031150AbXDZKjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 06:39:08 -0400
X-Greylist: delayed 1567 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Apr 2007 06:39:08 EDT
Date: Thu, 26 Apr 2007 12:12:48 +0200
From: Santiago Garcia Mantinan <manty@manty.net>
To: linux-kernel@vger.kernel.org
Subject: [ALSA] 2.6.21 loading of module snd_ymfpci takes 2 minutes
Message-ID: <20070426101248.GA15419@clandestino.aytolacoruna.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have just upgraded from 2.6.20 to 2.6.21, when I rebooted I thought the
computer had halted after loading snd_ymfpci, but what happens is that it
takes 2 minutes (120 seconds mesured with time) for the driver to load, but
then works as expected.

After making a diff between the 2.6.20 and 2.6.21 versions of the ymfpci
driver I decided to replace the ymfpci_main.c from 2.6.21 with the one from
2.6.20, it compiled with a few warnings and then worked ok, like it used to
work, without the two minutes delay.

These are the messages I get from the kernel when I load the driver:
PCI: Enabling device 0000:00:0a.0 (0000 -> 0002)
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LNKD] -> GSI 9 (level, low) -> IRQ 9

This is the info I got for the sound card, which is integrated on the
motherboard:

Card: Yamaha DS-1L (YMF740C)
Chip: Asahi Kasei AK4543

lspci:
00:0a.0 0401: 1073:000c (rev 03)
        Subsystem: 1033:804b
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR+
        Latency: 64 (1250ns min, 6250ns max)
        Interrupt: pin A routed to IRQ 9
        Region 0: Memory at e8108000 (32-bit, non-prefetchable) [size=32K]
        Capabilities: <access denied>

/proc/asound/cards:
 0 [YMF740C        ]: YMF740C - Yamaha DS-1L (YMF740C)
                      Yamaha DS-1L (YMF740C) at 0xe8108000, irq 9

Hope that helps to diagnose the problem, if you need any other info don't
hesitate to contact me.

Regards...
-- 
Santiago García Mantiñán
