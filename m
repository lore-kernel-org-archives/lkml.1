Return-Path: <linux-kernel-owner+w=401wt.eu-S1758706AbYERWBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706AbYERWBt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 18:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbYERWBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 18:01:41 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:49709 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbYERWBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 18:01:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YtHw8DAH4Llw8cjc1D1LZ66ZvwCbe2e/b69d3j4kAZiDYKYCccJHZYmVKktgFN7e473LyfGgOL8vcJ5GPhI7tYiJLnKoe66EgOikTsrIW4vIR1hyboCJQzx9tr6/RrNNJbFcPlwVaTwNSbT+VtRZWin7rgMilK8zxj/RlTk15VI=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/6] ERR_PTR: add ERR_OR_0_PTR
Date: Mon, 19 May 2008 00:01:07 +0200
Message-Id: <1211148067-16130-1-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <20080513201813.GA5869@joi>
References: <20080513201813.GA5869@joi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some codepaths call ERR_PTR with possibly 0 argument, which is not
a valid errno and rely on conversion from 0 to NULL pointer.
Add ERR_OR_0_PTR function which accepts errnos and 0 as an argument.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/err.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/err.h b/include/linux/err.h
index 7b5daa6..cdec8b6 100644
--- a/include/linux/err.h
+++ b/include/linux/err.h
@@ -26,6 +26,13 @@ static inline void *__ERR_PTR(long error)
 
 #define ERR_PTR(error) (BUILD_BUG_ON(__builtin_constant_p(error) && !IS_ERR_VALUE(error)), __ERR_PTR(error))
 
+static inline void *__ERR_OR_0_PTR(long error)
+{
+	return (void *) error;
+}
+
+#define ERR_OR_0_PTR(error) (BUILD_BUG_ON(__builtin_constant_p(error) && error && !IS_ERR_VALUE(error)), __ERR_OR_0_PTR(error))
+
 static inline long PTR_ERR(const void *ptr)
 {
 	return (long) ptr;
-- 
1.5.4.5

