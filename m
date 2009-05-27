Return-Path: <linux-kernel-owner+w=401wt.eu-S1758254AbZE0Wf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254AbZE0Wf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 18:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757422AbZE0WfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 18:35:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:59570 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756395AbZE0WfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 18:35:05 -0400
Date: Wed, 27 May 2009 22:34:35 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
       tglx@linutronix.de
In-Reply-To: <4A14EDB6.2050507@cn.fujitsu.com>
References: <4A14EDB6.2050507@cn.fujitsu.com>
Subject: [tip:tracing/core] tracing/events: change the type of __str_loc_item to unsigned short
Message-ID: <tip-b0aae68cc5508f3c2fbf728988c954db4c8b8a53@git.kernel.org>
Git-Commit-ID: b0aae68cc5508f3c2fbf728988c954db4c8b8a53
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 27 May 2009 22:34:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b0aae68cc5508f3c2fbf728988c954db4c8b8a53
Gitweb:     http://git.kernel.org/tip/b0aae68cc5508f3c2fbf728988c954db4c8b8a53
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 21 May 2009 13:59:18 +0800
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Tue, 26 May 2009 00:15:21 +0200

tracing/events: change the type of __str_loc_item to unsigned short

When defining a dynamic size string, we add __str_loc_##item to the
trace entry, and it stores the location of the actual string in
entry->_str_data[]

'unsigned short' should be sufficient to store this information, thus
we save 2 bytes per dyn-size string in the ring buffer.

[ Impact: reduce memory occupied by dyn-size strings in ring buffer ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <4A14EDB6.2050507@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>


---
 include/trace/ftrace.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index edb02bc..b5ff2e8 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -25,7 +25,7 @@
 #define __field(type, item)		type	item;
 
 #undef __string
-#define __string(item, src)		int	__str_loc_##item;
+#define __string(item, src)		unsigned short	__str_loc_##item;
 
 #undef TP_STRUCT__entry
 #define TP_STRUCT__entry(args...) args
