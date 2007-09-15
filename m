Return-Path: <linux-kernel-owner+w=401wt.eu-S1756108AbXIOOHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbXIOOHk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 10:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbXIOOHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 10:07:13 -0400
Received: from smtp2e.orange.fr ([80.12.242.111]:38730 "EHLO smtp2e.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbXIOOHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 10:07:10 -0400
X-ME-UUID: 20070915140708658.A0AC17000087@mwinf2e01.orange.fr
Message-ID: <46EBE70C.2040201@free.fr>
Date: Sat, 15 Sep 2007 16:07:08 +0200
From: Eric Valette <eric.valette@free.fr>
Reply-To: eric.valette@free.fr
Organization: HOME
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: flamingice@sourmilk.net, andreamrl@tiscali.it
Cc: linux-kernel@vger.kernel.org
Subject: rtl8187 driver in 2.6.23-rc6-git5: kernel panic if not used as a
 module. Works as a module.
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

First let me start by a thanks: it was the last piece of my P5W de luxe
machine based that has not its driver from stock kernel.

It works like a charm when used as a module:

lsusb
Bus 005 Device 001: ID 0000:0000
Bus 003 Device 001: ID 0000:0000
Bus 004 Device 001: ID 0000:0000
Bus 002 Device 001: ID 0000:0000
Bus 001 Device 007: ID 0bda:8187 Realtek Semiconductor Corp.  <=========
Bus 001 Device 005: ID 05e3:0606 Genesys Logic, Inc. D-Link DUB-H4 USB
2.0 Hub
Bus 001 Device 004: ID 03f0:c202 Hewlett-Packard
Bus 001 Device 006: ID 058f:6362 Alcor Micro Corp. Hi-Speed Internal
Multi-Card Reader/Writer
Bus 001 Device 001: ID 0000:0000
Bus 001 Device 003: ID 05e3:0606 Genesys Logic, Inc. D-Link DUB-H4 USB
2.0 Hub
Bus 001 Device 002: ID 05e3:0606 Genesys Logic, Inc. D-Link DUB-H4 USB
2.0 Hub


wlan0     IEEE 802.11g  ESSID:"xxxxxxxx"
          Mode:Managed  Frequency:2.437 GHz  Access Point: 00:18:E7:15:2B:2A
          Bit Rate=11 Mb/s
          Retry min limit:7   RTS thr:off   Fragment thr=2346 B
          Encryption key:xxxxxxxxx
          Link Quality=43/64  Signal level=39/65
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0


wlan0     Lien encap:Ethernet  HWaddr 00:15:AF:0A:BE:A9
          inet adr:192.168.1.11  Bcast:192.168.1.255  Masque:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:637 errors:0 dropped:0 overruns:0 frame:0
          TX packets:562 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 lg file transmission:1000
          RX bytes:373558 (364.8 KiB)  TX bytes:88216 (86.1 KiB)


However, when I compile it directly inside the kernel, I get a panic
with a backtrace at usb initilialisation. The backtrace points to
registering things in /proc (make-directory or something)!

I can probably take a picture of the backtrace if you want.

Config: Asus P5W de luxe, Intel(R) Core(TM)2 CPU 6600  @ 2.40GHz, pure
64 bits install.

-- eric

