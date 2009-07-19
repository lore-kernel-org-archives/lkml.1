Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbZGSQCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbZGSQCn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 12:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754535AbZGSQCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 12:02:42 -0400
Received: from vms173015pub.verizon.net ([206.46.173.15]:39928 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735AbZGSQCk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 12:02:40 -0400
Date: Sun, 19 Jul 2009 16:13:30 +0000
From: Eric Buddington <ebuddington@verizon.net>
To: linux-kernel@vger.kernel.org
Subject: 2.6.29.5: MCE triggered by DV video grab
Message-id: <20090719161330.GA31522@pool-96-236-125-153.spfdma.east.verizon.net>
Reply-to: ebuddington@wesleyan.edu
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
Content-transfer-encoding: 8BIT
Organization: ECS Labs
X-Eric-conspiracy: there is no conspiracy
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux 2.6.29.5, most things configured as modules

Every time I try to grab video over a PCI ieee1394 card, the computer
reboots rather rudely. It is 100% (4/4) repeatable.

This is an 8-core (2xquad) machine:
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Xeon(R) CPU           E5410  @ 2.33GHz

I grabbed the following before the last crash (thanks, netconsole!)

----------------------------------------------------------------

CPU 4: Machine Check Exception: 0000000000000004
CPU 6: Machine Check Exception: 0000000000000004
CPU 0: Machine Check Exception: 0000000000000005
CPU 2: Machine Check Exception: 0000000000000005
CPU 6: Bank 0: 3200000410000800
CPU 0: Bank 5: 3200001084200e0f
CPU 2: Bank 5: 3200001080200e0f
CPU 6: Bank 5: 3200000040100e0f
Kernel panic - not syncing: CPU context corrupt
Kernel panic - not syncing: CPU context corrupt
Kernel panic - not syncing: CPU context corrupt
------------[ cut here ]------------
------------[ cut here ]------------
WARNING: at kernel/smp.c:329 smp_call_function_many+0x34/0x1ca()
------------[ cut here ]------------
WARNING: at kernel/smp.c:329 smp_call_function_many+0x34/0x1ca()
Modules linked in: netconsoleModules linked in: netconsole serio_raw netconsole serio_raw firewire_ohci serio_raw firewire_ohci firewire_core firewire_ohci firewire_core parport_pc firewire_core parport_pc parport parport_pc parport snd_pcsp parport snd_pcsp i2c_i801 snd_pcsp i2c_i801 pata_acpi i2c_i801 pata_acpi iTCO_wdt pata_acpi iTCO_wdt rtc_cmos iTCO_wdt rtc_cmos rtc_core rtc_cmos rtc_core rtc_lib rtc_core rtc_lib i5000_edac rtc_lib i5000_edac edac_core i5000_edac edac_core i5k_amb edac_core dv1394 tuner raw1394 tuner raw1394 ppp_deflate raw1394 ppp_deflate videobuf_dma_sg ppp_deflate videobuf_dma_sg pcmcia videobuf_dma_sg pcmcia snd_intel8x0 pcmcia snd_intel8x0 sbp2 snd_intel8x0 sbp2 ppp_async sbp2 ppp_async videobuf_core ppp_async videobuf_core v4l2_common videobuf_core v4l2_common ohci1394 v4l2_common ohci1394 btcx_risc ohci1394 btcx_risc snd_ac97_codec btcx_risc snd_ac97_codec asix snd_ac97_codec asix videodev asix videodev tveeprom videodev tveeprom pcmcia_core tveeprom pcmcia_core v4l1_compat snd_bt87x v4l1_compat usbnet v4l1_compat usbnet 8139too usbnet 8139too usb_storage 8139too usb_storage configfs usb_storage configfs i2c_core configfs i2c_core slhc i2c_core slhc crc_ccitt slhc crc_ccitt ufs crc_ccitt ufs ac97_bus ufs ac97_bus [last unloaded: evbug] ac97_bus [last unloaded: evbug]

--------------------------------

And putting that into mcelog tells me:

-bash-3.2# ./mcelog --ascii <mce.txt                       
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
CPU 6 BANK 0 MCG status:RIPV MCIP 
MCi status:
Invalid log
STATUS 0 MCGSTATUS 5

-----------------------------------

I realize that this may well be hardware, and not really a Linux
kernel issue - but I don't know enough to be sure, and any advice would
be appreciated.

-Eric
