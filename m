Return-Path: <linux-kernel-owner+w=401wt.eu-S1759360AbYERWFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759360AbYERWFU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 18:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbYERWFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 18:05:05 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:59139 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914AbYERWFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 18:05:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=TY1SPXYfWLUDMUqG6t6UitSYbRKeDGQBUg8KlG+es5vFnvfnSgd/OhUwpegt9s80WGkeLByw5EFETMR2Se8LJRlSmEFYQ5HGE8en+/5MzE6UNrWANL9pxAteiIR9o65dUFEPm+ekahreJyC7AoBIIIg3CdhXEBBQP3hgcUzOrT0=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/6] ERR_PTR: warn when ERR_PTR parameter is not errno value
Date: Mon, 19 May 2008 00:04:33 +0200
Message-Id: <1211148273-16226-1-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <20080513201813.GA5869@joi>
References: <20080513201813.GA5869@joi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check at runtime whether error argument of ERR_PTR and ERR_OR_0_PTR
is valid. It can catch bugs which possibly lead to oops or panic earlier.

Currently there are > 600 calls of ERR_PTR with non-constant argument
in Linux kernel sources.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/err.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/err.h b/include/linux/err.h
index cdec8b6..51e2459 100644
--- a/include/linux/err.h
+++ b/include/linux/err.h
@@ -3,6 +3,7 @@
 
 #include <linux/compiler.h>
 
+#include <asm/bug.h>
 #include <asm/errno.h>
 
 /*
@@ -21,6 +22,7 @@
 
 static inline void *__ERR_PTR(long error)
 {
+	WARN_ON(!IS_ERR_VALUE(error));
 	return (void *) error;
 }
 
@@ -28,6 +30,7 @@ static inline void *__ERR_PTR(long error)
 
 static inline void *__ERR_OR_0_PTR(long error)
 {
+	WARN_ON(!IS_ERR_VALUE(error) && error);
 	return (void *) error;
 }
 
-- 
1.5.4.5

