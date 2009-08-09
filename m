Return-Path: <linux-kernel-owner+w=401wt.eu-S1753389AbZHIUCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbZHIUCk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 16:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276AbZHIUCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 16:02:40 -0400
Received: from mail-yw0-f193.google.com ([209.85.211.193]:33336 "EHLO
	mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbZHIUCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 16:02:39 -0400
X-Greylist: delayed 449 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Aug 2009 16:02:39 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lHR+OOFdXHi+okTIC1hLez879ZEuiscQ8ehGEwytAlnPkhXs9ei+io3j4BxPVhXtmz
         frDk6UOuwvPOtk7Gu/UnE+csYriUjfI5/E79GK9wcczQBKsWlbY5Dx7wkrjGlDjBbaoh
         lxdSejq11k8fFgp9qxN+FMP2jRR0tsu2/cM+0=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 13/14] vsprintf: use WARN_ON_ONCE
Date: Sun,  9 Aug 2009 21:54:08 +0200
Message-Id: <1249847649-11631-14-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249847649-11631-1-git-send-email-marcin.slusarz@gmail.com>
References: <1249847649-11631-1-git-send-email-marcin.slusarz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
---
 lib/vsprintf.c |   14 ++------------
 1 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 756ccaf..a63bb18 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -983,13 +983,8 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 
 	/* Reject out-of-range values early.  Large positive sizes are
 	   used for unknown buffer sizes. */
-	if (unlikely((int) size < 0)) {
-		/* There can be only one.. */
-		static char warn = 1;
-		WARN_ON(warn);
-		warn = 0;
+	if (WARN_ON_ONCE((int) size < 0))
 		return 0;
-	}
 
 	str = buf;
 	end = buf + size;
@@ -1439,13 +1434,8 @@ int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf)
 
 	struct printf_spec spec = {0};
 
-	if (unlikely((int) size < 0)) {
-		/* There can be only one.. */
-		static char warn = 1;
-		WARN_ON(warn);
-		warn = 0;
+	if (WARN_ON_ONCE((int) size < 0))
 		return 0;
-	}
 
 	str = buf;
 	end = buf + size;
-- 
1.6.3.3

