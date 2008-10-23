Return-Path: <linux-kernel-owner+w=401wt.eu-S1757490AbYJWQy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490AbYJWQy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 12:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbYJWQyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 12:54:20 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:54365 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751378AbYJWQyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 12:54:20 -0400
Date: Thu, 23 Oct 2008 12:54:19 -0400
To: linux-kernel@vger.kernel.org
Cc: ben-linux@fluff.org, khali@linux-fr.org,
       Len Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: scx200_i2c driver fails to detect any i2c devices in 2.6.26
Message-ID: <20081023165419.GA5682@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 2.6.18, the scx200_i2c driver was working just fine.  Now while
moving to 2.6.26 I find that the bus no longer locates any devices when
drivers are loaded, even though i2cdetect has no problem locating
devices on the bus.

After some searching, I discovered that the scx200_i2c driver doesn't
have a .class parameter filled in, even though every other i2c driver
does.  A small patch adding the .class parameter fixes the problem.

Not sure if it should be I2C_CLASS_ALL or I2C_CLASS_HWMON, or even
I2C_CLASS_HWMON | I2C_CLASS_SPD (in current git tree).  Using
I2C_CLASS_ALL works for me and works with my lm75, m41t81 and spd
eeprom in 2.6.26.

--- a/drivers/i2c/busses/scx200_i2c.c	2008-07-13 17:51:29.000000000 -0400
+++ b/drivers/i2c/busses/scx200_i2c.c	2008-10-23 12:41:02.000000000 -0400
@@ -81,6 +81,7 @@
 
 static struct i2c_adapter scx200_i2c_ops = {
 	.owner		   = THIS_MODULE,
+	.class             = I2C_CLASS_ALL,
 	.id		   = I2C_HW_B_SCX200,
 	.algo_data	   = &scx200_i2c_data,
 	.name	= "NatSemi SCx200 I2C",

-- 
Len Sorensen
