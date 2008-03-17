Return-Path: <linux-kernel-owner+w=401wt.eu-S1755190AbYCQUxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbYCQUxn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 16:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbYCQUxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 16:53:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbYCQUxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 16:53:33 -0400
Message-ID: <47DEDA20.30006@redhat.com>
Date: Mon, 17 Mar 2008 16:52:48 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Andrew Morton <akpm@linux-foundation.org>, ananth@in.ibm.com,
       jkenisto@us.ibm.com, linux-kernel@vger.kernel.org,
       systemtap@sources.redhat.com, prasanna@in.ibm.com, shaohua.li@intel.com,
       davem@davemloft.net, fche@redhat.com
Subject: [PATCH -mm] list.h: rename list_singleton to list_is_singular
References: <47DAE2C4.2060303@redhat.com>	 <20080314140007.a7b495d7.akpm@linux-foundation.org>	 <47DAFAA2.20302@redhat.com> <1205620596.6422.8.camel@lappy>	 <47DE8870.1020503@redhat.com> <1205766798.8514.318.camel@twins>
In-Reply-To: <1205766798.8514.318.camel@twins>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename list_singleton to list_is_singular.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
---
Peter Zijlstra wrote:
> I think list_has_one() or list_is_singular() are good names, they convey
> they are a test for a condition by using a form of be.

OK, I picked up list_is_singular().

Thanks,

 include/linux/list.h |    4 ++--
 kernel/kprobes.c     |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

Index: 2.6.25-rc5-mm1/include/linux/list.h
===================================================================
--- 2.6.25-rc5-mm1.orig/include/linux/list.h
+++ 2.6.25-rc5-mm1/include/linux/list.h
@@ -212,10 +212,10 @@ static inline int list_empty_careful(con
 }

 /**
- * list_singleton - tests whether a list has just one entry.
+ * list_is_singular - tests whether a list has just one entry.
  * @head: the list to test.
  */
-static inline int list_singleton(const struct list_head *head)
+static inline int list_is_singular(const struct list_head *head)
 {
 	return !list_empty(head) && (head->next == head->prev);
 }
Index: 2.6.25-rc5-mm1/kernel/kprobes.c
===================================================================
--- 2.6.25-rc5-mm1.orig/kernel/kprobes.c
+++ 2.6.25-rc5-mm1/kernel/kprobes.c
@@ -643,7 +643,7 @@ static int __kprobes __unregister_kprobe
 valid_p:
 	if (old_p == p ||
 	    (old_p->pre_handler == aggr_pre_handler &&
-	     list_singleton(&old_p->list))) {
+	     list_is_singular(&old_p->list))) {
 		/*
 		 * Only probe on the hash list. Disarm only if kprobes are
 		 * enabled - otherwise, the breakpoint would already have
@@ -679,7 +679,7 @@ static void __kprobes __unregister_kprob
 			module_put(mod);
 	}

-	if (list_empty(&p->list) || list_singleton(&p->list)) {
+	if (list_empty(&p->list) || list_is_singular(&p->list)) {
 		if (!list_empty(&p->list)) {
 			/* "p" is the last child of an aggr_kprobe */
 			old_p = list_entry(p->list.next, struct kprobe, list);


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

