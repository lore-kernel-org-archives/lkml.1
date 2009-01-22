Return-Path: <linux-kernel-owner+w=401wt.eu-S1756902AbZAVUXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902AbZAVUXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 15:23:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbZAVUXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 15:23:34 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59408 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbZAVUXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 15:23:33 -0500
From: Jeff Layton <jlayton@redhat.com>
To: smfrench@gmail.com
Cc: linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org,
       joe@perches.org
Subject: [PATCH] cifs: use ipv6_addr_equal for address comparison
Date: Thu, 22 Jan 2009 15:23:21 -0500
Message-Id: <1232655801-11525-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/connect.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 2209be9..005df85 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -23,7 +23,6 @@
 #include <linux/string.h>
 #include <linux/list.h>
 #include <linux/wait.h>
-#include <linux/ipv6.h>
 #include <linux/pagemap.h>
 #include <linux/ctype.h>
 #include <linux/utsname.h>
@@ -35,6 +34,7 @@
 #include <linux/freezer.h>
 #include <asm/uaccess.h>
 #include <asm/processor.h>
+#include <net/ipv6.h>
 #include "cifspdu.h"
 #include "cifsglob.h"
 #include "cifsproto.h"
@@ -1379,8 +1379,8 @@ cifs_find_tcp_session(struct sockaddr_storage *addr)
 		     server->addr.sockAddr.sin_addr.s_addr))
 			continue;
 		else if (addr->ss_family == AF_INET6 &&
-			 memcmp(&server->addr.sockAddr6.sin6_addr,
-				&addr6->sin6_addr, sizeof(addr6->sin6_addr)))
+			 !ipv6_addr_equal(&server->addr.sockAddr6.sin6_addr,
+					  &addr6->sin6_addr))
 			continue;
 
 		++server->srv_count;
-- 
1.5.5.6

