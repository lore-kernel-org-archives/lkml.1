Return-Path: <linux-kernel-owner+w=401wt.eu-S1753166AbYKGWPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbYKGWPo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 17:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbYKGWPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 17:15:14 -0500
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:23948 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751485AbYKGWPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 17:15:12 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=noazLK6EF2i7xy3pGw6wgLvaE6F+LmvJgq9gSdXWcYAM/SZv3xnH45eCj6+1bnM6OjTCr9OvSXutCOwNkhhO6Nn1dqKpjXYWDqjVVmNfGfmUttZGjcoxFnfwWNnJIm8wVNYtiUh5xOcCEbZligU1jZsZR1d0wc3NyMEfRNoqIsM=  ;
X-YMail-OSG: c0wPEjsVM1nv6IaWJb6_rf0.eDOeX9in.wS3PZybPWFHM8hPijlbdUSaXAj_5FiqgAp6qjY9AuXHV2Vku1VKDzpljHUZ.YpzgckTV17BTCRGW_1W8azajQ7S8cIChh1pYKeBDnnM0T6uLjgp2L0hvRRPQgVqVkVZayO.awyOJgrWoFid4tY_YSQ5E.HW
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Samuel Ortiz <sameo@openedhand.com>
Subject: [patch 2.6.28-rc3-git] twl4030-core: allow reading entire register banks
Date: Fri, 7 Nov 2008 14:00:03 -0800
User-Agent: KMail/1.9.10
Cc: lkml <linux-kernel@vger.kernel.org>, linux-omap@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811071400.04181.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Minor change to the TWL4030 utility interface:  support reads
of all 256 bytes in each register bank (vs just 255).  This
can help when debugging, but is otherwise a NOP.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/mfd/twl4030-core.c  |    4 ++--
 include/linux/i2c/twl4030.h |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/mfd/twl4030-core.c
+++ b/drivers/mfd/twl4030-core.c
@@ -233,7 +233,7 @@ extern void twl4030_power_init(struct tw
  *
  * Returns the result of operation - 0 is success
  */
-int twl4030_i2c_write(u8 mod_no, u8 *value, u8 reg, u8 num_bytes)
+int twl4030_i2c_write(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
 {
 	int ret;
 	int sid;
@@ -282,7 +282,7 @@ EXPORT_SYMBOL(twl4030_i2c_write);
  *
  * Returns result of operation - num_bytes is success else failure.
  */
-int twl4030_i2c_read(u8 mod_no, u8 *value, u8 reg, u8 num_bytes)
+int twl4030_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
 {
 	int ret;
 	u8 val;
--- a/include/linux/i2c/twl4030.h
+++ b/include/linux/i2c/twl4030.h
@@ -78,8 +78,8 @@ int twl4030_i2c_read_u8(u8 mod_no, u8 *v
  * IMPORTANT:  For twl4030_i2c_write(), allocate num_bytes + 1
  * for the value, and populate your data starting at offset 1.
  */
-int twl4030_i2c_write(u8 mod_no, u8 *value, u8 reg, u8 num_bytes);
-int twl4030_i2c_read(u8 mod_no, u8 *value, u8 reg, u8 num_bytes);
+int twl4030_i2c_write(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes);
+int twl4030_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes);
 
 /*----------------------------------------------------------------------*/
 
