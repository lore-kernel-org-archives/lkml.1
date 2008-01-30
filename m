Return-Path: <linux-kernel-owner+w=401wt.eu-S932963AbYA3VRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932963AbYA3VRo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 16:17:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971AbYA3VG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 16:06:26 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:25275 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655AbYA3VFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 16:05:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=J2+1A6MabGszEUz26zgFEceDXFV2pJ2dO14dafD1+IxTDE/JuEm9gAaI72PFcvM3nbSetxWjskfmD9XZTj/mHs1vfGQlLESrjIwWM2G8pBSDEcbKsmyD7HLbQn1jCJgKaahEGvIUO4DgK5tJ3yAXJNGbpVRx5JSUCagb/0De6F4=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 04/10] udf: constify crc
Date: Wed, 30 Jan 2008 22:03:54 +0100
Message-Id: <1201727040-6769-5-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1201727040-6769-1-git-send-email-marcin.slusarz@gmail.com>
References: <1201727040-6769-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- constify internal crc table
- mark udf_crc "in" parameter as const

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Jan Kara <jack@suse.cz>
---
 fs/udf/crc.c     |    4 ++--
 fs/udf/udfdecl.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/udf/crc.c b/fs/udf/crc.c
index b166129..f178c63 100644
--- a/fs/udf/crc.c
+++ b/fs/udf/crc.c
@@ -23,7 +23,7 @@
 
 #include "udfdecl.h"
 
-static uint16_t crc_table[256] = {
+static const uint16_t crc_table[256] = {
 	0x0000U, 0x1021U, 0x2042U, 0x3063U, 0x4084U, 0x50a5U, 0x60c6U, 0x70e7U,
 	0x8108U, 0x9129U, 0xa14aU, 0xb16bU, 0xc18cU, 0xd1adU, 0xe1ceU, 0xf1efU,
 	0x1231U, 0x0210U, 0x3273U, 0x2252U, 0x52b5U, 0x4294U, 0x72f7U, 0x62d6U,
@@ -79,7 +79,7 @@ static uint16_t crc_table[256] = {
  *	July 21, 1997 - Andrew E. Mileski
  *	Adapted from OSTA-UDF(tm) 1.50 standard.
  */
-uint16_t udf_crc(uint8_t *data, uint32_t size, uint16_t crc)
+uint16_t udf_crc(const uint8_t *data, uint32_t size, uint16_t crc)
 {
 	while (size--)
 		crc = crc_table[(crc >> 8 ^ *(data++)) & 0xffU] ^ (crc << 8);
diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
index 0c525e8..c6c457b 100644
--- a/fs/udf/udfdecl.h
+++ b/fs/udf/udfdecl.h
@@ -192,7 +192,7 @@ extern long_ad *udf_get_filelongad(uint8_t *, int, uint32_t *, int);
 extern short_ad *udf_get_fileshortad(uint8_t *, int, uint32_t *, int);
 
 /* crc.c */
-extern uint16_t udf_crc(uint8_t *, uint32_t, uint16_t);
+extern uint16_t udf_crc(const uint8_t *, uint32_t, uint16_t);
 
 /* udftime.c */
 extern time_t *udf_stamp_to_time(time_t *, long *, kernel_timestamp);
-- 
1.5.3.7

