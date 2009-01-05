Return-Path: <linux-kernel-owner+w=401wt.eu-S1752543AbZAEIj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbZAEIj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 03:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbZAEIjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 03:39:17 -0500
Received: from eazy.amigager.de ([213.239.192.238]:41224 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbZAEIjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 03:39:16 -0500
Date: Mon, 5 Jan 2009 09:39:11 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: 2.6.28 regression: xbacklight broken on ThinkPad X61s
Message-ID: <20090105083911.GA3694@x61>
Mail-Followup-To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

xbacklight is broken as of 2.6.28 on my ThinkPad X61s. It works with
2.6.27(.8) The difference I can see between both kernels is that 2.6.27
has 2 backlight ACPI devices, whereas 2.6.28 only has one device.  With
2.6.28, I can use xbacklight and see the values change in xbacklight
-get, but the actual display brightness doesn't change.

Attached are 2 files with diagnostic output from 2.6.27 and 2.6.28. Any
hints how to solve or debug this?

Regards,
Tino


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="backlight_2.6.27"

dmesg:

acpi device:03: registered as cooling_device2
input: Video Bus as /class/input/input8
ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
acpi device:08: registered as cooling_device3
input: Video Bus as /class/input/input9
ACPI: Video Device [VID1] (multi-head: yes  rom: no  post: no)

xrandr --prop:

Screen 0: minimum 320 x 200, current 1024 x 768, maximum 1024 x 1024
VGA disconnected (normal left inverted right x axis y axis)
LVDS connected 1024x768+0+0 (normal left inverted right x axis y axis) 246mm x 185mm
	EDID_DATA:
		00ffffffffffff0030ae004000000000
		000f010380191278eaed7591574f8b26
		21505421080001010101010101010101
		01010101010128150040410026301888
		3600f6b900000018ed10004041002630
		18883600f6b9000000180000000f0061
		43326143280f01004ca3584a000000fe
		004c544e313231584a2d4c30370a0000
	PANEL_FITTING: full
		supported: center       full_aspect  full        
	BACKLIGHT_CONTROL: kernel
		supported: native       legacy       combination  kernel      
	BACKLIGHT: 10 (0x0000000a) range:  (0,15)
   1024x768       50.0*+   60.0     40.0  
   800x600        60.3  
   640x480        60.0     59.9

Xorg log:

(II) intel(0): found backlight control method /sys/class/backlight/acpi_video1

sysfs:

/sys/class/backlight/acpi_video0/subsystem/acpi_video1/bl_power:0
/sys/class/backlight/acpi_video0/subsystem/acpi_video1/brightness:10
/sys/class/backlight/acpi_video0/subsystem/acpi_video1/actual_brightness:10
/sys/class/backlight/acpi_video0/subsystem/acpi_video1/max_brightness:15
/sys/class/backlight/acpi_video0/subsystem/acpi_video1/power/wakeup:
/sys/class/backlight/acpi_video0/bl_power:0
/sys/class/backlight/acpi_video0/brightness:9
/sys/class/backlight/acpi_video0/actual_brightness:12
/sys/class/backlight/acpi_video0/max_brightness:15
/sys/class/backlight/acpi_video0/power/wakeup:
/sys/class/backlight/acpi_video1/subsystem/acpi_video0/bl_power:0
/sys/class/backlight/acpi_video1/subsystem/acpi_video0/brightness:9
/sys/class/backlight/acpi_video1/subsystem/acpi_video0/actual_brightness:12
/sys/class/backlight/acpi_video1/subsystem/acpi_video0/max_brightness:15
/sys/class/backlight/acpi_video1/subsystem/acpi_video0/power/wakeup:
/sys/class/backlight/acpi_video1/bl_power:0
/sys/class/backlight/acpi_video1/brightness:10
/sys/class/backlight/acpi_video1/actual_brightness:10
/sys/class/backlight/acpi_video1/max_brightness:15
/sys/class/backlight/acpi_video1/power/wakeup:

--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="backlight_2.6.28"

dmesg:

acpi device:03: registered as cooling_device2
input: Video Bus as /class/input/input7
ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)

xrandr --prop:

Screen 0: minimum 320 x 200, current 1024 x 768, maximum 1024 x 1024
VGA disconnected (normal left inverted right x axis y axis)
LVDS connected 1024x768+0+0 (normal left inverted right x axis y axis) 246mm x 185mm
	EDID_DATA:
		00ffffffffffff0030ae004000000000
		000f010380191278eaed7591574f8b26
		21505421080001010101010101010101
		01010101010128150040410026301888
		3600f6b900000018ed10004041002630
		18883600f6b9000000180000000f0061
		43326143280f01004ca3584a000000fe
		004c544e313231584a2d4c30370a0000
	PANEL_FITTING: full
		supported: center       full_aspect  full        
	BACKLIGHT_CONTROL: kernel
		supported: native       legacy       combination  kernel      
	BACKLIGHT: 5 (0x00000005) range:  (0,15)
   1024x768       50.0*+   60.0     40.0  
   800x600        60.3  
   640x480        60.0     59.9

Xorg log:

(II) intel(0): found backlight control method /sys/class/backlight/acpi_video0

sysfs:

/sys/class/backlight/acpi_video0/actual_brightness:5
/sys/class/backlight/acpi_video0/bl_power:0
/sys/class/backlight/acpi_video0/brightness:5
/sys/class/backlight/acpi_video0/max_brightness:15
/sys/class/backlight/acpi_video0/power/wakeup:
/sys/class/backlight/acpi_video0/subsystem/acpi_video0/bl_power:0
/sys/class/backlight/acpi_video0/subsystem/acpi_video0/brightness:5
/sys/class/backlight/acpi_video0/subsystem/acpi_video0/actual_brightness:5
/sys/class/backlight/acpi_video0/subsystem/acpi_video0/max_brightness:15
/sys/class/backlight/acpi_video0/subsystem/acpi_video0/power/wakeup:

--EVF5PPMfhYS0aIcm--
