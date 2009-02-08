Return-Path: <linux-kernel-owner+w=401wt.eu-S1753788AbZBHTmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbZBHTmv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 14:42:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbZBHTmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 14:42:42 -0500
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:32118 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753063AbZBHTmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 14:42:40 -0500
X-Trace: 145578954/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.44.176.198/None/adrian@newgolddream.dyndns.info
X-SBRS: None
X-RemoteIP: 80.44.176.198
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-MUA: Evolution 2.24.3 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsoEAJPEjklQLLDG/2dsb2JhbACBbspjhBoG
X-IronPort-AV: E=Sophos;i="4.37,400,1231113600"; 
   d="scan'208";a="145578954"
Subject: [PATCH] sh: maple: add support for Visual Memory Card devices, and
 make consequential changes to maple input drivers - 0/3 - v5
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: paul mundt <lethal@users.sourceforge.net>, Greg KH <greg@kroah.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       dwmw2 <dwmw2@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, MTD <linux-mtd@lists.infradead.org>,
       linux-sh <linux-sh@vger.kernel.org>,
       linux-input <linux-input@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 08 Feb 2009 19:41:09 +0000
Message-Id: <1234122069.6736.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches adds support for the Dreamcast Visual Memory
Unit, reworking the maple bus code to ensure it supports asynchronous
reads and writes. A consequential amendment to the keyboard and joystick
drivers are also included.

This version (v5) fixes a memory leak in the VMU code that was present
when read or write requests timed out in v4. It also adds the joystick
fix.

The VMU is a 'smart' flash chip where access is controlled by a
microcontroller so that, for instance, flash erases appear to be
transparent to the end user. The VMU does, however, show typical
flash-type behaviour (eg phased writes) and the MTD layer and the chip
work well together (eg in the way they handle apparent hotplug events
during a block write).

This version tidies up some style issues raised with version 2.

Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
---
 drivers/input/joystick/maplecontrol.c |    4 +-
 drivers/input/keyboard/maple_keyb.c   |   40 +-
 drivers/mtd/maps/Kconfig              |   12 +-
 drivers/mtd/maps/Makefile             |    1 +
 drivers/mtd/maps/vmu-flash.c          |  827 +++++++++++++++++++++++++++++++++
 drivers/sh/maple/maple.c              |  463 ++++++++++---------
 include/linux/maple.h                 |   62 ++-
 7 files changed, 1142 insertions(+), 267 deletions(-)


