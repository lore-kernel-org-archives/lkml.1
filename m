Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbZAHX3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbZAHX3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 18:29:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756001AbZAHX3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 18:29:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33035 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbZAHX3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 18:29:12 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: Alain Knaff <alain@knaff.lu>, Sam Ravnborg <sam@ravnborg.org>,
       x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Alain Knaff <alain@knaff.lu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] bzip2/lzma: fix decompress_inflate.c vs multi-block-with-embedded-filename
Date: Thu,  8 Jan 2009 15:28:59 -0800
Message-Id: <1231457340-18045-3-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.6.6
In-Reply-To: <1231457340-18045-2-git-send-email-hpa@zytor.com>
References: <1231457340-18045-1-git-send-email-hpa@zytor.com>
 <1231457340-18045-2-git-send-email-hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alain Knaff <alain@knaff.lu>

Impact: Bug fix

Fix gunzip uncompression, so that it also works with files with
embedded filenames that are larger than one block.

Signed-off-by: Alain Knaff <alain@knaff.lu>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 lib/decompress_inflate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/decompress_inflate.c b/lib/decompress_inflate.c
index d2e7c75..839a329 100644
--- a/lib/decompress_inflate.c
+++ b/lib/decompress_inflate.c
@@ -97,7 +97,7 @@ STATIC int INIT gunzip(unsigned char *buf, int len,
 			strm->next_in++;
 		strm->next_in++;
 	}
-	strm->avail_in = len - 10;
+	strm->avail_in = len - (strm->next_in - zbuf);
 
 	strm->next_out = out_buf;
 	strm->avail_out = out_len;
-- 
1.5.6.6

