Return-Path: <linux-kernel-owner+w=401wt.eu-S1757387AbYGNKy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387AbYGNKy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 06:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475AbYGNKyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 06:54:49 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48547 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbYGNKyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 06:54:49 -0400
Date: Mon, 14 Jul 2008 19:54:35 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [mmotm] kill devcgroup-code-cleanup.patch warning 
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20080714185856.F6DA.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch titile: devcgroup-code-cleanup-fix-fix.patch
Patch against: mmotm Jul 13
Applies after: devcgroup-code-cleanup-fix.patch

devcgroup-code-cleanup.patch made following warnings because b is const.

  security/device_cgroup.c: In function 'devcgroup_update_access':
  security/device_cgroup.c:397: warning: passing argument 2 of 'simple_strtoul' from incompatible pointer type
  security/device_cgroup.c:410: warning: passing argument 2 of 'simple_strtoul' from incompatible pointer type

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Li Zefan <lizf@cn.fujitsu.com>

---
 security/device_cgroup.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: b/security/device_cgroup.c
===================================================================
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -359,6 +359,7 @@ static int devcgroup_update_access(struc
 {
 	struct dev_cgroup *cur_devcgroup;
 	const char *b;
+	char *endp;
 	int retval = 0, count;
 	struct dev_whitelist_item wh;
 
@@ -394,7 +395,8 @@ static int devcgroup_update_access(struc
 		wh.major = ~0;
 		b++;
 	} else if (isdigit(*b)) {
-		wh.major = simple_strtoul(b, &b, 10);
+		wh.major = simple_strtoul(b, &endp, 10);
+		b = endp;
 	} else {
 		return -EINVAL;
 	}
@@ -407,7 +409,8 @@ static int devcgroup_update_access(struc
 		wh.minor = ~0;
 		b++;
 	} else if (isdigit(*b)) {
-		wh.minor = simple_strtoul(b, &b, 10);
+		wh.minor = simple_strtoul(b, &endp, 10);
+		b = endp;
 	} else {
 		return -EINVAL;
 	}


