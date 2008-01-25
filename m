Return-Path: <linux-kernel-owner+w=401wt.eu-S1760856AbYAYVoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760856AbYAYVoA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 16:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756619AbYAYVnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 16:43:53 -0500
Received: from ara.aytolacoruna.es ([91.117.124.165]:43566 "EHLO
	mx.aytolacoruna.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756726AbYAYVnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 16:43:52 -0500
X-Greylist: delayed 1909 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jan 2008 16:43:51 EST
Date: Fri, 25 Jan 2008 22:11:53 +0100
From: Santiago Garcia Mantinan <manty@manty.net>
To: linux-kernel@vger.kernel.org
Subject: dl2k stopped working on 2.6.24
Message-ID: <20080125211153.GA10203@dis.manty.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I have just updated my server to 2.6.24 and the dl2k driver has stopped
working.

The problem seems to be when autoselecting the media, the driver says that
the card is set as "Auto 1000 Mbps, Half duplex" instead of the usual "Auto
1000 Mbps, Full duplex", I have tried setting "options dl2k
media=1000mbps_fd" but that didn't seem to change anything (the driver still
said "Auto 1000 Mbps, Half duplex").

I've been playing with ethtools and got it to work at 100FD by setting it
manually, but if afterwards I set it to auto it again goes 1000 HD and thus
not working again.

I'm not getting any special messages from the kernel, the ifconfig shows
this when the card is failing:

eth0      Link encap:Ethernet  HWaddr 00:05:5D:79:5B:56  
          inet addr:192.168.1.90  Bcast:192.168.1.255  Mask:255.255.255.255
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:99 dropped:0 overruns:0 frame:99
          TX packets:54 errors:54 dropped:0 overruns:0 carrier:54
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 b)  TX bytes:6536 (6.3 KiB)
          Interrupt:11 Base address:0xe800 

lspci for my card shows:

00:09.0 0200: 1186:4000 (rev 0c)
        Subsystem: 1186:4000
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (20000ns min, 2500ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 11
        Region 0: I/O ports at e800 [size=256]
        Region 1: Memory at e7015000 (32-bit, non-prefetchable) [size=512]
        [virtual] Expansion ROM at 20000000 [disabled] [size=64K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME-

The machine is a PIII with a via chipset and the card was working perfectly
at 2.6.23 and before.

If you need any more info don't hesitate to ask.

Regards...
-- 
Manty/BestiaTester -> http://manty.net
