Return-Path: <linux-kernel-owner+w=401wt.eu-S1759956AbYENG7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759956AbYENG7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 02:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753097AbYENG7B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 02:59:01 -0400
Received: from mk-outboundfilter-3.mail.uk.tiscali.com ([212.74.114.23]:33511
	"EHLO mk-outboundfilter-3.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753024AbYENG66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 02:58:58 -0400
X-Trace: 115496269/mk-outboundfilter-1.mail.uk.tiscali.com/F2S/$ACCEPTED/freedom2Surf-customers/83.67.11.44
X-SBRS: None
X-RemoteIP: 83.67.11.44
X-IP-MAIL-FROM: tvrtko@ursulin.net
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEABgqKkhTQwss/2dsb2JhbACBU6wg
X-IronPort-AV: E=Sophos;i="4.27,484,1204502400"; 
   d="scan'208";a="115496269"
X-IP-Direction: IN
From: "Tvrtko A. Ursulin" <tvrtko@ursulin.net>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: libata errors with smartctl on 2.6.24, WD3200AAKS and nVidia AHCI
Date: Wed, 14 May 2008 07:58:53 +0100
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bruce Allen <ballen@gravity.phys.uwm.edu>
References: <200804092130.07149.tvrtko@ursulin.net> <200804150721.17337.tvrtko@ursulin.net> <482A7C2C.6040302@gmail.com>
In-Reply-To: <482A7C2C.6040302@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805140758.53407.tvrtko@ursulin.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 May 2008 06:44:12 Tejun Heo wrote:
> Tvrtko A. Ursulin wrote:
> > On Tuesday 15 April 2008 04:10:57 Tejun Heo wrote:
> >> Tvrtko A. Ursulin wrote:
> >>> On Sunday 13 April 2008 04:11:15 Tejun Heo wrote:
> >>>> Is auto spindown configured for the drive?
> >>>
> >>> I don't think so - it's a 3.5" drive with no special PM features - but
> >>> how to tell?
> >>
> >> Hmm... Can you please post the result of "smartctl --version" and
> >> "smartctl -a > out 2>&1" and dmesg after the smartctl command?
> >
> > Yep, pasted and attached below. dmesg is 67k, hope list is happy with
> > that.
>
> Thanks for the data.  Nothing really stands out tho.  It looks like the
> drive just doesn't like SMART commands 0xda and 0xd1.  0xda being a
> mandatory non-data command, it failing due to driver problem is unlikely.
>
> Can you please post the result of "hdparm -I /dev/sda" and "lspci -nn"?

Of course:

root@sol:~# hdparm -I /dev/sda

/dev/sda:

ATA device, with non-removable media
        Model Number:       WDC WD3200AAKS-00VYA0
        Serial Number:      WD-WCARW0059893
        Firmware Revision:  12.01B02
Standards:
        Supported: 8 7 6 5
        Likely used: 8
Configuration:
        Logical         max     current
        cylinders       16383   16383
        heads           16      16
        sectors/track   63      63
        --
        CHS current addressable sectors:   16514064
        LBA    user addressable sectors:  268435455
        LBA48  user addressable sectors:  625142448
        device size with M = 1024*1024:      305245 MBytes
        device size with M = 1000*1000:      320072 MBytes (320 GB)
Capabilities:
        LBA, IORDY(can be disabled)
        Queue depth: 32
        Standby timer values: spec'd by Standard, with device specific minimum
        R/W multiple sector transfer: Max = 16  Current = 0
        Recommended acoustic management value: 128, current value: 254
        DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6
             Cycle time: min=120ns recommended=120ns
        PIO: pio0 pio1 pio2 pio3 pio4
             Cycle time: no flow control=120ns  IORDY flow control=120ns
Commands/features:
        Enabled Supported:
                SMART feature set
                Security Mode feature set
           *    Power Management feature set
           *    Write cache
           *    Look-ahead
           *    Host Protected Area feature set
           *    WRITE_BUFFER command
           *    READ_BUFFER command
           *    NOP cmd
           *    DOWNLOAD_MICROCODE
                Power-Up In Standby feature set
           *    SET_FEATURES required to spinup after power up
                SET_MAX security extension
                Automatic Acoustic Management feature set
           *    48-bit Address feature set
           *    Device Configuration Overlay feature set
           *    Mandatory FLUSH_CACHE
           *    FLUSH_CACHE_EXT
           *    SMART error logging
           *    SMART self-test
           *    General Purpose Logging feature set
           *    64-bit World wide name
           *    Segmented DOWNLOAD_MICROCODE
           *    SATA-I signaling speed (1.5Gb/s)
           *    SATA-II signaling speed (3.0Gb/s)
           *    Native Command Queueing (NCQ)
           *    Host-initiated interface power management
           *    Phy event counters
                DMA Setup Auto-Activate optimization
           *    Software settings preservation
           *    SMART Command Transport (SCT) feature set
           *    SCT Long Sector Access (AC1)
           *    SCT LBA Segment Access (AC2)
           *    SCT Error Recovery Control (AC3)
           *    SCT Features Control (AC4)
           *    SCT Data Tables (AC5)
                unknown 206[12] (vendor specific)
                unknown 206[13] (vendor specific)
Security:
        Master password revision code = 65534
                supported
        not     enabled
        not     locked
        not     frozen
        not     expired: security count
                supported: enhanced erase
        88min for SECURITY ERASE UNIT. 88min for ENHANCED SECURITY ERASE UNIT.
Logical Unit WWN Device Identifier: 50014ee1485655
        NAA             : 5
        IEEE OUI        : 14ee
        Unique ID       : 1485655
Checksum: correct
root@sol:~# lspci -nn
00:00.0 Host bridge [0600]: nVidia Corporation Unknown device [10de:07c1] (rev a2)
00:00.1 RAM memory [0500]: nVidia Corporation nForce 630i memory controller [10de:07cb] (rev a2)
00:01.0 RAM memory [0500]: nVidia Corporation nForce 630i memory controller [10de:07cd] (rev a1)
00:01.1 RAM memory [0500]: nVidia Corporation nForce 630i memory controller [10de:07ce] (rev a1)
00:01.2 RAM memory [0500]: nVidia Corporation nForce 630i memory controller [10de:07cf] (rev a1)
00:01.3 RAM memory [0500]: nVidia Corporation nForce 630i memory controller [10de:07d0] (rev a1)
00:01.4 RAM memory [0500]: nVidia Corporation nForce 630i memory controller [10de:07d1] (rev a1)
00:01.5 RAM memory [0500]: nVidia Corporation nForce 630i memory controller [10de:07d2] (rev a1)
00:01.6 RAM memory [0500]: nVidia Corporation nForce 630i memory controller [10de:07d3] (rev a1)
00:02.0 RAM memory [0500]: nVidia Corporation nForce 630i memory controller [10de:07d6] (rev a1)
00:03.0 ISA bridge [0601]: nVidia Corporation Unknown device [10de:07d7] (rev a2)
00:03.1 SMBus [0c05]: nVidia Corporation Unknown device [10de:07d8] (rev a1)
00:03.2 RAM memory [0500]: nVidia Corporation Unknown device [10de:07d9] (rev a1)
00:03.4 RAM memory [0500]: nVidia Corporation Unknown device [10de:07c8] (rev a1)
00:04.0 USB Controller [0c03]: nVidia Corporation GeForce 7100/nForce 630i [10de:07fe] (rev a1)
00:04.1 USB Controller [0c03]: nVidia Corporation GeForce 7100/nForce 630i [10de:056a] (rev a1)
00:08.0 IDE interface [0101]: nVidia Corporation Unknown device [10de:056c] (rev a1)
00:09.0 Audio device [0403]: nVidia Corporation MCP73 High Definition Audio [10de:07fc] (rev a1)
00:0a.0 PCI bridge [0604]: nVidia Corporation Unknown device [10de:056d] (rev a1)
00:0b.0 PCI bridge [0604]: nVidia Corporation Unknown device [10de:056e] (rev a1)
00:0c.0 PCI bridge [0604]: nVidia Corporation Unknown device [10de:056f] (rev a1)
00:0d.0 PCI bridge [0604]: nVidia Corporation Unknown device [10de:056f] (rev a1)
00:0e.0 SATA controller [0106]: nVidia Corporation GeForce 7100/nForce 630i [10de:07f4] (rev a2)
00:0f.0 Ethernet controller [0200]: nVidia Corporation MCP73 Ethernet [10de:07dc] (rev a2)
00:10.0 VGA compatible controller [0300]: nVidia Corporation GeForce 7100/nForce 630i [10de:07e1] (rev a2)
01:07.0 FireWire (IEEE 1394) [0c00]: Texas Instruments TSB43AB23 IEEE-1394a-2000 Controller (PHY/Link) [104c:8024]

Tvrtko

