Return-Path: <linux-kernel-owner+w=401wt.eu-S1754664AbYIPMWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbYIPMWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 08:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751335AbYIPMWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 08:22:05 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:13112 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbYIPMWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 08:22:03 -0400
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: linux-kernel@vger.kernel.org
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
       Ulrich Drepper <drepper@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] linux/inotify.h: do not include <linux/fcntl.h> in userspace
Date: Tue, 16 Sep 2008 15:22:43 +0300
Message-Id: <1221567763-17060-1-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.5.6.5.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<linux/fcntl.h> conflicts with glibc's <fcntl.h>.

It breaks building kdelibs, kdepim and pinot. It's regression itroduced
by commit 4006553.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/inotify.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/inotify.h b/include/linux/inotify.h
index bd57857..792b6f0 100644
--- a/include/linux/inotify.h
+++ b/include/linux/inotify.h
@@ -7,8 +7,10 @@
 #ifndef _LINUX_INOTIFY_H
 #define _LINUX_INOTIFY_H
 
+#ifdef __KERNEL__
 /* For O_CLOEXEC and O_NONBLOCK */
 #include <linux/fcntl.h>
+#endif
 #include <linux/types.h>
 
 /*
-- 
1.5.6.5.GIT

