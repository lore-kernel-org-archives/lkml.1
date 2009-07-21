Return-Path: <linux-kernel-owner+w=401wt.eu-S1751526AbZGUEfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526AbZGUEfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 00:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751342AbZGUEfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 00:35:22 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4944 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbZGUEfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 00:35:16 -0400
From: Joe Perches <joe@perches.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org, Mike Rapoport <mike@compulab.co.il>,
       Denis Turischev <denis@compulab.co.il>,
       Andrey Panin <pazke@centrinvest.ru>
Subject: [PATCH 0/3] drivers/watchdog: Use pr_<level>
Date: Mon, 20 Jul 2009 21:34:59 -0700
Message-Id: <cover.1248148947.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <4A6492EB.1080709@compulab.co.il>
References: <4A6492EB.1080709@compulab.co.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Given I suggested that the new sbc_fitpc2 should use
pr_<level> and not printk, I converted the other files

This is a rolled up patch for all the watchdog timer
drivers.  If a patch for each driver is desired instead,
(which might be sensible given the breakage I introduced
in cleaning up printks with multiple KERN_<levels> in commit
ad361c9884e809340f6daca80d56a9e9c871690a) just ask.

Compiled x86/32 only with allyesconfig and
x86/32 allyesconfig with CONFIG_DYNAMIC_DEBUG=n

Joe Perches (3):
  include/linux: kernel.h dynamic_debug.h device.h - Use section fmts
  drivers/watchdog: Convert printk(KERN_<level> to pr_<level>(
  drivers/watchdog: use pr_fmt

 drivers/watchdog/acquirewdt.c          |   24 ++++------
 drivers/watchdog/advantechwdt.c        |   29 +++++-------
 drivers/watchdog/alim1535_wdt.c        |   22 ++++-----
 drivers/watchdog/alim7101_wdt.c        |   50 ++++++++------------
 drivers/watchdog/ar7_wdt.c             |   27 +++++------
 drivers/watchdog/at91rm9200_wdt.c      |    4 +-
 drivers/watchdog/at91sam9_wdt.c        |    8 ++-
 drivers/watchdog/bcm47xx_wdt.c         |   14 +++---
 drivers/watchdog/bfin_wdt.c            |   34 ++++++--------
 drivers/watchdog/booke_wdt.c           |   18 ++++----
 drivers/watchdog/cpu5wdt.c             |   14 +++---
 drivers/watchdog/cpwd.c                |   20 ++++----
 drivers/watchdog/ep93xx_wdt.c          |   12 ++---
 drivers/watchdog/eurotechwdt.c         |   26 +++++-----
 drivers/watchdog/gef_wdt.c             |   11 +++--
 drivers/watchdog/geodewdt.c            |    5 +-
 drivers/watchdog/hpwdt.c               |   22 ++++-----
 drivers/watchdog/i6300esb.c            |   34 ++++++--------
 drivers/watchdog/iTCO_vendor_support.c |    7 +--
 drivers/watchdog/iTCO_wdt.c            |   52 +++++++++------------
 drivers/watchdog/ib700wdt.c            |   22 ++++-----
 drivers/watchdog/ibmasr.c              |   14 +++---
 drivers/watchdog/indydog.c             |   23 +++++-----
 drivers/watchdog/iop_wdt.c             |   11 +++--
 drivers/watchdog/it8712f_wdt.c         |   26 +++++-----
 drivers/watchdog/it87_wdt.c            |   39 +++++++---------
 drivers/watchdog/ixp2000_wdt.c         |    7 ++-
 drivers/watchdog/ixp4xx_wdt.c          |   12 ++---
 drivers/watchdog/ks8695_wdt.c          |   10 +++--
 drivers/watchdog/machzwd.c             |   33 ++++++-------
 drivers/watchdog/mixcomwd.c            |   25 ++++-------
 drivers/watchdog/mpcore_wdt.c          |   16 ++++---
 drivers/watchdog/mtx-1_wdt.c           |    6 ++-
 drivers/watchdog/mv64x60_wdt.c         |   11 +++--
 drivers/watchdog/omap_wdt.c            |    4 +-
 drivers/watchdog/orion_wdt.c           |   12 +++--
 drivers/watchdog/pc87413_wdt.c         |   57 +++++++++++-------------
 drivers/watchdog/pcwd.c                |   77 ++++++++++++++------------------
 drivers/watchdog/pcwd_pci.c            |   72 +++++++++++++++--------------
 drivers/watchdog/pcwd_usb.c            |   67 ++++++++++++---------------
 drivers/watchdog/pika_wdt.c            |   19 ++++----
 drivers/watchdog/pnx4008_wdt.c         |   20 +++++----
 drivers/watchdog/pnx833x_wdt.c         |   28 ++++++------
 drivers/watchdog/rc32434_wdt.c         |   36 +++++++-------
 drivers/watchdog/rdc321x_wdt.c         |    7 ++-
 drivers/watchdog/riowd.c               |   11 +++--
 drivers/watchdog/rm9k_wdt.c            |   16 +++----
 drivers/watchdog/s3c2410_wdt.c         |   10 ++--
 drivers/watchdog/sa1100_wdt.c          |   10 +++--
 drivers/watchdog/sb_wdog.c             |   27 +++++------
 drivers/watchdog/sbc60xxwdt.c          |   40 +++++++----------
 drivers/watchdog/sbc7240_wdt.c         |   40 ++++++----------
 drivers/watchdog/sbc8360.c             |   21 ++++-----
 drivers/watchdog/sbc_epx_c3.c          |   23 +++++-----
 drivers/watchdog/sc1200wdt.c           |   34 +++++++-------
 drivers/watchdog/sc520_wdt.c           |   35 ++++++---------
 drivers/watchdog/sch311x_wdt.c         |   12 +++---
 drivers/watchdog/scx200_wdt.c          |   23 +++++-----
 drivers/watchdog/shwdt.c               |   34 ++++++--------
 drivers/watchdog/smsc37b787_wdt.c      |   38 +++++++---------
 drivers/watchdog/softdog.c             |   37 +++++++--------
 drivers/watchdog/stmp3xxx_wdt.c        |    6 ++-
 drivers/watchdog/txx9wdt.c             |   12 +++--
 drivers/watchdog/w83627hf_wdt.c        |   34 ++++++--------
 drivers/watchdog/w83697hf_wdt.c        |   41 +++++++---------
 drivers/watchdog/w83697ug_wdt.c        |   30 +++++-------
 drivers/watchdog/w83877f_wdt.c         |   38 ++++++---------
 drivers/watchdog/w83977f_wdt.c         |   33 ++++++--------
 drivers/watchdog/wafer5823wdt.c        |   32 +++++--------
 drivers/watchdog/wdrtas.c              |   65 ++++++++++----------------
 drivers/watchdog/wdt.c                 |   50 ++++++++++-----------
 drivers/watchdog/wdt285.c              |   12 +++---
 drivers/watchdog/wdt977.c              |   35 ++++++--------
 drivers/watchdog/wdt_pci.c             |   64 ++++++++++++--------------
 include/linux/device.h                 |    4 ++
 include/linux/dynamic_debug.h          |   34 +++++++++++++-
 include/linux/kernel.h                 |   51 +++++++++++++++++++++
 77 files changed, 981 insertions(+), 1058 deletions(-)

