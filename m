Return-Path: <linux-kernel-owner+w=401wt.eu-S934142AbZKXVJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934142AbZKXVJ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:09:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934094AbZKXVIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:08:51 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44754 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934052AbZKXVIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:08:43 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
       "James E.J. Bottomley" <James.Bottomley@suse.de>,
       Yang Hongyang <yanghy@cn.fujitsu.com>, Kyle McMartin <kyle@mcmartin.ca>,
       Kay Sievers <kay.sievers@vrfy.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 07/38] move lasi700_driver_remove to .devexit.text
Date: Tue, 24 Nov 2009 22:07:02 +0100
Message-Id: <1259096853-18909-7-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1259096853-18909-6-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1259096853-18909-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-2-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-3-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-4-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-5-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-6-git-send-email-u.kleine-koenig@pengutronix.de>
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

The function lasi700_driver_remove is used only wrapped by __devexit_p
so define it using __devexit.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
Cc: Yang Hongyang <yanghy@cn.fujitsu.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Helge Deller <deller@gmx.de>
---
 drivers/scsi/lasi700.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/lasi700.c b/drivers/scsi/lasi700.c
index b3d3131..a192914 100644
--- a/drivers/scsi/lasi700.c
+++ b/drivers/scsi/lasi700.c
@@ -147,7 +147,7 @@ lasi700_probe(struct parisc_device *dev)
 	return -ENODEV;
 }
 
-static int __exit
+static int __devexit
 lasi700_driver_remove(struct parisc_device *dev)
 {
 	struct Scsi_Host *host = dev_get_drvdata(&dev->dev);
-- 
1.6.5.2

