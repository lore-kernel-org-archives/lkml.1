Return-Path: <linux-kernel-owner+w=401wt.eu-S938657AbZDJOHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938657AbZDJOHd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 10:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760766AbZDJOHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 10:07:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:58572 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761286AbZDJOHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 10:07:04 -0400
Date: Fri, 10 Apr 2009 14:06:14 GMT
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, zhaolei@cn.fujitsu.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, zhaolei@cn.fujitsu.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49DC6751.30308@cn.fujitsu.com>
References: <49DC6751.30308@cn.fujitsu.com>
Subject: [tip:tracing/urgent] Make __stringify support variable argument macros too
Message-ID: <tip-8f7c2c37319a81ef4c2bfdec67b1ccd5744d97e4@git.kernel.org>
Git-Commit-ID: 8f7c2c37319a81ef4c2bfdec67b1ccd5744d97e4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Apr 2009 14:06:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8f7c2c37319a81ef4c2bfdec67b1ccd5744d97e4
Gitweb:     http://git.kernel.org/tip/8f7c2c37319a81ef4c2bfdec67b1ccd5744d97e4
Author:     Zhaolei <zhaolei@cn.fujitsu.com>
AuthorDate: Wed, 8 Apr 2009 16:58:57 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Apr 2009 15:48:52 +0200

Make __stringify support variable argument macros too

For example:

  __stringify(__entry->irq, __entry->ret)

will now convert it to:

  "REC->irq, REC->ret"

It also still supports single arguments as the old macro did.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <49DC6751.30308@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/stringify.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/stringify.h b/include/linux/stringify.h
index 0b43883..841cec8 100644
--- a/include/linux/stringify.h
+++ b/include/linux/stringify.h
@@ -6,7 +6,7 @@
  * converts to "bar".
  */
 
-#define __stringify_1(x)	#x
-#define __stringify(x)		__stringify_1(x)
+#define __stringify_1(x...)	#x
+#define __stringify(x...)	__stringify_1(x)
 
 #endif	/* !__LINUX_STRINGIFY_H */
