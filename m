Return-Path: <linux-kernel-owner+w=401wt.eu-S1758821AbXFMQC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758821AbXFMQC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 12:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758031AbXFMQCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 12:02:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49904 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757016AbXFMQCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 12:02:21 -0400
Date: Wed, 13 Jun 2007 12:01:52 -0400
From: Dave Jones <davej@redhat.com>
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Wang Zhenyu <zhenyu.z.wang@intel.com>, Eric Anholt <eric@anholt.net>
Subject: Re: I815 suddenly unkown to agpgart?
Message-ID: <20070613160152.GC3875@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Meelis Roos <mroos@linux.ee>,
	Linux Kernel list <linux-kernel@vger.kernel.org>,
	Wang Zhenyu <zhenyu.z.wang@intel.com>,
	Eric Anholt <eric@anholt.net>
References: <Pine.SOC.4.64.0706131804180.2614@math>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.SOC.4.64.0706131804180.2614@math>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2007 at 06:07:42PM +0300, Meelis Roos wrote:
 > agpgart: Unsupported Intel chipset(device id: 1130)

This is likely due to 9614ece14f23f2ce54a076c471aec9c91e51e79c

    [AGPGART] intel_agp: use table for device probe
    
    Fixed issues noted by Christoph Hellwig, and I changed device table
    scan a bit to allow the case that some models of graphics chips may
    have same host bridge type. This type of chip will be added in the future.
    
    This patch cleans up device probe function. Eric Anholt was the original author.


Eric ?

	Dave



 > This came with todays 2.6.22-rc4+git on my Intel 815 chipset PC. lspci 
 > -vvvn and full dmesg are below.
 > 
 > 00:00.0 0600: 8086:1130 (rev 02)
 > 	Subsystem: 8086:4532
 > 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
 > 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
 > 	Latency: 0
 > 	Region 0: Memory at f8000000 (32-bit, prefetchable) [size=64M]
 > 	Capabilities: [88] Vendor Specific Information
 > 	Capabilities: [a0] AGP version 2.0
 > 		Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW- AGP3- Rate=x1,x2
 > 		Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW- Rate=<none>
 > 
 > 00:01.0 0604: 8086:1131 (rev 02) (prog-if 00 [Normal decode])
 > 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
 > 	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
 > 	Latency: 32
 > 	Bus: primary=00, secondary=02, subordinate=02, sec-latency=32
 > 	I/O behind bridge: 0000d000-0000dfff
 > 	Memory behind bridge: ff900000-ff9fffff
 > 	Prefetchable memory behind bridge: eea00000-f6afffff
 > 	Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR+
 > 	BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
 > 
 > ....
 >
 > 02:00.0 0300: 1002:5246 (prog-if 00 [VGA])
 > 	Subsystem: 1002:0008
 > 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping+ SERR- FastB2B-
 > 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
 > 	Latency: 32 (2000ns min), Cache Line Size: 32 bytes
 > 	Interrupt: pin A routed to IRQ 11
 > 	Region 0: Memory at f0000000 (32-bit, prefetchable) [size=64M]
 > 	Region 1: I/O ports at d800 [size=256]
 > 	Region 2: Memory at ff9fc000 (32-bit, non-prefetchable) [size=16K]
 > 	Expansion ROM at ff9c0000 [disabled] [size=128K]
 > 	Capabilities: [50] AGP version 2.0
 > 		Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW- AGP3- Rate=x1,x2
 > 		Command: RQ=1 ArqSz=0 Cal=0 SBA+ AGP- GART64- 64bit- FW- Rate=<none>
 > 	Capabilities: [5c] Power Management version 1
 > 		Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
 > 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
 > 
 > Linux version 2.6.22-rc4-ga0e1d1d0 (mroos@rhn) (gcc version 4.1.3 20070601 (prerelease) (Debian 4.1.2-12)) #380 PREEMPT Wed Jun 13 10:15:07 EEST 2007
 > BIOS-provided physical RAM map:
 > ....
 > Linux agpgart interface v0.102 (c) Dave Jones
 > agpgart: Unsupported Intel chipset(device id: 1130)


-- 
http://www.codemonkey.org.uk
