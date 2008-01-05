Return-Path: <linux-kernel-owner+w=401wt.eu-S1757329AbYAEU3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329AbYAEU3S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 15:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756696AbYAEU3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 15:29:05 -0500
Received: from mailout01.sul.t-online.de ([194.25.134.80]:33063 "EHLO
	mailout01.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756469AbYAEU3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 15:29:04 -0500
Message-ID: <477FE882.1030901@t-online.de>
Date: Sat, 05 Jan 2008 21:28:50 +0100
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.24-rc6: ricoh_mmc woes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: Zqwq7wZ1wh-2v3qtV+rUpAYZx1LXIOZJC-AgOhw+W1-Ymd-O-VO9Fao-sYYJHr+gsp
X-TOI-MSGID: d7152acd-502f-4497-89b2-0de1d0e37a76
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

I've got a problem with a Ricoh mmc reader. As soon as I insert a
sd card I get tons of I/O errors. syslog says:

Jan  5 21:19:12 daffy kernel: ricoh-mmc: Ricoh MMC Controller disabling driver
Jan  5 21:19:12 daffy kernel: ricoh-mmc: Copyright(c) Philip Langdale
Jan  5 21:19:12 daffy kernel: ricoh-mmc: Ricoh MMC controller found at 0000:03:01.2 [1180:0843] (rev 12)
Jan  5 21:19:12 daffy kernel: ricoh-mmc: Controller is now disabled.
Jan  5 21:19:25 daffy kernel: mmc0: new high speed SD card at address 1234
Jan  5 21:19:25 daffy kernel: mmcblk0: mmc0:1234 SD01G 995328KiB
Jan  5 21:19:25 daffy kernel:  mmcblk0:<3>mmcblk0: error -84 transferring data
Jan  5 21:19:25 daffy kernel: end_request: I/O error, dev mmcblk0, sector 0
Jan  5 21:19:25 daffy kernel: printk: 32 messages suppressed.
Jan  5 21:19:25 daffy kernel: Buffer I/O error on device mmcblk0, logical block 0
Jan  5 21:19:25 daffy kernel: mmcblk0: error -84 transferring data
Jan  5 21:19:25 daffy kernel: end_request: I/O error, dev mmcblk0, sector 0
Jan  5 21:19:25 daffy kernel: Buffer I/O error on device mmcblk0, logical block 0
Jan  5 21:19:25 daffy kernel: mmcblk0: error -84 transferring data
Jan  5 21:19:25 daffy kernel: end_request: I/O error, dev mmcblk0, sector 0
Jan  5 21:19:25 daffy kernel: Buffer I/O error on device mmcblk0, logical block 0
Jan  5 21:19:25 daffy kernel: mmcblk0: error -84 transferring data
Jan  5 21:19:25 daffy kernel: end_request: I/O error, dev mmcblk0, sector 0
Jan  5 21:19:25 daffy kernel: Buffer I/O error on device mmcblk0, logical block 0
Jan  5 21:19:26 daffy kernel: mmcblk0: error -84 transferring data
Jan  5 21:19:26 daffy kernel: end_request: I/O error, dev mmcblk0, sector 0
Jan  5 21:19:26 daffy kernel: Buffer I/O error on device mmcblk0, logical block 0
Jan  5 21:19:26 daffy kernel: ldm_validate_partition_table(): Disk read failed.
Jan  5 21:19:26 daffy kernel: mmcblk0: error -84 transferring data
Jan  5 21:19:26 daffy kernel: end_request: I/O error, dev mmcblk0, sector 0
:
:

The ricoh_mmc disabler module is installed as a module. udev loads it
at boot time. But AFAICS I get the same errors if ricoh_mmc is removed.


lspci says

# lspci | grep -i ricoh
03:01.0 FireWire (IEEE 1394): Ricoh Co Ltd Unknown device 0832 (rev 05)
03:01.1 Generic system peripheral [0805]: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 22)
03:01.2 System peripheral: Ricoh Co Ltd Unknown device 0843 (rev 12)
03:01.3 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host Adapter (rev 12)
03:01.4 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev ff)
# lspci -n | grep 03:01
03:01.0 0c00: 1180:0832 (rev 05)
03:01.1 0805: 1180:0822 (rev 22)
03:01.2 0880: 1180:0843 (rev 12)
03:01.3 0880: 1180:0592 (rev 12)
03:01.4 0880: 1180:0852 (rev ff)


Of course the SD card works fine in another PC.

Any idea how to track this down? Please mail


Regards

Harri

