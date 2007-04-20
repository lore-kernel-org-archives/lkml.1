Return-Path: <linux-kernel-owner+w=401wt.eu-S1766514AbXDTI65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766514AbXDTI65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 04:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766799AbXDTI64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 04:58:56 -0400
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:40700 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766514AbXDTI6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 04:58:55 -0400
Date: Fri, 20 Apr 2007 10:58:53 +0200
From: Wolfgang Erig <Wolfgang.Erig@gmx.de>
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-kernel@vger.kernel.org
Subject: regression with gammu on 2.6.21-rc7
Message-ID: <20070420085853.GA5594@erig.dyndns.org>
Mail-Followup-To: Adrian Bunk <bunk@stusta.de>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a regression with 2.6.21-rc7-g80d74d51.
The utility "gammu" to talk to my mobile does not work anymore.
With 2.6.20 gammu runs fine.

Distribution is the latest Debian/testing

Wolfgang

$ gammu --backup backup
Press Ctrl+C to break...
I/O possible
$ uname -a
Linux max 2.6.21-rc7-g80d74d51 #9 SMP Wed Apr 18 21:41:41 CEST 2007 i686 GNU/Linux
$ tail messages 
Apr 20 08:04:36 max kernel: ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 16
Apr 20 08:04:36 max kernel: extern: link up, 100Mbps, full-duplex, lpa 0x45E1
Apr 20 08:04:36 max kernel: intern:  setting half-duplex.
Apr 20 08:09:02 max kernel: usb 2-2: USB disconnect, address 3
Apr 20 08:09:02 max kernel: pl2303 ttyUSB0: pl2303 converter now disconnected from ttyUSB0
Apr 20 08:09:02 max kernel: pl2303 2-2:1.0: device disconnected
Apr 20 08:10:24 max kernel: usb 2-2: new full speed USB device using uhci_hcd and address 4
Apr 20 08:10:25 max kernel: usb 2-2: configuration #1 chosen from 1 choice
Apr 20 08:10:25 max kernel: pl2303 2-2:1.0: pl2303 converter detected
Apr 20 08:10:25 max kernel: usb 2-2: pl2303 converter now attached to ttyUSB0
$ strace -o strace.gammu gammu --backup backup
Press Ctrl+C to break...
$ tail strace.gammu
ioctl(3, SNDCTL_TMR_TIMEBASE or TCGETS, {B0 -opost -isig -icanon -echo ...}) = 0
ioctl(3, SNDCTL_TMR_TIMEBASE or TCGETS, {B0 -opost -isig -icanon -echo ...}) = 0
ioctl(3, SNDCTL_TMR_START or TCSETS, {B0 -opost -isig -icanon -echo ...}) = 0
ioctl(3, SNDCTL_TMR_TIMEBASE or TCGETS, {B0 -opost -isig -icanon -echo ...}) = 0
ioctl(3, TIOCMBIC, [TIOCM_DTR])         = 0
ioctl(3, TIOCMBIC, [TIOCM_RTS])         = 0
ioctl(3, TIOCMGET, [0])                 = 0
nanosleep({1, 0}, 0)                    = ? ERESTART_RESTARTBLOCK (To be restarted)
--- SIGIO (I/O possible) @ 0 (0) ---
+++ killed by SIGIO +++
$ grep open strace.gammu 
open("/etc/ld.so.cache", O_RDONLY)      = 3
open("/usr/lib/libGammu.so.1", O_RDONLY) = 3
open("/lib/tls/libpthread.so.0", O_RDONLY) = 3
open("/usr/lib/libmysqlclient.so.15", O_RDONLY) = 3
open("/usr/lib/libbluetooth.so.2", O_RDONLY) = 3
open("/lib/tls/libc.so.6", O_RDONLY)    = 3
open("/lib/tls/libcrypt.so.1", O_RDONLY) = 3
open("/lib/tls/libnsl.so.1", O_RDONLY)  = 3
open("/lib/tls/libm.so.6", O_RDONLY)    = 3
open("/usr/lib/libz.so.1", O_RDONLY)    = 3
open("/home/erig/.gammurc", O_RDONLY)   = -1 ENOENT (No such file or directory)
open("/etc/gammurc", O_RDONLY)          = 3
open("/usr//gammu_c", O_RDONLY)         = -1 ENOENT (No such file or directory)
open("/usr//gammu_c", O_RDONLY)         = -1 ENOENT (No such file or directory)
open("/usr//gammu_c", O_RDONLY)         = -1 ENOENT (No such file or directory)
open("/dev/ttyUSB0", O_RDWR|O_NONBLOCK|O_NOCTTY) = 3
