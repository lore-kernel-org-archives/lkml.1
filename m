Return-Path: <linux-kernel-owner+w=401wt.eu-S1759565AbZCBCOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759565AbZCBCOv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 21:14:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756255AbZCBCOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 21:14:39 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53576 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757251AbZCBCOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 21:14:38 -0500
Message-ID: <49AB4143.9050704@cn.fujitsu.com>
Date: Mon, 02 Mar 2009 10:15:31 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: [PATCH 3/4] devcgroup: show correct file mode
References: <49AB40BF.4030706@cn.fujitsu.com>
In-Reply-To: <49AB40BF.4030706@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devices.allow and devices.deny are write-only, and devices.list is read-only.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 security/device_cgroup.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index 3aacd0f..b13fbb8 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -439,16 +439,19 @@ static struct cftype dev_cgroup_files[] = {
 		.name = "allow",
 		.write_string  = devcgroup_access_write,
 		.private = DEVCG_ALLOW,
+		.mode = 0200,
 	},
 	{
 		.name = "deny",
 		.write_string = devcgroup_access_write,
 		.private = DEVCG_DENY,
+		.mode = 0200,
 	},
 	{
 		.name = "list",
 		.read_seq_string = devcgroup_seq_read,
 		.private = DEVCG_LIST,
+		.mode = 0444,
 	},
 };
 
-- 1.5.4.rc3 
