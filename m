Return-Path: <linux-kernel-owner+w=401wt.eu-S1754306Ab0AEN6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab0AEN6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 08:58:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754076Ab0AEN57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 08:57:59 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60525 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753754Ab0AEN56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 08:57:58 -0500
Date: Tue, 5 Jan 2010 13:57:56 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
       rtc-linux@googlegroups.com
Subject: [PATCH 0/4] Convert WM8350 to genirq
Message-ID: <20100105135756.GA2993@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch series converts the WM8350 driver to use genirq for
the interrupt controller on the chip.  It also includes a patch for the
RTC driver to handle the fact that genirq nests enables and disables.
Ideally this patch would go in via the MFD tree to avoid merge issues.

Since this collides with (and removes the need for) Dan Carpenter's
bounds checking change I've also included that in the series.

Dan Carpenter (1):
      mfd: WM8350 off by one bug

Mark Brown (3):
      mfd: Add a data argument to the WM8350 IRQ free function
      rtc: Suppress duplicate enable/disable of WM8350 update interrupt
      mfd: Convert WM8350 to genirq

 drivers/mfd/wm8350-irq.c             |  155 +++++++++++++++++++---------------
 drivers/power/wm8350_power.c         |   24 +++---
 drivers/regulator/wm8350-regulator.c |    2 +-
 drivers/rtc/rtc-wm8350.c             |   11 ++-
 include/linux/mfd/wm8350/core.h      |   45 +++++++---
 include/linux/mfd/wm8350/rtc.h       |    1 +
 sound/soc/codecs/wm8350.c            |    4 +-
 7 files changed, 144 insertions(+), 98 deletions(-)
