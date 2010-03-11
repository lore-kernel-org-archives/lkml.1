Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933027Ab0CKPBd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 10:01:33 -0500
Received: from smtp.nokia.com ([192.100.122.233]:54106 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932522Ab0CKPBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 10:01:30 -0500
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: [PATCHv2] fs: fat: use pack_hex_byte() instead of custom one
Date: Thu, 11 Mar 2010 17:00:14 +0200
Message-Id: <1268319614-21252-1-git-send-email-andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <87iq93s013.fsf@devron.myhome.or.jp>
References: <87iq93s013.fsf@devron.myhome.or.jp>
X-OriginalArrivalTime: 11 Mar 2010 15:01:16.0755 (UTC) FILETIME=[B330BA30:01CAC12B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
---
 fs/fat/dir.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 530b4ca..5de1a70 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -19,6 +19,7 @@
 #include <linux/buffer_head.h>
 #include <linux/compat.h>
 #include <asm/uaccess.h>
+#include <linux/kernel.h>
 #include "fat.h"
 
 /*
@@ -149,19 +150,14 @@ static int uni16_to_x8(unsigned char *ascii, const wchar_t *uni, int len,
 
 	while (*ip && ((len - NLS_MAX_CHARSET_SIZE) > 0)) {
 		ec = *ip++;
-		if ( (charlen = nls->uni2char(ec, op, NLS_MAX_CHARSET_SIZE)) > 0) {
+		if ((charlen = nls->uni2char(ec, op, NLS_MAX_CHARSET_SIZE)) > 0) {
 			op += charlen;
 			len -= charlen;
 		} else {
 			if (uni_xlate == 1) {
-				*op = ':';
-				for (k = 4; k > 0; k--) {
-					nc = ec & 0xF;
-					op[k] = nc > 9	? nc + ('a' - 10)
-							: nc + '0';
-					ec >>= 4;
-				}
-				op += 5;
+				*op++ = ':';
+				op = pack_hex_byte(op, ec >> 8);
+				op = pack_hex_byte(op, ec);
 				len -= 5;
 			} else {
 				*op++ = '?';
-- 
1.5.6.5

