Return-Path: <linux-kernel-owner+w=401wt.eu-S1753106AbYGEFl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbYGEFl4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 01:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbYGEFlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 01:41:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64584 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbYGEFlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 01:41:22 -0400
Message-ID: <486F0918.5090707@cn.fujitsu.com>
Date: Sat, 05 Jul 2008 13:39:36 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serue@us.ibm.com>,
       Pavel Emelianov <xemul@openvz.org>
Subject: [PATCH 1/2] devcgroup: always show unsigned major/minor num
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 # echo "b $((0x7fffffff)):$((0x80000000)) rwm" > devices.allow
 # cat devices.list
 b 214748364:-21474836 rwm

though a major/minor number of 0x800000000 is meaningless, we
should not cast it to a negative value.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 security/device_cgroup.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index fd764a0..1e2e28a 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -222,7 +222,7 @@ static void devcgroup_destroy(struct cgroup_subsys *ss,
 #define DEVCG_DENY 2
 #define DEVCG_LIST 3
 
-#define MAJMINLEN 10
+#define MAJMINLEN 13
 #define ACCLEN 4
 
 static void set_access(char *acc, short access)
@@ -254,7 +254,7 @@ static void set_majmin(char *str, unsigned m)
 	if (m == ~0)
 		sprintf(str, "*");
 	else
-		snprintf(str, MAJMINLEN, "%d", m);
+		snprintf(str, MAJMINLEN, "%u", m);
 }
 
 static int devcgroup_seq_read(struct cgroup *cgroup, struct cftype *cft,
-- 
1.5.4.rc3
