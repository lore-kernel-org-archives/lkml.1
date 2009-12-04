Return-Path: <linux-kernel-owner+w=401wt.eu-S932104AbZLDNaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104AbZLDNaU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 08:30:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756034AbZLDNaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 08:30:19 -0500
Received: from mail-px0-f188.google.com ([209.85.216.188]:51369 "EHLO
	mail-px0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755604AbZLDNaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 08:30:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=vq424wypQ823yGFrjQhXQximLXGQl3D++Na51VtCZNYmxVG6mVjlEC5aYSpzSQLeBf
         5uU6sQbHVkGRXmmCQgx8qhFzAAuPoSlfx4BqhDZH2NeC0oyiW4/eOocakNDJExClZ+4y
         ihk3D3ngYAjqd3hUN5/4VzJ+mRQLt4jw7TetQ=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>, akpm@linux-foundation.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, zhangfx@lemote.com,
       Wu Zhangjin <wuzhangjin@gmail.com>
Subject: [PATCH v7 0/8] Loongson: YeeLoong: add platform specific driver
Date: Fri,  4 Dec 2009 21:30:09 +0800
Message-Id: <cover.1259932036.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

This patchset adds platform specific drivers for YeeLoong netbook. including
the backlight, battery, hwmon, video output, suspend and hotkey(input)
subdrivers. These drivers provide standard interfaces to the user-space
applications to manage the related devices:

	 Subdrivers                     Applicatioins.

        - backlight
          /sys/class/backlight/         kpowersave, gnome-power-manager
        - battery
          /proc/apm                     kpowersave, gnome-power-manager
        - hwmon
          /sys/class/hwmon/             lm-sensors, sensors-applet...
        - video output
          /sys/class/video_output       ?
        - hotkey
          /sys/class/input/             gnome-settings-daemon ?
        - platform(suspend) 
          /sys/power/state              kpowersave, gnome-power-manager

Changes from v6:

	- Move the whole stuff back to drivers/platform/mips/

	  It's very difficult to find a good place to put it in, so, just did
	  what the folks have done under drivers/platform/x86/

	- Rebase the hotkey driver on the sparse keymap library from Dmitry
	Torokhov.

	- Load this module automatically
	  Register a platform device, bind it with this module.

	- Fixup of battery subdriver
	  Ensure apm_get_power_status is NULL when exit.

Wu Zhangjin (8):
  MIPS: add subdirectory for platform extension drivers
  Loongson: YeeLoong: add platform driver
  Loongson: YeeLoong: add backlight driver
  Loongson: YeeLoong: add battery driver
  Loongson: YeeLoong: add hardware monitoring driver
  Loongson: YeeLoong: add video output driver
  Loongson: YeeLoong: add suspend support
  Loongson: YeeLoong: add input/hotkey driver

 arch/mips/include/asm/mach-loongson/ec_kb3310b.h |  191 ++++
 arch/mips/include/asm/mach-loongson/loongson.h   |    6 +
 arch/mips/loongson/common/cmdline.c              |    8 +
 arch/mips/loongson/lemote-2f/Makefile            |    2 +-
 arch/mips/loongson/lemote-2f/ec_kb3310b.c        |   12 +-
 arch/mips/loongson/lemote-2f/ec_kb3310b.h        |  188 ----
 arch/mips/loongson/lemote-2f/platform.c          |   40 +
 arch/mips/loongson/lemote-2f/pm.c                |    4 +-
 arch/mips/loongson/lemote-2f/reset.c             |    2 +-
 drivers/platform/Kconfig                         |    4 +
 drivers/platform/Makefile                        |    1 +
 drivers/platform/mips/Kconfig                    |   33 +
 drivers/platform/mips/Makefile                   |    5 +
 drivers/platform/mips/yeeloong_laptop.c          | 1067 ++++++++++++++++++++++
 14 files changed, 1363 insertions(+), 200 deletions(-)
 create mode 100644 arch/mips/include/asm/mach-loongson/ec_kb3310b.h
 delete mode 100644 arch/mips/loongson/lemote-2f/ec_kb3310b.h
 create mode 100644 arch/mips/loongson/lemote-2f/platform.c
 create mode 100644 drivers/platform/mips/Kconfig
 create mode 100644 drivers/platform/mips/Makefile
 create mode 100644 drivers/platform/mips/yeeloong_laptop.c

