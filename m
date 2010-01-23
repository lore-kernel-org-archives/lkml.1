Return-Path: <linux-kernel-owner+w=401wt.eu-S1752557Ab0AWUmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab0AWUmg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 15:42:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996Ab0AWUmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 15:42:13 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50493 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab0AWUfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 15:35:52 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Peter Jones <pjones@redhat.com>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Jaya Kumar <jayakumar.lkml@gmail.com>,
       Ralf Baechle <ralf@linux-mips.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       Huang Ying <ying.huang@intel.com>
Subject: [PATCH 07/29] move efifb's probe function to .devinit.text
Date: Sat, 23 Jan 2010 21:35:15 +0100
Message-Id: <1264278937-19675-7-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264189758-7197-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1264189758-7197-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A pointer to efifb_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Peter Jones <pjones@redhat.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Chandramouli Narayanan <mouli@linux.intel.com>
Cc: Huang Ying <ying.huang@intel.com>
---
 drivers/video/efifb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/efifb.c b/drivers/video/efifb.c
index eb12182..2161f21 100644
--- a/drivers/video/efifb.c
+++ b/drivers/video/efifb.c
@@ -201,7 +201,7 @@ static int __init efifb_setup(char *options)
 	return 0;
 }
 
-static int __init efifb_probe(struct platform_device *dev)
+static int __devinit efifb_probe(struct platform_device *dev)
 {
 	struct fb_info *info;
 	int err;
-- 
1.6.6

