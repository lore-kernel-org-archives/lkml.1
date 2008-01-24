Return-Path: <linux-kernel-owner+w=401wt.eu-S1753050AbYAXOeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050AbYAXOeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 09:34:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbYAXOdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 09:33:52 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:60460 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751823AbYAXOdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 09:33:51 -0500
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Brownell <david-b@pacbell.net>, Andrew Victor <linux@maxim.org.za>,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       Patrice Vilchez <patrice.vilchez@rfo.atmel.com>,
       Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
       kernel@avr32linux.org
Subject: [PATCH -mm 0/2] AVR32 PWM driver and example user
Date: Thu, 24 Jan 2008 15:33:43 +0100
Message-Id: <1201185225-15789-1-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two patches from David Brownell follow. The first one implements a
low-level driver/library for the PWM controller integrated on some
newer AVR32- and ARM-based chips from Atmel. The second one uses this
library to implement a LED driver with variable brightness.

There's currently no user of this LED driver, but it can be tested on
the ATSTK1000 by following the instructions here:

http://avr32linux.org/twiki/bin/view/Main/AtmelPwmDriver

Also, PWM functionality in the kernel has been requested by several
AVR32 users with custom boards (which we hopefully will see support
for in mainline later), and some AT91-based boards may be able to use
the PWM LED driver by default given some suitable platform- and board
code (David mentioned AT91SAM9263EK.) I'd appreciate some feedback
from AT91 people about this.

David Brownell (2):
      Basic PWM driver for AVR32 and AT91
      PWM LED driver

 arch/avr32/mach-at32ap/at32ap700x.c   |   54 +++++
 drivers/leds/Kconfig                  |    7 +
 drivers/leds/Makefile                 |    1 +
 drivers/leds/leds-atmel-pwm.c         |  157 +++++++++++++
 drivers/misc/Kconfig                  |    9 +
 drivers/misc/Makefile                 |    1 +
 drivers/misc/atmel_pwm.c              |  409 +++++++++++++++++++++++++++++++++
 include/asm-avr32/arch-at32ap/board.h |    3 +
 include/linux/atmel_pwm.h             |   70 ++++++
 9 files changed, 711 insertions(+), 0 deletions(-)
 create mode 100644 drivers/leds/leds-atmel-pwm.c
 create mode 100644 drivers/misc/atmel_pwm.c
 create mode 100644 include/linux/atmel_pwm.h
