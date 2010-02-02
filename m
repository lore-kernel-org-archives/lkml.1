Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab0BBHrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 02:47:17 -0500
Received: from iksaif.net ([88.191.73.63]:48719 "EHLO iksaif.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755550Ab0BBHrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 02:47:08 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Corentin Chary <corentincj@iksaif.net>
Subject: [PATCH 00/28] acpi4asus: asus-laptop rewrite for 2.6.33
Date: Tue,  2 Feb 2010 08:38:43 +0100
Message-Id: <1265096351-15239-1-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,
Here is a big series of patchs, only for asus-laptop.

It cleans asus-laptop like Alan Jenkins did for eeepc-laptop: no
more global context, and the driver *could* support multiple
acpi device (that will never happen, but it's not a reason to do
ugly code).

This has some side effects: bugs where the device path was \SB.HOTK
instead of \SB.ATKD are fixed, because a static path is no more used :).

It also adds some features like an rfkill handler for the gps, rewrite
the input code to use sparse_keymap library and add new backlight notifications.

The last patch is a checkpatch-cleanup.

Thanks,

Corentin Chary (28):
  asus-laptop: add wireless and bluetooth status parameter
  asus-laptop: set the right paths in the documentation
  asus-laptop: no need to check argument of set_brightness()
  asus-laptop: simplify write_acpi_int
  asus-laptop: use tabs to indent macros and remove unused ones
  asus-laptop: remove unecessary hotk != NULL check
  asus-laptop: change initialization order
  asus-laptop: revise names
  asus-laptop: move backlight and dsdt info inside asus_laptop struct
  asus-laptop: callbacks should use "driver data" parameter or field
  asus-laptop: code movement
  asus-laptop: stop using read_status for bluetooth and wlan
  asus-laptop: stop using read_status and store_status for GPS
  asus-laptop: stop using read_status for lcd
  asus-laptop: removing read_status/store_status/write_status and
    asus->status
  asus-laptop: rename function talking directly to acpi with asus_xxx
    scheme
  asus-laptop: stop using ASUS_HANDLE and use relative methods instead
  asus-laptop: add error check for write_acpi_int calls
  asus-laptop: rename wireless_status to wlan_status to avoid confusion
  asus-laptop: switch to sparse keymap library
  asus-laptop: add bluetooth keys found on M9V
  asus-laptop: add backlight changes notifications
  asus-laptop: leds, remove dead code and fix
    asus_led_exit()/asus_led_init()
  asus-laptop: set initial lcd state
  asus-laptop: add gps rfkill
  asus-laptop: clean led code
  asus-laptop: use device_create_file() instead of platform_group
  asus-laptop: fix style problems reported by checkpath.pl

 .../ABI/testing/sysfs-platform-asus-laptop         |   12 +-
 drivers/platform/x86/Kconfig                       |    2 +
 drivers/platform/x86/asus-laptop.c                 | 1741 ++++++++++----------
 3 files changed, 914 insertions(+), 841 deletions(-)

