Return-Path: <linux-kernel-owner+w=401wt.eu-S1756877AbYGHBw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877AbYGHBw5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 21:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754964AbYGHBwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 21:52:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60333 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754896AbYGHBws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 21:52:48 -0400
Message-ID: <4872C80A.2000007@cn.fujitsu.com>
Date: Tue, 08 Jul 2008 09:51:06 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serue@us.ibm.com>,
       Paul Menage <menage@google.com>, Pavel Emelianov <xemul@openvz.org>
Subject: [PATCH 1/3] devcgroup: always show positive major/minor num
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
Acked-by: Serge Hallyn <serue@us.ibm.com>
---

No change for the first 2 patches, should these go into 2.6.26 ?
Applied Paul M's comments to the 3rd one.

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


