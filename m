Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbZFXJcC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbZFXJcC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 05:32:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbZFXJbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 05:31:52 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:50174 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbZFXJbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 05:31:50 -0400
X-Greylist: delayed 311 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Jun 2009 05:31:50 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=VXQZGQTfH+3Xhyl6G4LpkRxu376gZWV17Lh9TsbfEFxyKXj+51lCqr1jcm7zR24TNc
         iHsxDHIDTvqQ+Jq/AtozcMSt47XUekgMZMzQpw0/zPVd9DWJK4Z5kUqr0BOIfccBVpjx
         wT6ptwYzd9oxJj1zwGY/Aq1FYvgIrTZyXZFfg=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, pavel@ucw.cz, hskinnemoen@atmel.com, anemo@mba.ocn.ne.jp,
       linux-usb@vger.kernel.org, akpm@linux-foundation.org, rjw@sisk.pl,
       stern@rowland.harvard.edu, ben-linux@fluff.org,
       Magnus Damm <magnus.damm@gmail.com>, linux-omap@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, felipe.balbi@nokia.com
Date: Wed, 24 Jun 2009 18:23:06 +0900
Message-Id: <20090624092306.14276.127.sendpatchset@rx1.opensource.se>
Subject: [PATCH 00/07] pm: remove late/early platform driver pm callbacks V2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pm: remove late/early platform driver pm callbacks V2

[PATCH 01/07] arm: rework omap suspend_late()/resume_early()
[PATCH 02/07] dma: rework dw_dmac suspend_late()/resume_early()
[PATCH 03/07] dma: rework txx9dmac suspend_late()/resume_early()
[PATCH 04/07] i2c: rework i2c-pxa suspend_late()/resume_early()
[PATCH 05/07] i2c: rework i2c-s3c2410 suspend_late()/resume() V2
[PATCH 06/07] usb: rework musb suspend()/resume_early()
[PATCH 07/07] pm: remove platform device suspend_late()/resume_early() V2

These patches simply remove ->suspend_late() and ->resume_early()
from struct platform_driver. Drivers are converted to dev_pm_ops
with CONFIG_SUSPEND in mind. Untested.

All patches except [02/07] are known to compile.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 Changes since V1:
 - resolved conflicts in [05/07], rediffed [07/07]
 - include lkml, linux-usb and akpm

 arch/arm/plat-omap/debug-leds.c  |   11 +++++++----
 arch/arm/plat-omap/gpio.c        |   14 ++++++++++----
 drivers/base/platform.c          |   36 ------------------------------------
 drivers/dma/dw_dmac.c            |   15 ++++++++++-----
 drivers/dma/txx9dmac.c           |   15 ++++++++++-----
 drivers/i2c/busses/i2c-pxa.c     |   25 +++++++++++++++++--------
 drivers/i2c/busses/i2c-s3c2410.c |   25 ++++++++++++++++---------
 drivers/usb/musb/musb_core.c     |   18 ++++++++++++------
 include/linux/platform_device.h  |    2 --
 9 files changed, 82 insertions(+), 79 deletions(-)
