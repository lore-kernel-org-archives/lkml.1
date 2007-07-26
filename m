Return-Path: <linux-kernel-owner+w=401wt.eu-S935439AbXGZQlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935439AbXGZQlJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 12:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934454AbXGZQfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:35:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43161 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934459AbXGZQfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:35:41 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] amd64: fix get_user() on bitwise
Cc: linux-kernel@vger.kernel.org, ak@suse.de
Message-Id: <E1IE6JP-0005Oy-R8@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Thu, 26 Jul 2007 17:35:39 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


We really need force-cast when converting to final result type;
unsigned long can be silently converted to integer types and
to pointers, but not to bitwise.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/asm-x86_64/uaccess.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-x86_64/uaccess.h b/include/asm-x86_64/uaccess.h
index 9df30b9..f4ce876 100644
--- a/include/asm-x86_64/uaccess.h
+++ b/include/asm-x86_64/uaccess.h
@@ -100,7 +100,7 @@ struct exception_table_entry
 	case 8:  __get_user_x(8,__ret_gu,__val_gu,ptr); break;		\
 	default: __get_user_bad(); break;				\
 	}								\
-	(x) = (typeof(*(ptr)))__val_gu;				\
+	(x) = (__force typeof(*(ptr)))__val_gu;				\
 	__ret_gu;							\
 })
 
@@ -192,7 +192,7 @@ struct __large_struct { unsigned long buf[100]; };
 	int __gu_err;						\
 	unsigned long __gu_val;					\
 	__get_user_size(__gu_val,(ptr),(size),__gu_err);	\
-	(x) = (typeof(*(ptr)))__gu_val;			\
+	(x) = (__force typeof(*(ptr)))__gu_val;			\
 	__gu_err;						\
 })
 
-- 
1.5.3.GIT


