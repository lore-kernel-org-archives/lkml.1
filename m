Return-Path: <linux-kernel-owner+w=401wt.eu-S1753780AbZD2J4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbZD2J4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 05:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbZD2J4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 05:56:22 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:42244 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbZD2J4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 05:56:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:user-agent;
        b=uXYmcHB7Z9T6oO1s0WL+oahSbVZK2Yo3hPB32gNx5yloKht2dP+mTcZ8kbfXdwunYv
         v+9/iRQ1ubvewNHqnwBUhh4apD/4G9iKNOds8yF7p1AHAHYawSVNv+Fx+/CDXFu43mc8
         vr/w7ogkAo9TdWF3voHnmnhZAed+J32ucCyPY=
Date: Wed, 29 Apr 2009 17:54:38 +0800
From: Zhenwen Xu <helight.xu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, linux-audit@redhat.com
Subject: [PATCH] remove duplicated include <linux/audit.h>
Message-ID: <20090429095438.GA4072@helight>
Reply-To: Zhenwen Xu <helight.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 The <linux/audit.h> was included in kernel/audit.h, and 
kernel/audit.c, kernel/auditfilter.c, and kernel/auditsc.c
already include the file kernel/audit.h, so it's unnecessary
to include <linux/audit.h> again.


kernel/audit.c
	|
	--#include <linux/audit.h>  ---------------------
	|						|
	--#include "audit.h"				|--duplicated
			|				|
			--#include <linux/audit.h>-------

Signed-off-by: Zhenwen Xu <helight.xu@gmail.com>
---
 kernel/audit.c       |    2 --
 kernel/auditfilter.c |    2 +-
 kernel/auditsc.c     |    1 -
 3 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 9442c35..a04786e 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -49,8 +49,6 @@
 #include <linux/err.h>
 #include <linux/kthread.h>
 
-#include <linux/audit.h>
-
 #include <net/sock.h>
 #include <net/netlink.h>
 #include <linux/skbuff.h>
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index a6fe71f..b7e9fec 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -20,7 +20,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/audit.h>
 #include <linux/kthread.h>
 #include <linux/mutex.h>
 #include <linux/fs.h>
@@ -29,6 +28,7 @@
 #include <linux/sched.h>
 #include <linux/inotify.h>
 #include <linux/security.h>
+
 #include "audit.h"
 
 /*
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 7d6ac7c..efe06bf 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -52,7 +52,6 @@
 #include <linux/mount.h>
 #include <linux/socket.h>
 #include <linux/mqueue.h>
-#include <linux/audit.h>
 #include <linux/personality.h>
 #include <linux/time.h>
 #include <linux/netlink.h>
-- 
1.5.6.5

-- 
---------------------------------
Zhenwen Xu - Open and Free
Home Page:	http://zhwen.org
My Studio:	http://dim4.cn

----- End forwarded message -----

-- 
--------------------------------
http://zhwen.org - Open and Free
