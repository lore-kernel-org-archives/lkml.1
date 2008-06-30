Return-Path: <linux-kernel-owner+w=401wt.eu-S1759619AbYF3JWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759619AbYF3JWZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 05:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754715AbYF3JWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 05:22:07 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:62536 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754729AbYF3JWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 05:22:06 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: kernel@avr32linux.org
Cc: linux-kernel@vger.kernel.org, Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH 0/8] Power management support for AVR32 AP7000
Date: Mon, 30 Jun 2008 11:21:08 +0200
Message-Id: <1214817676-30378-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.5.4
X-OriginalArrivalTime: 30 Jun 2008 09:21:07.0508 (UTC) FILETIME=[A0A18740:01C8DA92]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haavard Skinnemoen <hskinnemoen@atmel.com>

The following series fixes a few drivers in order to make power
management behave more nicely on AVR32. It then goes on to implement
support for the "standby" and "mem" suspend modes on the AT32AP7000.

If it's ok with everyone, I'll merge all the bits that don't get
picked up by someone else for 2.6.27.

The patches are meant to go on top of the avr32-arch branch of

git://git.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/avr32-2.6.git

but they should apply nicely to the -next and -mm trees too.

Haavard Skinnemoen (8):
      atmel_serial: Fix build on avr32 with CONFIG_PM enabled
      atmel_serial: Drain console TX shifter before suspending
      macb: Basic suspend/resume support
      rtc-at32ap700x: Enable wakeup
      avr32: Enable SDRAMC clock at startup
      avr32: Add simple SRAM allocator
      avr32: Add system device for the internal interrupt controller (intc)
      avr32: Power Management support ("standby" and "mem" modes)

 arch/avr32/Kconfig                     |    6 +
 arch/avr32/mach-at32ap/Makefile        |    5 +
 arch/avr32/mach-at32ap/at32ap700x.c    |   35 +++++
 arch/avr32/mach-at32ap/intc.c          |   80 ++++++++++-
 arch/avr32/mach-at32ap/pm-at32ap700x.S |  108 ++++++++++++++
 arch/avr32/mach-at32ap/pm.c            |  245 ++++++++++++++++++++++++++++++++
 arch/avr32/mach-at32ap/sdramc.h        |   76 ++++++++++
 drivers/net/macb.c                     |   37 +++++
 drivers/rtc/rtc-at32ap700x.c           |    3 +
 drivers/serial/atmel_serial.c          |   17 ++-
 include/asm-avr32/arch-at32ap/pm.h     |    3 +
 include/asm-avr32/arch-at32ap/sram.h   |   30 ++++
 include/asm-avr32/thread_info.h        |    1 +
 13 files changed, 642 insertions(+), 4 deletions(-)
 create mode 100644 arch/avr32/mach-at32ap/pm.c
 create mode 100644 arch/avr32/mach-at32ap/sdramc.h
 create mode 100644 include/asm-avr32/arch-at32ap/sram.h

Haavard
