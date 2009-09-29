Return-Path: <linux-kernel-owner+w=401wt.eu-S1752953AbZI2VkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbZI2VkX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 17:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbZI2VkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 17:40:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750AbZI2VkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 17:40:22 -0400
From: Josh Stone <jistone@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Josh Stone <jistone@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH] ext4: Add a stub for mpage_da_data in the trace header
Date: Tue, 29 Sep 2009 14:40:07 -0700
Message-Id: <1254260407-14276-1-git-send-email-jistone@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tracepoint ext4_da_write_pages has a struct mpage_da_data*
parameter, but that struct is only defined in fs/ext4/ext4.h.  This
patch adds a forward declaration for that struct, so this tracepoint
header can still be used by tools like SystemTap.

This is a continuation of the fix in commit 3661d286.

http://sourceware.org/bugzilla/show_bug.cgi?id=10703

Signed-off-by: Josh Stone <jistone@redhat.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
---
 include/trace/events/ext4.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index c1bd8f1..d502974 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -11,6 +11,7 @@ struct ext4_allocation_context;
 struct ext4_allocation_request;
 struct ext4_prealloc_space;
 struct ext4_inode_info;
+struct mpage_da_data;
 
 #define EXT4_I(inode) (container_of(inode, struct ext4_inode_info, vfs_inode))
 
-- 
1.6.2.5

