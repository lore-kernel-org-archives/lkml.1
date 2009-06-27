Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbZF0Pww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbZF0Pww (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 11:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbZF0Pwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 11:52:44 -0400
Received: from tur.go2.pl ([193.17.41.50]:43858 "EHLO tur.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280AbZF0Pwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 11:52:43 -0400
From: Zbigniew Luszpinski <zbiggy@o2.pl>
To: linux-kernel@vger.kernel.org
Subject: OHCI USB hangs during intensive use, nVidia MCP78S chipset, few questions to help me find the problem.
Date: Sat, 27 Jun 2009 17:51:21 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.30; KDE/4.2.4; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906271751.21418.zbiggy@o2.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

after upgrading my CPU from single core to multicore and mainboard I started 
to have problem with OHCI USB controller. It hangs during big data transfer 
(USB hdd drive, pendrive, IRDA dongle or adsl modem). The result of hang is 
usb device is not responding. This is the only error I found. I would like to 
learn why it hangs and fix it. I tried kernels 2.6.27-30 and most popular 
Linux distributions. Adding noapic or acpi=noirq parameter to kernel boot line 
almost workarounds the problem, disabling tickless kernel: CONFIG_NO_HZ also 
makes usb ohci hanging a little bit less. Usb 1.1 devices still hangs but 
seldom: only transferring over 100MiB file to/from usb hdd or downloading 
CentOS dvd iso from ftp or torrent can hang usb. I do not want to be left with 
workaround. I want to fix it. Can you tell me how to find the issue and where 
to look for faulty code? By looking at kernel parameters which cures the usb 
ohci bug it must be something wrong with IRQs.

Questions which will help me narrowing the source of the problem:
Can you confirm/deny that Linux usb ohci driver works perfect on multicore 
Phenom cpu when big data transfer happens (Phenom 9550 reports very welcome)?
Can you confirm/deny that Linux usb ohci driver works perfect on nVidia MCP78S  
(Geforce 8200) chipset when big data transfer happens?
If you have working/non working ohci on your Geforce 8200 mainboard please 
include detailed information about your system:
-cpu model (manufacturer, model)
-mainboard (manufacturer, model, bios version)

I have changed:
mainboard: Asus A8N-VM CSM (nVidia nForce 6150/430) to:
mainboard: ASRock K10N78FullHD-hSLI R3.0 (nVidia MCP78S (Geforce8200))
cpu: Athlon64 3000+ Venice (1 core) to:
cpu: Phenom 9550 (4 cores)
mem: 4x256MiB DDR400 (twinbank) to 2x1GiB DDR2 800 CL4 (twinbank)

The previous mainboard works perfectly with usb 1.1 devices. The new one is 
not. I tried M$ Win XP Pro SP3 and ohci usb works perfectly so new mainboard 
is not broken - this is software bug in bios or Linux ohci/IRQ on this 
mainboard.
All usb 1.1 devices works perfectly with all my previous mainboards so this 
must be new mainboard incompatibility with Linux up to and including 2.6.30.

Here is my bug report:
http://bugzilla.kernel.org/show_bug.cgi?id=13405

have a nice day,
Zbigniew Luszpinski

