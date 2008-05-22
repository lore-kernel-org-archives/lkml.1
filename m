Return-Path: <linux-kernel-owner+w=401wt.eu-S1756357AbYEVQwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357AbYEVQwF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 12:52:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758097AbYEVQvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 12:51:11 -0400
Received: from gv-out-0910.google.com ([216.239.58.185]:39907 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758075AbYEVQvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 12:51:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=RUAF0gIjLTpKH+JibXiw1p2pJoiygPNwUufA9F+dO6jybTw4KnLQev0l5g0a4iYtIUGtZLXZBJw6OQCVKKFfeMwrIGzz4g3+KyMsv9Il7pbe1PScXt3hxSHEQ0A6jLHhROi7tpZsPFNf2QzgWSahizqWsrt+6o91YEHuYAwKQtQ=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Johannes Weiner <hannes@saeurebad.de>
Subject: [PATCH] ERR_PTR: warn when ERR_PTR parameter is valid argument
Date: Thu, 22 May 2008 18:50:19 +0200
Message-Id: <1211475019-5596-2-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1211475019-5596-1-git-send-email-marcin.slusarz@gmail.com>
References: <1211475019-5596-1-git-send-email-marcin.slusarz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check at runtime whether error argument of ERR_PTR is valid.
It can catch bugs which possibly lead to oops or panic earlier.

Currently there are > 600 calls of ERR_PTR with non-constant argument.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Johannes Weiner <hannes@saeurebad.de>
---
 include/linux/err.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/err.h b/include/linux/err.h
index 4773ed3..f7e098e 100644
--- a/include/linux/err.h
+++ b/include/linux/err.h
@@ -3,6 +3,7 @@
 
 #include <linux/compiler.h>
 
+#include <asm/bug.h>
 #include <asm/errno.h>
 
 /*
@@ -22,6 +23,7 @@
 
 static inline void *__ERR_PTR(long error)
 {
+	WARN_ON(!VALID_ERR_PTR_ARG(error));
 	return (void *) error;
 }
 
-- 
1.5.4.5

