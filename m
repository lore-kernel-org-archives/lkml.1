Return-Path: <linux-kernel-owner+w=401wt.eu-S1752186AbZHXJvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186AbZHXJvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 05:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbZHXJvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 05:51:15 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:56447 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbZHXJvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 05:51:14 -0400
Subject: Re: linux-next: voltage tree build failure
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Anuj Aggarwal <anuj.aggarwal@ti.com>
In-Reply-To: <20090824144044.fad8639f.sfr@canb.auug.org.au>
References: <20090824144044.fad8639f.sfr@canb.auug.org.au>
Content-Type: text/plain
Date: Mon, 24 Aug 2009 10:51:12 +0100
Message-Id: <1251107472.5773.24.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Mon, 2009-08-24 at 14:40 +1000, Stephen Rothwell wrote:
> Hi Liam,
> 
> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> drivers/regulator/tps65023-regulator: struct i2c_device_id is 32 bytes.  The last of 1 is:
> 0x74 0x70 0x73 0x36 0x35 0x30 0x32 0x33 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 
> FATAL: drivers/regulator/tps65023-regulator: struct i2c_device_id is not terminated with a NULL entry!
> 
> Caused by commit 9cfd343f14bf4bd95f8bfc6a1d411d2002bf94d8 ("Regulator:
> Add TPS65023 regulator driver").
> 
> I have used the version of the voltage tree from next-20090821 for today.

Sorry about this, looks like I failed to select both tps drivers in my
test build.

Fixed with this patch :-

    regulator: tps650xx - build fixes for x86_64
    
    Fixes the following errors on both tps650xx regulator drivers :-
    
    drivers/regulator/tps65023-regulator: struct i2c_device_id is 32 bytes.  The last of 1 is:
    0x74 0x70 0x73 0x36 0x35 0x30 0x32 0x33 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00
    FATAL: drivers/regulator/tps65023-regulator: struct i2c_device_id is not terminated with a NULL entry!
    
    This patch also fixes the GPL v2 licence string for both drivers.
    
    Signed-off-by: Liam Girdwood <lrg@slimlogic.co.uk>

diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
index 1e54f46..07fda0a 100644
--- a/drivers/regulator/tps65023-regulator.c
+++ b/drivers/regulator/tps65023-regulator.c
@@ -587,9 +587,10 @@ static const struct tps_info tps65023_regs[] = {
 	},
 };
 
-static const struct i2c_device_id tps_65023_id = {
-	.name = "tps65023",
-	.driver_data = (unsigned long) &tps65023_regs[0],
+static const struct i2c_device_id tps_65023_id[] = {
+	{.name = "tps65023",
+	.driver_data = (unsigned long) tps65023_regs,},
+	{ },
 };
 
 MODULE_DEVICE_TABLE(i2c, tps_65023_id);
@@ -601,7 +602,7 @@ static struct i2c_driver tps_65023_i2c_driver = {
 	},
 	.probe = tps_65023_probe,
 	.remove = __devexit_p(tps_65023_remove),
-	.id_table = &tps_65023_id,
+	.id_table = tps_65023_id,
 };
 
 /**
@@ -628,4 +629,4 @@ module_exit(tps_65023_cleanup);
 
 MODULE_AUTHOR("Texas Instruments");
 MODULE_DESCRIPTION("TPS65023 voltage regulator driver");
-MODULE_LICENSE("GPLv2");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/regulator/tps6507x-regulator.c b/drivers/regulator/tps6507x-regulator.c
index 1aa3636..f8a6dfb 100644
--- a/drivers/regulator/tps6507x-regulator.c
+++ b/drivers/regulator/tps6507x-regulator.c
@@ -670,9 +670,10 @@ static const struct tps_info tps6507x_regs[] = {
 	},
 };
 
-static const struct i2c_device_id tps_6507x_id = {
-	.name = "tps6507x",
-	.driver_data = (unsigned long) &tps6507x_regs[0],
+static const struct i2c_device_id tps_6507x_id[] = {
+	{.name = "tps6507x",
+	.driver_data = (unsigned long) tps6507x_regs,},
+	{ },
 };
 MODULE_DEVICE_TABLE(i2c, tps_6507x_id);
 
@@ -683,7 +684,7 @@ static struct i2c_driver tps_6507x_i2c_driver = {
 	},
 	.probe = tps_6507x_probe,
 	.remove = __devexit_p(tps_6507x_remove),
-	.id_table = &tps_6507x_id,
+	.id_table = tps_6507x_id,
 };
 
 /**
@@ -710,4 +711,4 @@ module_exit(tps_6507x_cleanup);
 
 MODULE_AUTHOR("Texas Instruments");
 MODULE_DESCRIPTION("TPS6507x voltage regulator driver");
-MODULE_LICENSE("GPLv2");
+MODULE_LICENSE("GPL v2");
 

