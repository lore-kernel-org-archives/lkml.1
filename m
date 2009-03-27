Return-Path: <linux-kernel-owner+w=401wt.eu-S1764247AbZC0XkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764247AbZC0XkP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 19:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761767AbZC0X2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 19:28:00 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48503 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761558AbZC0X1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 19:27:42 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 50/58] move snirm_53c710's probe function to .devinit.text
Date: Sat, 28 Mar 2009 00:27:11 +0100
Message-Id: <1238196439-16535-50-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090327232153.GA16348@pengutronix.de>
References: <20090327232153.GA16348@pengutronix.de>
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

A pointer to snirm710_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---
 drivers/scsi/sni_53c710.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sni_53c710.c b/drivers/scsi/sni_53c710.c
index 77f0b2c..9d22539 100644
--- a/drivers/scsi/sni_53c710.c
+++ b/drivers/scsi/sni_53c710.c
@@ -64,7 +64,7 @@ static struct scsi_host_template snirm710_template = {
 	.module		= THIS_MODULE,
 };
 
-static int __init snirm710_probe(struct platform_device *dev)
+static int __devinit snirm710_probe(struct platform_device *dev)
 {
 	unsigned long base;
 	struct NCR_700_Host_Parameters *hostdata;
-- 
1.6.2

