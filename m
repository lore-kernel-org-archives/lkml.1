Return-Path: <linux-kernel-owner+w=401wt.eu-S1763246AbYENQIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763246AbYENQIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 12:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754900AbYENQI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 12:08:27 -0400
Received: from baikonur.stro.at ([213.239.196.228]:48428 "EHLO
	baikonur.stro.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbYENQI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 12:08:26 -0400
From: maximilian attems <max@stro.at>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       maximilian attems <max@stro.at>, stable@kernel.org
Subject: [PATCH] types.h: Don't expose struct ustat to userspace
Date: Wed, 14 May 2008 18:07:46 +0200
Message-Id: <1210781266-16032-1-git-send-email-max@stro.at>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<linux/types.h> can't be used together with <sys/ustat.h> because they
both define struct ustat:

    $ cat test.c
    #include <sys/ustat.h>
    #include <linux/types.h>
    $ gcc -c test.c
    In file included from test.c:2:
    /usr/include/linux/types.h:165: error: redefinition of 'struct ustat'

has been reported a while ago to debian, but seems to have been
lost in cat fighting: http://bugs.debian.org/429064

Signed-off-by: maximilian attems <max@stro.at>
Cc: stable@kernel.org
---
 include/linux/types.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/types.h b/include/linux/types.h
index 9dc2346..d4a9ce6 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -197,8 +197,6 @@ typedef u64 resource_size_t;
 typedef u32 resource_size_t;
 #endif
 
-#endif	/* __KERNEL__ */
-
 struct ustat {
 	__kernel_daddr_t	f_tfree;
 	__kernel_ino_t		f_tinode;
@@ -206,4 +204,6 @@ struct ustat {
 	char			f_fpack[6];
 };
 
+#endif	/* __KERNEL__ */
+
 #endif /* _LINUX_TYPES_H */
-- 
1.5.5.1

