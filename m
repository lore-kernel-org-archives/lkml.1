Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbXL2EEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbXL2EEu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 23:04:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153AbXL2EEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 23:04:37 -0500
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:21901 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754059AbXL2EEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 23:04:36 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=XfVjSLKSIgBX6uQ+OnOpuoB/NSovpRUJdcAaze12bH/qGa/svDne47kt0CGbqssFjtRpkGHjSum3KznV2Z3vQzBvEohFJeuGq9HgO91vJQG8AQtVE8nZkn2+a3Nl893vaBAqfQ9d1woS4B4vcXyUddxIUmugVB+e+ldcl+mjLzA=  ;
X-YMail-OSG: WpFXZUgVM1nvI5wTamkqKgz.wKpdqC0VSarybNADqBxOFuTqkYU5T7jmA7V2qMheZcQalVcHVg--
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.24-rc6-mm 0/9] updated gpiolib patchset
Date: Fri, 28 Dec 2007 19:52:47 -0800
User-Agent: KMail/1.9.6
Cc: Jean Delvare <khali@linux-fr.org>, eric miao <eric.y.miao@gmail.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200712281952.48364.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is intended to replace the ones currently in the MM tree:

	generic-gpio-gpio_chip-support.patch
	generic-gpio-gpio_chip-support-fix.patch
	generic-gpio-gpio_chip-support-gpiolib-locking-simplified.patch
	avr32-uses-gpio_chip.patch
	mcp23s08-spi-gpio-expander.patch
	mcp23s08-spi-gpio-expander-checkpatch-fixes.patch
	arm-pxa-gpiolib-support.patch
	arm-pxa-gpiolib-support-make-pxa_gpio_chip-static.patch

Changes since the version in mm include:  merging the various fixlets;
adding drivers for two I2C based GPIO expanders; and (the main reason
for replacement patches vs incremental ones) moving all non-platform
code into the new drivers/gpio directory.  Also, it now uses a new
internal "struct gpio_desc" abstraction -- somewhat visible to the
GPIO providers since ARCH_GPIOS_PER_CHIP is now gone.  All those
changes were posted previously.

Patches in this set are:

	- Add empty drivers/gpio directory and kconfig/kbuild support.
          Before this kicks in, platform support is needed.

	- Core gpiolib support.  Merges various updates as previously
	  discussed, notably simpler locking, the gpio_desc stuff (from
	  Eric Miao); and moving this from "lib" to "drivers/gpio".

	- Documentation/gpio.txt updates.

	- AVR32 platform support (at32ap)

	- PXA platform support (from Philipp Zabel, essentially unchanged)

	- PCF 857x I2C GPIO expander support ... a pretty widely used
	  family of "quasi-bidirectional" GPIOs (8 or 16 bits, many speeds)

	- MCP 23S08 SPI GPIO expander support ... with more traditional
	  push/pull outputs and hi-Z inputs

	- PCA 9539 I2C GPIO expander support ... a sixteen bit expander
	  using push/pull outputs etc (from Eric Miao)

	- Deprecate the older (unused) PCA9539 driver (from Eric Miao)

