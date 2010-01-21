Return-Path: <linux-kernel-owner+w=401wt.eu-S1751781Ab0AUFRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781Ab0AUFRd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 00:17:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556Ab0AUFRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 00:17:32 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:52785 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab0AUFRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 00:17:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=ac16gVEa1SoYhI78W1t/QDLq3cnjO83J4lQDKmFZGLqQe1uv8dFQcRxwuawvTyU/x+
         HcdXWlYJcmIbcbxs7KWthNp41JhiYF5lHd4YDlEe8p8ssuOgA7UC9nM7RcSfENyUDRit
         UTH397/q8UmvoSxvvrwr14BY4CSiJ7+V3cHnE=
From: Don Mullis <don.mullis@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: airlied@redhat.com, andi@firstfloor.org, david@fromorbit.com,
       dedekind@infradead.org
Subject: [PATCH 2/2] lib: revise list_sort() comment 
References: <87fx609i29.fsf@gmail.com>
Date: Wed, 20 Jan 2010 21:17:27 -0800
In-Reply-To: <87fx609i29.fsf@gmail.com> (Don Mullis's message of "Wed, 20 Jan
	2010 20:51:26 -0800")
Message-ID: <877hrc9guw.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clarify and correct header comment of list_sort().

Signed-off-by: Don Mullis <don.mullis@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Artem Bityutskiy <dedekind@infradead.org>
---
 lib/list_sort.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

Index: linux-2.6/lib/list_sort.c
===================================================================
--- linux-2.6.orig/lib/list_sort.c	2010-01-19 22:26:03.000000000 -0800
+++ linux-2.6/lib/list_sort.c	2010-01-19 22:28:19.000000000 -0800
@@ -38,17 +38,19 @@ static void restore_back_links(struct li
 }
 
 /**
- * list_sort - sort a list.
- * @priv: private data, passed to @cmp
+ * list_sort - sort a list
+ * @priv: private data, opaque to list_sort(), passed to @cmp
  * @head: the list to sort
  * @cmp: the elements comparison function
  *
- * This function implements "merge sort" which has O(nlog(n)) complexity.
- * The list is sorted in ascending order.
+ * This function implements "merge sort", which has O(nlog(n))
+ * complexity.
  *
- * The comparison function @cmp is supposed to return a negative value if @a is
- * less than @b, and a positive value if @a is greater than @b. If @a and @b
- * are equivalent, then it does not matter what this function returns.
+ * The comparison function @cmp must return a negative value if @a
+ * should sort before @b, and a positive value if @a should sort after
+ * @b. If @a and @b are equivalent, and their original relative
+ * ordering is to be preserved, @cmp should return 0; otherwise, the
+ * return value does not matter.
  */
 void list_sort(void *priv, struct list_head *head,
 		int (*cmp)(void *priv, struct list_head *a,
