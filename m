Return-Path: <linux-kernel-owner+w=401wt.eu-S1753299AbYHHGzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbYHHGzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 02:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752376AbYHHGwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 02:52:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:11492 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754749AbYHHGwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 02:52:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,325,1215414000"; 
   d="scan'208";a="368829758"
Subject: [PATCH -v2 7/8] kexec jump: ftrace_enabled_save/restore
From: Huang Ying <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 14:52:48 +0800
Message-Id: <1218178368.22039.80.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ftrace_enabled_save/restore, used to disable ftrace for a
while. This is used by kexec jump.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 include/linux/ftrace.h |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -98,6 +98,24 @@ static inline void tracer_disable(void)
 #endif
 }
 
+static inline int ftrace_enabled_save(void)
+{
+#ifdef CONFIG_FTRACE
+	int saved_ftrace_enabled = ftrace_enabled;
+	ftrace_enabled = 0;
+	return saved_ftrace_enabled;
+#else
+	return 0;
+#endif
+}
+
+static inline void ftrace_enabled_restore(int enabled)
+{
+#ifdef CONFIG_FTRACE
+	ftrace_enabled = enabled;
+#endif
+}
+
 #ifdef CONFIG_FRAME_POINTER
 /* TODO: need to fix this for ARM */
 # define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))


