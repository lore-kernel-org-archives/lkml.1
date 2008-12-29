Return-Path: <linux-kernel-owner+w=401wt.eu-S1755437AbYL2NAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbYL2NAk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 08:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753609AbYL2NAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 08:00:05 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:40652 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753492AbYL2NAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 08:00:03 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH v3] linux/uio.h: cleanup for userspace
Date: Mon, 29 Dec 2008 07:59:59 -0500
Message-Id: <1230555599-23568-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <20081229125609.GB1852@uranus.ravnborg.org>
References: <20081229125609.GB1852@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hide iov_shorten() behind __KERNEL__ since it's a prototype only.  Use the
__inline__ form for iov_length() since it's usable by userspace.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
v3
	- keep all __KERNEL__ stuff in one place
v2
	- drop inline conversion stuff

 include/linux/uio.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index b7fe138..3debd89 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -26,6 +26,8 @@ struct kvec {
 	size_t iov_len;
 };
 
+unsigned long iov_shorten(struct iovec *iov, unsigned long nr_segs, size_t to);
+
 #endif
 
 /*
@@ -52,6 +54,4 @@ static inline size_t iov_length(const struct iovec *iov, unsigned long nr_segs)
 	return ret;
 }
 
-unsigned long iov_shorten(struct iovec *iov, unsigned long nr_segs, size_t to);
-
 #endif
-- 
1.6.0.6

