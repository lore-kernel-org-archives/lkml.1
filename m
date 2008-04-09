Return-Path: <linux-kernel-owner+w=401wt.eu-S1758531AbYDIU3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531AbYDIU3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 16:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753455AbYDIU3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 16:29:38 -0400
Received: from mk-outboundfilter-3.mail.uk.tiscali.com ([212.74.114.23]:56377
	"EHLO mk-outboundfilter-3.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753238AbYDIU3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 16:29:37 -0400
X-Trace: 91367180/mk-outboundfilter-1.mail.uk.tiscali.com/F2S/$ACCEPTED/freedom2Surf-customers/83.67.11.44
X-SBRS: None
X-RemoteIP: 83.67.11.44
X-IP-MAIL-FROM: tvrtko@ursulin.net
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlMFAK7D/EdTQwss/2dsb2JhbACBXKo6
X-IP-Direction: IN
From: "Tvrtko A. Ursulin" <tvrtko@ursulin.net>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: libata errors with smartctl on 2.6.24, WD3200AAKS and nVidia AHCI
Date: Wed, 9 Apr 2008 21:30:07 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804092130.07149.tvrtko@ursulin.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,

When running smartctl to get the attributes readout libata seems to get
really confused on my system. After a timeout it recovers without apparent
ill-effect, but the reported values are complete rubbish. Unfortunately I don't
remember if this is a regression or it was always like this..

I have attached some data below, but if more is needed just shout!

Regards,

Tvrtko

root@sol:~# uname -a
Linux sol 2.6.24.3 #4 SMP PREEMPT Sat Mar 8 12:57:56 GMT 2008 x86_64 GNU/Linux

root@sol:~# smartctl -A /dev/sda
smartctl version 5.37 [x86_64-unknown-linux-gnu] Copyright (C) 2002-6 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF READ SMART DATA SECTION ===
SMART Attributes Data Structure revision number: 17018
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
255 Unknown_Attribute       0x373f   200   016   063    Pre-fail  Always   In_the_past 69269232549888
 45 Unknown_Attribute       0x4344   087   082   068    Old_age   Offline      -       61779704492097
 51 Unknown_Attribute       0x0039   000   000   057    Pre-fail  Offline  FAILING_NOW 52987850404480
 66 Unknown_Attribute       0x3231   048   068   049    Pre-fail  Offline  FAILING_NOW 55350388793431
 48 Unknown_Attribute       0x4130   065   083   048    Old_age   Offline      -       71675860037707
 32 Unknown_Attribute       0x2030   032   032   048    Old_age   Offline  FAILING_NOW 35322350018592
 32 Unknown_Attribute       0x2020   032   032   032    Old_age   Offline  FAILING_NOW 550026354720
 16 Unknown_Attribute       0x3f00   000   016   000    Old_age   Offline  FAILING_NOW 280379760114684
255 Unknown_Attribute       0x000f   000   007   015    Pre-fail  Always   FAILING_NOW 131943408599808
120 Unknown_Attribute       0x7800   000   000   000    Old_age   Offline  FAILING_NOW 0
 64 Unknown_Attribute       0xfe00   001   000   000    Old_age   Offline  In_the_past 39030002838272
104 Unknown_Attribute       0x4174   188   035   116    Old_age   Offline  In_the_past 48379254046529
225 Load_Cycle_Count        0x484e   000   085   078    Old_age   Always   FAILING_NOW 86
144 Unknown_Attribute       0x0016   000   000   022    Old_age   Always   FAILING_NOW 0



[ 7846.128079] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
[ 7846.128086] ata2.00: cmd b0/da:00:00:4f:c2/00:00:00:00:00/00 tag 0
[ 7846.128087]          res 40/00:01:b4:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 7846.128090] ata2.00: status: { DRDY }
[ 7846.128096] ata2: hard resetting link
[ 7846.735912] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 7846.760523] ata2.00: configured for UDMA/133
[ 7846.760530] ata2: EH complete
[ 7846.760546] sd 1:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
[ 7846.760556] sd 1:0:0:0: [sda] Write Protect is off
[ 7846.760558] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[ 7846.760571] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[ 7852.748405] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
[ 7852.748412] ata2.00: cmd b0/d1:01:01:4f:c2/00:00:00:00:00/00 tag 0 pio 512 in
[ 7852.748413]          res 40/00:01:b4:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 7852.748416] ata2.00: status: { DRDY }
[ 7852.748421] ata2: hard resetting link
[ 7853.356244] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 7853.378276] ata2.00: configured for UDMA/133
[ 7853.378284] ata2: EH complete
[ 7853.378416] sd 1:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
[ 7853.378519] sd 1:0:0:0: [sda] Write Protect is off
[ 7853.378521] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[ 7853.378761] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

00:0e.0 SATA controller: nVidia Corporation Unknown device 07f4 (rev a2) (prog-if 01 [AHCI 1.0])
        Subsystem: Giga-byte Technology Unknown device b002
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0 (750ns min, 250ns max)
        Interrupt: pin A routed to IRQ 316
        Region 0: I/O ports at 09f0 [size=8]
        Region 1: I/O ports at 0bf0 [size=4]
        Region 2: I/O ports at 0970 [size=8]
        Region 3: I/O ports at 0b70 [size=4]
        Region 4: I/O ports at dc00 [size=16]
        Region 5: Memory at e5104000 (32-bit, non-prefetchable) [size=8K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [8c] #12 [0010]
        Capabilities: [b0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/3 Enable+
                Address: 00000000fee0100c  Data: 4181

root@sol:~# lsscsi
[1:0:0:0]    disk    ATA      WDC WD3200AAKS-0 12.0  /dev/sda
[2:0:0:0]    cd/dvd  TSSTcorp CDDVDW SH-S203N  SB01  /dev/scd0


root@sol:~# lsmod | grep -e "a[th][ac]"
ahci                   27524  8
ata_generic             6404  0
libata                152048  2 ahci,ata_generic
scsi_mod              152752  5 firewire_sbp2,sg,sr_mod,sd_mod,libata



