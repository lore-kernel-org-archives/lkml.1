Return-Path: <linux-kernel-owner+w=401wt.eu-S1754320AbZIWHT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbZIWHT7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 03:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754268AbZIWHT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 03:19:58 -0400
Received: from poutre.nerim.net ([62.4.16.124]:58983 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754226AbZIWHT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 03:19:57 -0400
Date: Wed, 23 Sep 2009 09:19:58 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, Vegard Nossum <vegard.nossum@gmail.com>,
       Eric B Munson <ebmunson@us.ibm.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Dave Airlie <airlied@linux.ie>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: v2.6.31-7381-g7fa0772: new build warnings: kmemcheck,
 __deprecated, hugetlb, radeon
Message-ID: <20090923091958.6a0f9d58@hyperion.delvare>
In-Reply-To: <4AB8FC88.8020608@s5r6.in-berlin.de>
References: <4AB8FC88.8020608@s5r6.in-berlin.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan,

On Tue, 22 Sep 2009 18:34:16 +0200, Stefan Richter wrote:
> Latest git compiles with extreme noise:
> 
> In file included from include/net/inet_connection_sock.h:23,
>                   from include/linux/tcp.h:178,
>                   from include/linux/ipv6.h:215,
>                   from include/net/ipv6.h:16,
>                   from include/linux/sunrpc/clnt.h:25,
>                   from include/linux/nfs_fs.h:52,
>                   from kernel/sysctl.c:48:
> include/net/inet_sock.h: In function 'inet_reqsk_alloc':
> include/net/inet_sock.h:208: warning: ISO C90 forbids mixed declarations 
> and code
> 
> Vegard, this is obviously caused by commit 
> 45e3ff82708c65c895d5c5882aff17ecf62a80b5.

Actually not, it's caused by commit
181f7c5dd3832763bdf2756b6d2d8a49bdf12791
(kmemcheck: add missing braces to do-while in kmemcheck_annotate_bitfield)

And the fix would be:

From: Jean Delvare <khali@linux-fr.org>
Subject: Fix build warning in kmemcheck_annotate_bitfield

Fix the following build warning:

include/net/inet_sock.h: In function 'inet_reqsk_alloc':
include/net/inet_sock.h:208: warning: ISO C90 forbids mixed declarations 
and code

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 include/linux/kmemcheck.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- linux-2.6.32-pre.orig/include/linux/kmemcheck.h	2009-09-23 08:19:34.000000000 +0200
+++ linux-2.6.32-pre/include/linux/kmemcheck.h	2009-09-23 09:05:30.000000000 +0200
@@ -145,10 +145,12 @@ static inline bool kmemcheck_is_obj_init
 
 #define kmemcheck_annotate_bitfield(ptr, name)				\
 	do {								\
+		int _n;							\
+									\
 		if (!ptr)						\
 			break;						\
 									\
-		int _n = (long) &((ptr)->name##_end)			\
+		_n = (long) &((ptr)->name##_end)			\
 			- (long) &((ptr)->name##_begin);		\
 		BUILD_BUG_ON(_n < 0);					\
 									\

-- 
Jean Delvare
