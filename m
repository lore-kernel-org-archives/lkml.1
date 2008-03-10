Return-Path: <linux-kernel-owner+w=401wt.eu-S1753990AbYCJBQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbYCJBQX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 21:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941AbYCJBQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 21:16:13 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:26634 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbYCJBQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 21:16:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=n/QELEvSG1K1iW1QYDC3vBHwFu0ysh9/xtBWt+0uFG/PI9MkmfaQ3n63LxxEvzwNAQvUlUAoXAoeFVxLM/M/va9OC/LJVjppXaFEwW2Gc0FH04jCYYPMcjRdycQngSQb6TGB5OD4X1C710xuoySmU1zBVYKRaTnj/BfCpCwIIWs=
Date: Mon, 10 Mar 2008 09:22:02 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hannes@saeurebad.de,
       alan@lxorguk.ukuu.org.uk
Subject: [PATCH v3] Add time_is_after_jiffies and others which compare with
	jiffies
Message-ID: <20080310012202.GA2958@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of time_after like macros usages just compare jiffies and
another number, so here add some time_is_* macros for convenience.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

---
include/linux/jiffies.h |   16 ++++++++++++++++
1 file changed, 16 insertions(+)

diff -upr linux/include/linux/jiffies.h linux.new/include/linux/jiffies.h
--- linux/include/linux/jiffies.h	2008-03-07 10:40:04.000000000 +0800
+++ linux.new/include/linux/jiffies.h	2008-03-10 09:11:36.000000000 +0800
@@ -135,6 +135,22 @@ static inline u64 get_jiffies_64(void)
 #define time_before_eq64(a,b)	time_after_eq64(b,a)
 
 /*
+ * These four macros compare jiffies and 'a' for convenience.
+ */
+
+/* time_is_before_jiffies(a) return true if a is before jiffies */
+#define time_is_before_jiffies(a) time_after(jiffies, a)
+
+/* time_is_after_jiffies(a) return true if a is after jiffies */
+#define time_is_after_jiffies(a) time_before(jiffies, a)
+
+/* time_is_before_eq_jiffies(a) return true if a is before or equal to jiffies*/
+#define time_is_before_eq_jiffies(a) time_after_eq(jiffies, a)
+
+/* time_is_after_eq_jiffies(a) return true if a is after or equal to jiffies*/
+#define time_is_after_eq_jiffies(a) time_before_eq(jiffies, a)
+
+/*
  * Have the 32 bit jiffies value wrap 5 minutes after boot
  * so jiffies wrap bugs show up earlier.
  */
