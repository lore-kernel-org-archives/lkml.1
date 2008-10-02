Return-Path: <linux-kernel-owner+w=401wt.eu-S1755843AbYJBPMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbYJBPMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 11:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755008AbYJBPLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 11:11:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42863 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933AbYJBPLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 11:11:17 -0400
Message-Id: <20081002151104.821728138@goodmis.org>
References: <20081002150529.087488257@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 02 Oct 2008 11:05:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jaroslav Kysela <perex@perex.cz>, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 4/5] sound: update snd_assert macro
Content-Disposition: inline; filename=sound-core-fix-snd-assert-macro.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One user of the snd_assert macro calls a goto and the compiler
complains that the label is not used when the snd_assert is
not set.

This patch makes snd_assert more robust when not defined to
let the compiler know about arguments when not in use.

CC: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/sound/core.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: linux-compile.git/include/sound/core.h
===================================================================
--- linux-compile.git.orig/include/sound/core.h	2008-07-27 09:26:33.000000000 -0400
+++ linux-compile.git/include/sound/core.h	2008-10-02 10:00:57.000000000 -0400
@@ -407,7 +407,13 @@ void snd_verbose_printd(const char *file
 #else /* !CONFIG_SND_DEBUG */
 
 #define snd_printd(fmt, args...)	/* nothing */
-#define snd_assert(expr, args...)	(void)(expr)
+/* Keep the compiler happy by showing the expr and args */
+#define snd_assert(expr, args...)	do {	\
+	if (0) {				\
+		(void)(expr);			\
+		args;				\
+	}					\
+} while(0)
 #define snd_BUG()			/* nothing */
 
 #endif /* CONFIG_SND_DEBUG */

-- 
