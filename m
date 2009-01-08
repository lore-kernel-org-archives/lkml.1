Return-Path: <linux-kernel-owner+w=401wt.eu-S1763968AbZAHX36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763968AbZAHX36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 18:29:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756562AbZAHX3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 18:29:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33036 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501AbZAHX3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 18:29:12 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: Alain Knaff <alain@knaff.lu>, Sam Ravnborg <sam@ravnborg.org>,
       x86@kernel.org
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] bzip2/lzma: fix constant in decompress_inflate
Date: Thu,  8 Jan 2009 15:28:58 -0800
Message-Id: <1231457340-18045-2-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.6.6
In-Reply-To: <1231457340-18045-1-git-send-email-hpa@zytor.com>
References: <1231457340-18045-1-git-send-email-hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Cleanup

Fix constant 0x8100 /* 32K */; according to Alain the value 0x8100 was
left over test code to test misalignment, the correct value is indeed
0x8000 == 32K.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 lib/decompress_inflate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/decompress_inflate.c b/lib/decompress_inflate.c
index 163e66a..d2e7c75 100644
--- a/lib/decompress_inflate.c
+++ b/lib/decompress_inflate.c
@@ -41,7 +41,7 @@ STATIC int INIT gunzip(unsigned char *buf, int len,
 	set_error_fn(error_fn);
 	rc = -1;
 	if (flush) {
-		out_len = 0x8100; /* 32 K */
+		out_len = 0x8000; /* 32 K */
 		out_buf = malloc(out_len);
 	} else {
 		out_len = 0x7fffffff; /* no limit */
-- 
1.5.6.6

