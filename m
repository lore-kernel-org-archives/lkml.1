Return-Path: <linux-kernel-owner+w=401wt.eu-S1754502Ab0AJBjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab0AJBjU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 20:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352Ab0AJBib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 20:38:31 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:51524 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296Ab0AJBi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 20:38:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HJsU5x1WPpkMHcgJ2e5PSU6CpXT0V+RXRprei1pAWaqVIAkZCzCRmhcUIzxIQ7xKJr
         cLWfBIfRvWh4gZGvXZjE5vuDqPmnvVTAicqPl6E+FC2VUmYaLCXD1McJhw221nv2whzl
         gCBMJJt9PmhohAn9+B9Ozfeoec9F2uy3muIFo=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/6] list: Introduce list_rotate_left()
Date: Sun, 10 Jan 2010 02:38:16 +0100
Message-Id: <1263087500-14215-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1263087500-14215-1-git-send-regression-fweisbec@gmail.com>
References: <1263087500-14215-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bring a new list_rotate_left() helper that rotates a list to
the left. This is useful for codes that need to round roubin
elements which queue priority increases from tail to head.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
---
 include/linux/list.h |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/linux/list.h b/include/linux/list.h
index 969f6e9..5d9c655 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -206,6 +206,20 @@ static inline int list_empty_careful(const struct list_head *head)
 }
 
 /**
+ * list_rotate_left - rotate the list to the left
+ * @head: the head of the list
+ */
+static inline void list_rotate_left(struct list_head *head)
+{
+	struct list_head *first;
+
+	if (!list_empty(head)) {
+		first = head->next;
+		list_move_tail(first, head);
+	}
+}
+
+/**
  * list_is_singular - tests whether a list has just one entry.
  * @head: the list to test.
  */
-- 
1.6.2.3

