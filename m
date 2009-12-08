Return-Path: <linux-kernel-owner+w=401wt.eu-S1755350AbZLHOQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbZLHOQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 09:16:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755233AbZLHOQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 09:16:04 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:61371 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074AbZLHOQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 09:16:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=vdu3NIsYFZZM4gqcYXUT/34fM+5JAwd/BJ+3ipN7ZTMDajrTuQESm9GmxC5PcEf09w
         QVGoZZ8wnsIkjz86nnZ2i5xIzsRGNjjVbD5yTCuwRvy4JoVFszB4QTmzqoQls2Byi4Dp
         B9eoXEZQquPlyPm+Lx92g6QSNOJNMaMiPTlYA=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: akpm@linux-foundation.org, Wu Zhangjin <wuzhangjin@gmail.com>,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "Rafael J . Wysocki" <rjw@sisk.pl>, zhangfx@lemote.com,
       linux-laptop@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH v9 0/8] Loongson: YeeLoong: add platform drivers
Date: Tue,  8 Dec 2009 22:15:48 +0800
Message-Id: <cover.1260254344.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

Hi, Ralf and Andrew Morton

Could you please queue this patchset for 2.6.33?

Of course, any new feedbacks are welcome, thanks!

Best Regards,
        Wu Zhangjin

------------------

This patchset adds platform specific drivers for YeeLoong netbook. including
the backlight, battery, hwmon, video output, suspend and hotkey(input)
subdrivers. These drivers provide standard interfaces to the user-space
applications to manage the related devices.

Changes from v8:

  o Cleanup of the get_battery_current()

  We need to return the signed value directly for the current flowing
  into and from the battery are totally different, and since the other
  platforms use value>0 indicates the discharge, so, we return -value
  here. (Thanks to Pavel Machek for giving this feedback!)

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
 drivers/platform/mips/yeeloong_laptop.c          | 1035 ++++++++++++++++++++++
 14 files changed, 1331 insertions(+), 200 deletions(-)
 create mode 100644 arch/mips/include/asm/mach-loongson/ec_kb3310b.h
 delete mode 100644 arch/mips/loongson/lemote-2f/ec_kb3310b.h
 create mode 100644 arch/mips/loongson/lemote-2f/platform.c
 create mode 100644 drivers/platform/mips/Kconfig
 create mode 100644 drivers/platform/mips/Makefile
 create mode 100644 drivers/platform/mips/yeeloong_laptop.c

