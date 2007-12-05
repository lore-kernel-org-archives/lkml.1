Return-Path: <linux-kernel-owner+w=401wt.eu-S1752802AbXLEPBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbXLEPBx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 10:01:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751704AbXLEPBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 10:01:43 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:51738 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbXLEPBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 10:01:42 -0500
Date: Wed, 5 Dec 2007 20:31:07 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Jan Blunck <jblunck@suse.de>, Erez Zadok <ezk@cs.sunysb.edu>,
       viro@zeniv.linux.org.uk, Christoph Hellwig <hch@lst.de>,
       Dave Hansen <haveblue@us.ibm.com>
Subject: [RFC PATCH 3/5] Add list_for_each_entry_reverse_from()
Message-ID: <20071205150107.GC13419@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20071205143718.GC2471@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071205143718.GC2471@in.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce list_for_each_entry_reverse_from() needed by a subsequent patch.

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 include/linux/list.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -562,6 +562,19 @@ static inline void list_splice_init_rcu(
 	     pos = list_entry(pos->member.next, typeof(*pos), member))
 
 /**
+ * list_for_each_entry_reverse_from - iterate backwards over list of given
+ * type from the current point
+ * @pos:	the type * to use as a loop cursor.
+ * @head:	the head for your list.
+ * @member:	the name of the list_struct within the struct.
+ *
+ * Iterate backwards over list of given type, continuing from current position.
+ */
+#define list_for_each_entry_reverse_from(pos, head, member)		\
+	for (; prefetch(pos->member.prev), &pos->member != (head);	\
+	     pos = list_entry(pos->member.prev, typeof(*pos), member))
+
+/**
  * list_for_each_entry_safe - iterate over list of given type safe against removal of list entry
  * @pos:	the type * to use as a loop cursor.
  * @n:		another type * to use as temporary storage
