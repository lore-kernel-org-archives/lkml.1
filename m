Return-Path: <linux-kernel-owner+w=401wt.eu-S1751987AbXBDC71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbXBDC71 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 21:59:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbXBDC71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 21:59:27 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:60718 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbXBDC71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 21:59:27 -0500
Date: Sun, 4 Feb 2007 02:59:24 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: torvald@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-usb-users@lists.sourceforge.net
Subject: [PATCH] fix rtl8150
Message-ID: <20070204025924.GI10050@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	That code doesn't do what its author apparently thought
it would do...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/drivers/usb/net/rtl8150.c b/drivers/usb/net/rtl8150.c
index e0eecda..670262a 100644
--- a/drivers/usb/net/rtl8150.c
+++ b/drivers/usb/net/rtl8150.c
@@ -284,7 +284,8 @@ static int write_mii_word(rtl8150_t * dev, u8 phy, __u8 indx, u16 reg)
 	u8 data[3], tmp;
 
 	data[0] = phy;
-	*(data + 1) = cpu_to_le16p(&reg);
+	data[1] = reg & 0xff;
+	data[2] = (reg >> 8) & 0xff;
 	tmp = indx | PHY_WRITE | PHY_GO;
 	i = 0;
 
