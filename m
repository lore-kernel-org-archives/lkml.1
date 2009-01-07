Return-Path: <linux-kernel-owner+w=401wt.eu-S1760851AbZAGTWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760851AbZAGTWp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 14:22:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757923AbZAGTW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 14:22:28 -0500
Received: from mga05.intel.com ([192.55.52.89]:34602 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756078AbZAGTW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 14:22:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,339,1228118400"; 
   d="scan'208";a="655323905"
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
To: netdev@vger.kernel.org
Cc: wimax@linuxwimax.org, greg@kroah.com,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-wimax@intel.com
Subject: [PATCH 0/4] wimax: Kbuild / rfkill-build / PM fixes (v3)
Date: Wed,  7 Jan 2009 11:22:18 -0800
Message-Id: <cover.1231355768.git.inaky@linux.intel.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These four patches fix build issues reported by Randy Dunlap on the
linux-next tree for Jan 6 and Jan 7:

http://lkml.org/lkml/2009/1/6/340
http://lkml.org/lkml/2009/1/7/360

The issue fixed by patch #3 wasn't reported on the emails but was
uncovered while discussing the fixes.

This applies to the wimax tree kept in gregkh's repository:

http://kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-04-usb/

Changes in v3

- Add patch #4, wrapping access to power-saving members of the struct
  usb_device in #ifdef CONFIG_PM. 

Changes in v2

- fixed silly one-char typo #ifndef CONFIG_BUG vs #ifdef CONFIG_BUG
  reported by Ilpo Järvinen 

Inaky Perez-Gonzalez (4):
  wimax: fix '#ifndef CONFIG_BUG' layout to avoid warning
  wimax: fix kconfig interactions with rfkill and input layers
  wimax: testing for rfkill support should also test for
    CONFIG_RFKILL_MODULE
  i2400m/usb: wrap USB power saving in #ifdef CONFIG_PM

 drivers/net/wimax/i2400m/usb.c |    6 ++++++
 net/wimax/Kconfig              |   14 ++++++++++++++
 net/wimax/id-table.c           |    8 +++++---
 net/wimax/op-rfkill.c          |    2 +-
 4 files changed, 26 insertions(+), 4 deletions(-)

