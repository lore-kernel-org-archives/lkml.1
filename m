Return-Path: <linux-kernel-owner+w=401wt.eu-S1758772AbYCNUm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772AbYCNUm4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 16:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758044AbYCNUmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 16:42:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754379AbYCNUmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 16:42:46 -0400
Message-ID: <47DAE2C4.2060303@redhat.com>
Date: Fri, 14 Mar 2008 16:40:36 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Shaohua Li <shaohua.li@intel.com>, David Miller <davem@davemloft.net>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: [PATCH -mm 1/5] list.h: add list_singleton
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add list_singleton to check a list has just one entry.

list_singleton is useful to check whether a list_head which
have been temporarily allocated for listing objects can be
released or not.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
---
 include/linux/list.h |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: 2.6.25-rc5-mm1/include/linux/list.h
===================================================================
--- 2.6.25-rc5-mm1.orig/include/linux/list.h
+++ 2.6.25-rc5-mm1/include/linux/list.h
@@ -211,6 +211,15 @@ static inline int list_empty_careful(con
 	return (next == head) && (next == head->prev);
 }

+/**
+ * list_singleton - tests whether a list has just one entry.
+ * @head: the list to test.
+ */
+static inline int list_singleton(const struct list_head *head)
+{
+	return !list_empty(head) && (head->next == head->prev);
+}
+
 static inline void __list_splice(struct list_head *list,
 				 struct list_head *head)
 {
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com





