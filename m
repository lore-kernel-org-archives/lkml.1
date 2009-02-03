Return-Path: <linux-kernel-owner+w=401wt.eu-S1754239AbZBCOc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239AbZBCOc0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 09:32:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbZBCOcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 09:32:17 -0500
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:28572 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752418AbZBCOcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 09:32:15 -0500
X-Trace: 141657226/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.44.176.198/None/adrian@newgolddream.dyndns.info
X-SBRS: None
X-RemoteIP: 80.44.176.198
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-MUA: Evolution 2.24.3 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArEEAP7jh0lQLLDG/2dsb2JhbACBbs00hBQG
X-IronPort-AV: E=Sophos;i="4.37,372,1231113600"; 
   d="scan'208";a="141657226"
Subject: [PATCH] sh: maple: Add support for VMU devices (v3) [0/3]
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: greg KH <greg@kroah.com>, Paul Mundt <lethal@linux-sh.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       dwmw2 <dwmw2@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, MTD <linux-mtd@lists.infradead.org>,
       linux-sh <linux-sh@vger.kernel.org>,
       linux-input <linux-input@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 14:31:26 +0000
Message-Id: <1233671486.6512.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches adds support for the Dreamcast Visual Memory
Unit, reworking the maple bus code to ensure it supports asynchronous
reads and writes. A consequential amendment to the keyboard driver is
also included.

The VMU is a 'smart' flash chip where access is controlled by a
microcontroller so that, for instance, flash erases appear to be
transparent to the end user. The VMU does, however, show typical
flash-type behaviour (eg phased writes) and the MTD layer and the chip
work well together (eg in the way they handle apparent hotplug events
during a block write).

This version tidies up some style issues raised with version 2.

Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
---
 drivers/input/keyboard/maple_keyb.c |   40 +-
 drivers/mtd/maps/Kconfig            |   12 +-
 drivers/mtd/maps/Makefile           |    1 +
 drivers/mtd/maps/vmu-flash.c        |  826 +++++++++++++++++++++++++++++++++++
 drivers/sh/maple/maple.c            |  463 ++++++++++----------
 include/linux/maple.h               |   62 ++-
 6 files changed, 1139 insertions(+), 265 deletions(-)

