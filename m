Return-Path: <linux-kernel-owner+w=401wt.eu-S1756324AbYFXWZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324AbYFXWZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 18:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbYFXWZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 18:25:21 -0400
Received: from mxsec.euro-web.fr ([81.93.243.199]:50161 "EHLO
	mxsec.euro-web.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbYFXWZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 18:25:20 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Jun 2008 18:25:20 EDT
From: David CHANIAL <david.ml@euro-web.fr>
Organization: Euro Web
To: linux-kernel@vger.kernel.org
Subject: weird bug on r8169 with usb
Date: Wed, 25 Jun 2008 00:18:37 +0200
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806250018.37617.david.ml@euro-web.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi (Please excuse my bad english),

I think is there a bug on my linux box :
I hope you can say me that it is really a bug, or if i have to consider myself as bug :)

If i boot my system/kernel with usb devices plugged, eth0 is detected but unusable.
I unplug the usb devices, kernel boot, and eth0 is usable.
The bug is reproducible as much as necessary.

More informations :
(if you need more informations, ask, i will reply)

When i say that eth0 is unusable, i can see there no dhcp request can make a success.

I've seen the bug with :
	linux-2.6.24-gentoo-r8
	linux-2.6.25-gentoo-r5

I can test with a vanilla kernel (without the gentoo patches) but i "think" is there no link with the gentoo patches.
(Ask if necessary)

# lspci | grep Ether
 02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev ff)

# dmesg | grep eth0 # without the bug
 eth0: RTL8168c/8111c at 0xf8828000, 00:1e:8c:c4:66:7d, XID 3c2000c0 IRQ 18
 r8169: eth0: link up
 eth0: no IPv6 routers present

# dmesg | grep eth0 # with the bug
 eth0: RTL8168c/8111c at 0xf8828000, 00:1e:8c:c4:66:7d, XID 3c2000c0 IRQ 18
 r8169: eth0: link up
 eth0: no IPv6 routers present
 NETDEV WATCHDOG: eth0: transmit timed out
 r8169: eth0: link up
 [...] last twho lines repeat slowly but continually [...]

# cat /proc/interrupts  | grep eth0
 18:          3          4          3          3   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb7, eth0

# diff -U0 without_devices with_devices 
--- without_devices	2008-06-25 00:13:29.000000000 +0200
+++ with_devices	2008-06-25 00:14:00.000000000 +0200
@@ -7,0 +8 @@
+Bus 002 Device 007: ID 132b:2001 Konica Minolta 
@@ -12,0 +14 @@
+Bus 001 Device 003: ID 04b8:012e Seiko Epson Corp.


Thanks a lot.

Best regards,
-- 
David CHANIAL
