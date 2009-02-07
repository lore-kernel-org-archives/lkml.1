Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbZBGMqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbZBGMqv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 07:46:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbZBGMqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 07:46:39 -0500
Received: from ozlabs.org ([203.10.76.45]:45011 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834AbZBGMqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 07:46:39 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sat, 07 Feb 2009 23:15:22 +1030
Subject: [PATCH 4/9] strstarts: helper function for !strncmp(str, prefix, strlen(prefix))
Cc: Anders Kaseorg <andersk@mit.edu>
Cc: Jeff Arnold <jbarnold@mit.edu>
Cc: Tim Abbott <tabbott@mit.edu>
Message-Id: <20090207124638.32FEBDDDDF@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: minor new API

ksplice added a "starts_with" function, which seems like a common need.
When people open-code it they seem to use fixed numbers rather than strlen,
so it's quite a readability win (also, strncmp() almost always wants != 0
on it).

So here's strstarts().

Cc: Anders Kaseorg <andersk@mit.edu>
Cc: Jeff Arnold <jbarnold@mit.edu>
Cc: Tim Abbott <tabbott@mit.edu>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/string.h |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/string.h b/include/linux/string.h
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -114,5 +114,14 @@ extern ssize_t memory_read_from_buffer(v
 extern ssize_t memory_read_from_buffer(void *to, size_t count, loff_t *ppos,
 			const void *from, size_t available);
 
+/**
+ * strstarts - does @str start with @prefix?
+ * @str: string to examine
+ * @prefix: prefix to look for.
+ */
+static inline bool strstarts(const char *str, const char *prefix)
+{
+	return strncmp(str, prefix, strlen(prefix)) == 0;
+}
 #endif
 #endif /* _LINUX_STRING_H_ */

