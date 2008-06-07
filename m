Return-Path: <linux-kernel-owner+w=401wt.eu-S1763022AbYFGBTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763022AbYFGBTZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756607AbYFGBJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:09:27 -0400
Received: from sous-sol.org ([216.99.217.87]:42497 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759974AbYFGBJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:09:20 -0400
Message-Id: <20080607010611.618095964@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 18:02:37 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       maximilian attems <max@stro.at>
Subject: [patch 22/50] types.h: dont expose struct ustat to userspace
Content-Disposition: inline; filename=types.h-don-t-expose-struct-ustat-to-userspace.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: maximilian attems <max@stro.at>

upstream commit: 6c7c6afbb8c0e60d32a563cae7c6889211e9d9d8

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
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 include/linux/types.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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
