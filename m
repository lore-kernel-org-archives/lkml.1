Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab0APNlH (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 08:41:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729Ab0APNkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 08:40:23 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:47789 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932187Ab0APNkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 08:40:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qOmVukQc/0J8Lp2lxSOahOgUBLh4+DA2UUQ9BrviNiT6Ah23AMjFrwI8CpNcHCKmfo
         Es4un9NNL0yc7OmfRbI4YFMsPQYB4heeOQkV/d8th2/ULUWuTzUyUaCRDJTloB1gLcaU
         QL27Ek/q6aNdg7oh0Jx6J0eLboCvgKoxc2uWk=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/4] list: Introduce list_rotate_left()
Date: Sat, 16 Jan 2010 14:40:07 +0100
Message-Id: <1263649209-4343-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1263649209-4343-1-git-send-regression-fweisbec@gmail.com>
References: <1263649209-4343-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bring a new list_rotate_left() helper that rotates a list to
the left. This is useful for codes that need to round roubin
elements which queue priority increases from tail to head.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
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

