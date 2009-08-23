Return-Path: <linux-kernel-owner+w=401wt.eu-S933745AbZHWS2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933745AbZHWS2z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 14:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933571AbZHWS2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 14:28:54 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:50980 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933150AbZHWS2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 14:28:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=M9HkcYZqdNS9Eg1QPtevV1El/9AOz1eJChnXXvP+ni1dOi9vIIV0KTy65GqrU8dS9D
         05u8tvFG8E6fOTpXMj/olw9stv7+Bnu2PpJCqPy37KS8/fy2XdsmBMLB3ewWykcxhcMd
         wetL6xk950imiUKDtNw0h0IpNAlpBlvTauVeI=
Message-ID: <4A918A64.9040201@gmail.com>
Date: Sun, 23 Aug 2009 20:28:52 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Mike Frysinger <vapier@gentoo.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH resend] vsprintf: use WARN_ON_ONCE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: vsprintf: use WARN_ON_ONCE

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>

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
