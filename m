Return-Path: <linux-kernel-owner+w=401wt.eu-S1754621AbYKXSMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbYKXSMZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 13:12:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752909AbYKXSMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 13:12:17 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:33389 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbYKXSMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 13:12:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=SUcz3lHc9rbFdCxHCRc9Rt05Lr80GuZ1/04nfFDcb5hgHrFrI6bilnDCekrGbjeouC
         H8ycVebe4HsJHXhjuzHPqhmmq3/2NR8hP6hIk8+hWqyxGY46Et8MHTLmkxFPI7P+EgcF
         vyFor1p5/3QIf18Zyj/w/s5Antgf5t5gPeu3A=
Subject: [PATCH] i2c: trivial endian casting fixes in i2c-highlander.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 24 Nov 2008 10:12:11 -0800
Message-Id: <1227550331.5511.5.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes sparse warnings:
drivers/i2c/busses/i2c-highlander.c:95:26: warning: incorrect type in argument 1 (different base types)
drivers/i2c/busses/i2c-highlander.c:95:26:    expected restricted __be16 const [usertype] *p
drivers/i2c/busses/i2c-highlander.c:95:26:    got unsigned short [usertype] *<noident>
drivers/i2c/busses/i2c-highlander.c:106:15: warning: incorrect type in assignment (different base types)
drivers/i2c/busses/i2c-highlander.c:106:15:    expected unsigned short [unsigned] [short] [usertype] <noident>
drivers/i2c/busses/i2c-highlander.c:106:15:    got restricted __be16

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/i2c/busses/i2c-highlander.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-highlander.c b/drivers/i2c/busses/i2c-highlander.c
index f4d22ae..e5a8dae 100644
--- a/drivers/i2c/busses/i2c-highlander.c
+++ b/drivers/i2c/busses/i2c-highlander.c
@@ -92,7 +92,7 @@ static void highlander_i2c_setup(struct highlander_i2c_dev *dev)
 static void smbus_write_data(u8 *src, u16 *dst, int len)
 {
 	for (; len > 1; len -= 2) {
-		*dst++ = be16_to_cpup((u16 *)src);
+		*dst++ = be16_to_cpup((__be16 *)src);
 		src += 2;
 	}
 
@@ -103,7 +103,7 @@ static void smbus_write_data(u8 *src, u16 *dst, int len)
 static void smbus_read_data(u16 *src, u8 *dst, int len)
 {
 	for (; len > 1; len -= 2) {
-		*(u16 *)dst = cpu_to_be16p(src++);
+		*(__be16 *)dst = cpu_to_be16p(src++);
 		dst += 2;
 	}
 
-- 
1.6.0.4.1013.gc6a01



