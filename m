Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbYKCFYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbYKCFYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 00:24:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751042AbYKCFYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 00:24:39 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:59081 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbYKCFYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 00:24:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=K876adjuouACIK+pgGCaAtt6CLS7rJH0Ui83efY0cYWZ9qhWI63CZIDCAwdiRcVzvF
         BjU4Kqt49IqpMmlnVM5cv1ktNlRBuOUJrP0M8thCWu4jS1qhVzqTsVNq5CHhgydTv/cm
         SBFopJwQXoY8UpSjLiiZFld5mowrVAGWpGefQ=
Subject: [PATCH-staging] go7007: annotate code pointers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 02 Nov 2008 21:24:35 -0800
Message-Id: <1225689875.5560.0.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are treated as __le16 everywhere, annotate as such.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/staging/go7007/go7007-fw.c |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/go7007/go7007-fw.c b/drivers/staging/go7007/go7007-fw.c
index a0e17b0..871ed43 100644
--- a/drivers/staging/go7007/go7007-fw.c
+++ b/drivers/staging/go7007/go7007-fw.c
@@ -284,7 +284,7 @@ static const int zz[64] = {
 	58, 59, 52, 45, 38, 31, 39, 46, 53, 60, 61, 54, 47, 55, 62, 63
 };
 
-static int copy_packages(u16 *dest, u16 *src, int pkg_cnt, int space)
+static int copy_packages(__le16 *dest, u16 *src, int pkg_cnt, int space)
 {
 	int i, cnt = pkg_cnt * 32;
 
@@ -292,7 +292,7 @@ static int copy_packages(u16 *dest, u16 *src, int pkg_cnt, int space)
 		return -1;
 
 	for (i = 0; i < cnt; ++i)
-		dest[i] = __cpu_to_le16(src[i]);
+		dest[i] = cpu_to_le16p(src + i);
 
 	return cnt;
 }
@@ -372,7 +372,7 @@ static int mjpeg_frame_header(struct go7007 *go, unsigned char *buf, int q)
 	return p;
 }
 
-static int gen_mjpeghdr_to_package(struct go7007 *go, u16 *code, int space)
+static int gen_mjpeghdr_to_package(struct go7007 *go, __le16 *code, int space)
 {
 	u8 *buf;
 	u16 mem = 0x3e00;
@@ -643,7 +643,7 @@ static int mpeg1_sequence_header(struct go7007 *go, unsigned char *buf, int ext)
 }
 
 static int gen_mpeg1hdr_to_package(struct go7007 *go,
-					u16 *code, int space, int *framelen)
+					__le16 *code, int space, int *framelen)
 {
 	u8 *buf;
 	u16 mem = 0x3e00;
@@ -831,7 +831,7 @@ static int mpeg4_sequence_header(struct go7007 *go, unsigned char *buf, int ext)
 }
 
 static int gen_mpeg4hdr_to_package(struct go7007 *go,
-					u16 *code, int space, int *framelen)
+					__le16 *code, int space, int *framelen)
 {
 	u8 *buf;
 	u16 mem = 0x3e00;
@@ -936,7 +936,7 @@ done:
 }
 
 static int brctrl_to_package(struct go7007 *go,
-					u16 *code, int space, int *framelen)
+					__le16 *code, int space, int *framelen)
 {
 	int converge_speed = 0;
 	int lambda = (go->format == GO7007_FORMAT_MJPEG || go->dvd_mode) ?
@@ -1091,7 +1091,7 @@ static int brctrl_to_package(struct go7007 *go,
 	return copy_packages(code, pack, 6, space);
 }
 
-static int config_package(struct go7007 *go, u16 *code, int space)
+static int config_package(struct go7007 *go, __le16 *code, int space)
 {
 	int fps = go->sensor_framerate / go->fps_scale / 1000;
 	int rows = go->interlace_coding ? go->height / 32 : go->height / 16;
@@ -1213,7 +1213,7 @@ static int config_package(struct go7007 *go, u16 *code, int space)
 	return copy_packages(code, pack, 5, space);
 }
 
-static int seqhead_to_package(struct go7007 *go, u16 *code, int space,
+static int seqhead_to_package(struct go7007 *go, __le16 *code, int space,
 	int (*sequence_header_func)(struct go7007 *go,
 		unsigned char *buf, int ext))
 {
@@ -1292,7 +1292,7 @@ static int relative_prime(int big, int little)
 	return big;
 }
 
-static int avsync_to_package(struct go7007 *go, u16 *code, int space)
+static int avsync_to_package(struct go7007 *go, __le16 *code, int space)
 {
 	int arate = go->board_info->audio_rate * 1001 * go->fps_scale;
 	int ratio = arate / go->sensor_framerate;
@@ -1323,7 +1323,7 @@ static int avsync_to_package(struct go7007 *go, u16 *code, int space)
 	return copy_packages(code, pack, 1, space);
 }
 
-static int final_package(struct go7007 *go, u16 *code, int space)
+static int final_package(struct go7007 *go, __le16 *code, int space)
 {
 	int rows = go->interlace_coding ? go->height / 32 : go->height / 16;
 	u16 pack[] = {
@@ -1386,7 +1386,7 @@ static int final_package(struct go7007 *go, u16 *code, int space)
 	return copy_packages(code, pack, 1, space);
 }
 
-static int audio_to_package(struct go7007 *go, u16 *code, int space)
+static int audio_to_package(struct go7007 *go, __le16 *code, int space)
 {
 	int clock_config = ((go->board_info->audio_flags &
 				GO7007_AUDIO_I2S_MASTER ? 1 : 0) << 11) |
@@ -1436,7 +1436,7 @@ static int audio_to_package(struct go7007 *go, u16 *code, int space)
 	return copy_packages(code, pack, 2, space);
 }
 
-static int modet_to_package(struct go7007 *go, u16 *code, int space)
+static int modet_to_package(struct go7007 *go, __le16 *code, int space)
 {
 	int ret, mb, i, addr, cnt = 0;
 	u16 pack[32];
@@ -1505,7 +1505,7 @@ static int modet_to_package(struct go7007 *go, u16 *code, int space)
 	return cnt;
 }
 
-static int do_special(struct go7007 *go, u16 type, u16 *code, int space,
+static int do_special(struct go7007 *go, u16 type, __le16 *code, int space,
 			int *framelen)
 {
 	switch (type) {
@@ -1555,7 +1555,7 @@ static int do_special(struct go7007 *go, u16 type, u16 *code, int space,
 int go7007_construct_fw_image(struct go7007 *go, u8 **fw, int *fwlen)
 {
 	const struct firmware *fw_entry;
-	u16 *code, *src;
+	__le16 *code, *src;
 	int framelen[8] = { }; /* holds the lengths of empty frame templates */
 	int codespace = 64 * 1024, i = 0, srclen, chunk_len, chunk_flags;
 	int mode_flag;
@@ -1590,7 +1590,7 @@ int go7007_construct_fw_image(struct go7007 *go, u8 **fw, int *fwlen)
 		goto fw_failed;
 	}
 	memset(code, 0, codespace * 2);
-	src = (u16 *)fw_entry->data;
+	src = (__le16 *)fw_entry->data;
 	srclen = fw_entry->size / 2;
 	while (srclen >= 2) {
 		chunk_flags = __le16_to_cpu(src[0]);
-- 
1.6.0.3.756.gb776d



