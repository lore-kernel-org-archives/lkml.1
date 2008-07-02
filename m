Return-Path: <linux-kernel-owner+w=401wt.eu-S1762819AbYGBHWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762819AbYGBHWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 03:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761102AbYGBHWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 03:22:38 -0400
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:44864 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760751AbYGBHWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 03:22:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=zQ3p8ki31Dzr0dKu/3DLRzHVEuBSNOwC9G9z8cUHA5MsvOKkcSgpVuUcawHZH6X9DsM5mVLmZZnbZYZpavu+vrbrCL8mDF1CKXNh5Dv1dQgA3r32YF7g0XMEj/aXhKqg4qWw6iZjOCD42HcICwBTOaiYWPJT2oQRRL9/YZXmx60=  ;
X-YMail-OSG: fQdTIq0VM1lmYcYnCTxD.E.io5n7sRfA9abb38A9lG6g0Osai5be1lAKqI82InXIKnXXNZglKnDojWkDBCGSWqmLTNGjPNyomykkXiKErGOTcgmjrYFvCQHRI9rbfe6puU4-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2.6.26-rc8] drivers/power:  fix platform driver hotplug/coldplug
Date: Wed, 2 Jul 2008 00:13:14 -0700
User-Agent: KMail/1.9.9
Cc: kay.sievers@vrfy.org, mreimer@vpop.net,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807020013.14579.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf, the platform
modalias is prefixed with "platform:". Add MODULE_ALIAS() to the
hotpluggable "power" drivers drivers, to re-enable auto loading.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
[ dbrownell@users.sourceforge.net: one was missing ]
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/power/ds2760_battery.c |    2 ++
 drivers/power/pda_power.c      |    2 ++
 2 files changed, 4 insertions(+)

--- a/drivers/power/ds2760_battery.c	2008-07-01 23:49:46.000000000 -0700
+++ b/drivers/power/ds2760_battery.c	2008-07-01 23:51:48.000000000 -0700
@@ -433,6 +433,8 @@ static int ds2760_battery_resume(struct 
 
 #endif /* CONFIG_PM */
 
+MODULE_ALIAS("platform:ds2760-battery");
+
 static struct platform_driver ds2760_battery_driver = {
 	.driver = {
 		.name = "ds2760-battery",
--- a/drivers/power/pda_power.c	2008-07-02 00:10:18.000000000 -0700
+++ b/drivers/power/pda_power.c	2008-07-02 00:10:36.000000000 -0700
@@ -362,6 +362,8 @@ static int pda_power_resume(struct platf
 #define pda_power_resume NULL
 #endif /* CONFIG_PM */
 
+MODULE_ALIAS("platform:pda-power");
+
 static struct platform_driver pda_power_pdrv = {
 	.driver = {
 		.name = "pda-power",
