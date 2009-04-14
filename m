Return-Path: <linux-kernel-owner+w=401wt.eu-S1755633AbZDNNvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633AbZDNNvB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 09:51:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753791AbZDNNuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 09:50:50 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:53153 "EHLO
	teyla.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752783AbZDNNut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 09:50:49 -0400
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       Ben Dooks <ben-linux@fluff.org>
Subject: [PATCH] i2c: Fix warnings from I2C_BOARD_INFO()
Date: Tue, 14 Apr 2009 14:47:02 +0100
Message-Id: <1239716822-29143-1-git-send-email-ben-linux@fluff.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first argument for this macro is a string, and
thus having (arg) in the macro is causing gcc 4.2.4
to produce warnings about strings of the form ("str").

Remove the brackets from the first argument.

example warning:

mach-bast.c:545:3: warning: array initialized from parenthesized string constant

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
---
 include/linux/i2c.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index 00ee11e..ad25805 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -274,7 +274,7 @@ struct i2c_board_info {
  * are provided using conventional syntax.
  */
 #define I2C_BOARD_INFO(dev_type, dev_addr) \
-	.type = (dev_type), .addr = (dev_addr)
+	.type = dev_type, .addr = (dev_addr)
 
 
 /* Add-on boards should register/unregister their devices; e.g. a board
-- 
1.5.6.5

