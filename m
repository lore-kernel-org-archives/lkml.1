Return-Path: <linux-kernel-owner+w=401wt.eu-S1761562AbXJMHkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761562AbXJMHkn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 03:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbXJMHkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 03:40:35 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:32824 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbXJMHke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 03:40:34 -0400
Date: Sat, 13 Oct 2007 08:40:24 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: davem@davemloft.net, sam@ravnborg.org, xemul@openvz.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] fix sparc32 breakage (result of vmlinux.lds.S bug)
Message-ID: <20071013074024.GI8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	In commit 4665079cbb2a3e17de82f2ab2940b9f97f37d65e ([NETNS]: Move
some code into __init section when CONFIG_NET_NS=n) we got a new section -
.exit.text.refok (more of 'let's tell modpost that some bogus calls are
not bogus', a-la text.init.refok).
	Unfortunately, commit in question forgot to add it to TEXT_TEXT,
with rather amusing results.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 0240e05..5615440 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -153,7 +153,8 @@
 #define TEXT_TEXT							\
 		ALIGN_FUNCTION();					\
 		*(.text)						\
-		*(.text.init.refok)
+		*(.text.init.refok)					\
+		*(.exit.text.refok)
 
 /* sched.text is aling to function alignment to secure we have same
  * address even at second ld pass when generating System.map */
