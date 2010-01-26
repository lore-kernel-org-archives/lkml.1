Return-Path: <linux-kernel-owner+w=401wt.eu-S1752434Ab0AZIfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab0AZIfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 03:35:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244Ab0AZIfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 03:35:10 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54823 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215Ab0AZIfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 03:35:09 -0500
Date: Tue, 26 Jan 2010 09:35:00 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Eric Miao <eric.y.miao@gmail.com>,
       Vikram Dhillon <opensolarisdev@gmail.com>,
       linux-arm-kernel@lists.infradead.org, Eric Miao <eric.miao@marvell.com>,
       linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH] RFC: make struct platform_driver.id_table const
Message-ID: <20100126083500.GA20792@pengutronix.de>
References: <1264179837-22999-1-git-send-email-u.kleine-koenig@pengutronix.de> <20100125013421.GL26562@trinity.fluff.org> <4B5CFEBE.2070906@gmail.com> <20100125074242.GA12480@pengutronix.de> <4B5E092B.3070801@gmail.com> <f17812d71001252201n215f2a9y1906fef630726dbe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f17812d71001252201n215f2a9y1906fef630726dbe@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

On Tue, Jan 26, 2010 at 02:01:15PM +0800, Eric Miao wrote:
> I seems to remember a similar patch sent to GregKH weeks ago and
> should be sitting somewhere but this one looks to be more complete.
Yes, it's
	gregkh-2.6/gregkh-05-driver-core/driver-core-make-platform_device_id-table-const.patch

Below you can find the current state with all Acks it has got until now.
(Eric: I considered your mail as Ack, too.  OK?)
As I don't know how to change the log message with an incremental patch
you have to tell me if you prefer this way.

Best regards
Uwe

>From edd67c67746c4eb47e13ef3b9ced3c02243d8de7 Mon Sep 17 00:00:00 2001
From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Date: Fri, 22 Jan 2010 17:59:46 +0100
Subject: [PATCH] make struct platform_driver.id_table const
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This fixes a warning on several pxa based machines:

	arch/arm/mach-pxa/ssp.c:475: warning: initialization discards qualifiers from pointer target type

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Vikram Dhillon <dhillonv10@gmail.com>
Acked-by: Eric Miao <eric.y.miao@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/platform.c         |    2 +-
 include/linux/platform_device.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 58efaf2..962246c 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -578,7 +578,7 @@ static int platform_uevent(struct device *dev, struct kobj_uevent_env *env)
 }
 
 static const struct platform_device_id *platform_match_id(
-			struct platform_device_id *id,
+			const struct platform_device_id *id,
 			struct platform_device *pdev)
 {
 	while (id->name[0]) {
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 71ff887..3a6201e 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -21,7 +21,7 @@ struct platform_device {
 	u32		num_resources;
 	struct resource	* resource;
 
-	struct platform_device_id	*id_entry;
+	const struct platform_device_id	*id_entry;
 
 	/* arch specific additions */
 	struct pdev_archdata	archdata;
@@ -62,7 +62,7 @@ struct platform_driver {
 	int (*suspend)(struct platform_device *, pm_message_t state);
 	int (*resume)(struct platform_device *);
 	struct device_driver driver;
-	struct platform_device_id *id_table;
+	const struct platform_device_id *id_table;
 };
 
 extern int platform_driver_register(struct platform_driver *);
-- 
1.6.6

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
