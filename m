Return-Path: <linux-kernel-owner+w=401wt.eu-S1754668AbYL2MU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbYL2MU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 07:20:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbYL2MUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 07:20:20 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:54936 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307AbYL2MUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 07:20:19 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH v2] linux/uio.h: cleanup for userspace
Date: Mon, 29 Dec 2008 07:20:17 -0500
Message-Id: <1230553217-985-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1230360582-6657-1-git-send-email-vapier@gentoo.org>
References: <1230360582-6657-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hide iov_shorten() behind __KERNEL__ since it's a prototype only.  Use the
__inline__ form for iov_length() since it's usable by userspace.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
v2
	- drop inline conversion stuff

 include/linux/uio.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index b7fe138..bd1661b 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -52,6 +52,8 @@ static inline size_t iov_length(const struct iovec *iov, unsigned long nr_segs)
 	return ret;
 }
 
+#ifdef __KERNEL__
 unsigned long iov_shorten(struct iovec *iov, unsigned long nr_segs, size_t to);
+#endif
 
 #endif
-- 
1.6.0.6

