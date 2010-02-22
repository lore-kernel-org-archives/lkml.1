Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab0BVSLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 13:11:44 -0500
Received: from smtp.nokia.com ([192.100.122.233]:26274 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab0BVSLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 13:11:20 -0500
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 10/11] drivers: wireless: use new hex_to_bin() method
Date: Mon, 22 Feb 2010 20:09:09 +0200
Message-Id: <727e1d8eb3bd9a859f1e28a50b60becb7ca3acbe.1266861291.git.ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1592c1379a6fda43140d113bb8001badce461bd9.1266861291.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <d8c224af14aa936dcd692c70656559fe9726d997.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <5627f8a3ddb2d746e58409d1d59338a99b77291a.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <c515333a5ade859310436de33402a057080ec429.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <939cb3c63fbf6639b5d301ddc79c64d5642a6b81.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <d8efe17f827514a0c470191dccaf00afd09c2854.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <8470deda388af7015db44e96fa69560dd6e30126.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <5c02662a55439f65791e24b8282d4face566955e.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <1c143f904aaf005e81f1adf057d8c8df8b6ea294.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <1592c1379a6fda43140d113bb8001badce461bd9.1266861291.git.ext-andriy.shevchenko@nokia.com>
In-Reply-To: <cover.1266861291.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1266861291.git.ext-andriy.shevchenko@nokia.com>
X-OriginalArrivalTime: 22 Feb 2010 18:10:31.0439 (UTC) FILETIME=[521641F0:01CAB3EA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Instead of using own implementation involve hex_to_bin() function. It requires
to have hex_to_bin() introduced by starter patch in series.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/airo.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 4331d67..4c4e11c 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -5150,13 +5150,6 @@ static void proc_SSID_on_close(struct inode *inode, struct file *file)
 	enable_MAC(ai, 1);
 }
 
-static inline u8 hexVal(char c) {
-	if (c>='0' && c<='9') return c -= '0';
-	if (c>='a' && c<='f') return c -= 'a'-10;
-	if (c>='A' && c<='F') return c -= 'A'-10;
-	return 0;
-}
-
 static void proc_APList_on_close( struct inode *inode, struct file *file ) {
 	struct proc_data *data = (struct proc_data *)file->private_data;
 	struct proc_dir_entry *dp = PDE(inode);
@@ -5176,11 +5169,11 @@ static void proc_APList_on_close( struct inode *inode, struct file *file ) {
 			switch(j%3) {
 			case 0:
 				APList_rid.ap[i][j/3]=
-					hexVal(data->wbuffer[j+i*6*3])<<4;
+					hex_to_bin(data->wbuffer[j+i*6*3])<<4;
 				break;
 			case 1:
 				APList_rid.ap[i][j/3]|=
-					hexVal(data->wbuffer[j+i*6*3]);
+					hex_to_bin(data->wbuffer[j+i*6*3]);
 				break;
 			}
 		}
@@ -5331,10 +5324,10 @@ static void proc_wepkey_on_close( struct inode *inode, struct file *file ) {
 	for( i = 0; i < 16*3 && data->wbuffer[i+j]; i++ ) {
 		switch(i%3) {
 		case 0:
-			key[i/3] = hexVal(data->wbuffer[i+j])<<4;
+			key[i/3] = hex_to_bin(data->wbuffer[i+j])<<4;
 			break;
 		case 1:
-			key[i/3] |= hexVal(data->wbuffer[i+j]);
+			key[i/3] |= hex_to_bin(data->wbuffer[i+j]);
 			break;
 		}
 	}
-- 
1.5.6.5

