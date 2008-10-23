Return-Path: <linux-kernel-owner+w=401wt.eu-S1753708AbYJWR4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbYJWR4I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 13:56:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753679AbYJWRzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 13:55:54 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:33520 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753712AbYJWRzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 13:55:53 -0400
Date: Thu, 23 Oct 2008 13:55:52 -0400
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-kernel@vger.kernel.org, ben-linux@fluff.org
Subject: Re: scx200_i2c driver fails to detect any i2c devices in 2.6.26 (new patch)
Message-ID: <20081023175552.GD5682@csclub.uwaterloo.ca>
References: <20081023165419.GA5682@csclub.uwaterloo.ca> <20081023193519.2af62bb5@hyperion.delvare> <20081023175311.GC5682@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023175311.GC5682@csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The scx200_i2c driver is missing the .class parameter, which means no
i2c drivers are willing to probe for devices on the bus and attach to
them.

This patch adds the missing .class parameter.

Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>

--- scx200_i2c.c	2008-05-20 09:39:24.000000000 -0400
+++ scx200_i2c.c.new	2008-10-23 13:51:57.000000000 -0400
@@ -81,6 +81,7 @@
 
 static struct i2c_adapter scx200_i2c_ops = {
 	.owner		   = THIS_MODULE,
+	.class		   = I2C_CLASS_HWMON | I2C_CLASS_SPD,
 	.id		   = I2C_HW_B_SCX200,
 	.algo_data	   = &scx200_i2c_data,
 	.name	= "NatSemi SCx200 I2C",



-- 
	Len Sorensen
