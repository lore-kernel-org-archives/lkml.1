Return-Path: <linux-kernel-owner+w=401wt.eu-S1755196AbZGKU4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbZGKU4N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 16:56:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756052AbZGKUx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 16:53:56 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:32847 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563AbZGKUxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 16:53:50 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Antonino Daplas <adaplas@pol.net>,
       linux-fbdev-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] move acornfb's probe function to .devinit.text
Date: Sat, 11 Jul 2009 22:52:29 +0200
Message-Id: <1247345591-22643-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090711170548.GC5205@suse.de>
References: <20090711170548.GC5205@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A pointer to acornfb_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Antonino Daplas <adaplas@pol.net>
Cc: linux-fbdev-devel@lists.sourceforge.net
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/video/acornfb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/acornfb.c b/drivers/video/acornfb.c
index 0bcc59e..43d7d50 100644
--- a/drivers/video/acornfb.c
+++ b/drivers/video/acornfb.c
@@ -1221,7 +1221,7 @@ free_unused_pages(unsigned int virtual_start, unsigned int virtual_end)
 	printk("acornfb: freed %dK memory\n", mb_freed);
 }
 
-static int __init acornfb_probe(struct platform_device *dev)
+static int __devinit acornfb_probe(struct platform_device *dev)
 {
 	unsigned long size;
 	u_int h_sync, v_sync;
-- 
1.6.3.1

