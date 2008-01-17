Return-Path: <linux-kernel-owner+w=401wt.eu-S1760671AbYAQWko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760671AbYAQWko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:40:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760107AbYAQWgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:36:41 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:36241 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760090AbYAQWgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:36:36 -0500
From: Mark Fasheh <mark.fasheh@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Sunil Mushran <sunil.mushran@oracle.com>
Subject: [PATCH 24/30] ocfs2: Update default cluster timeouts
Date: Thu, 17 Jan 2008 14:35:50 -0800
Message-Id: <1200609356-17788-25-git-send-email-mark.fasheh@oracle.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
References: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sunil Mushran <sunil.mushran@oracle.com>

Lots of people are having trouble with the default timeouts, which are too
low. These new values are derived from an informal survey taken on
ocfs2-users, as well as data from bug reports. This should reduce the amount
of cluster disconnects and subsequent fencing seen during normal workloads.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/cluster/heartbeat.h |    2 +-
 fs/ocfs2/cluster/tcp.h       |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.h b/fs/ocfs2/cluster/heartbeat.h
index 35397dd..e511339 100644
--- a/fs/ocfs2/cluster/heartbeat.h
+++ b/fs/ocfs2/cluster/heartbeat.h
@@ -35,7 +35,7 @@
 #define O2HB_LIVE_THRESHOLD	   2
 /* number of equal samples to be seen as dead */
 extern unsigned int o2hb_dead_threshold;
-#define O2HB_DEFAULT_DEAD_THRESHOLD	   7
+#define O2HB_DEFAULT_DEAD_THRESHOLD	   31
 /* Otherwise MAX_WRITE_TIMEOUT will be zero... */
 #define O2HB_MIN_DEAD_THRESHOLD	  2
 #define O2HB_MAX_WRITE_TIMEOUT_MS (O2HB_REGION_TIMEOUT_MS * (o2hb_dead_threshold - 1))
diff --git a/fs/ocfs2/cluster/tcp.h b/fs/ocfs2/cluster/tcp.h
index da880fc..f36f66a 100644
--- a/fs/ocfs2/cluster/tcp.h
+++ b/fs/ocfs2/cluster/tcp.h
@@ -60,8 +60,8 @@ typedef void (o2net_post_msg_handler_func)(int status, void *data,
 /* same as hb delay, we're waiting for another node to recognize our hb */
 #define O2NET_RECONNECT_DELAY_MS_DEFAULT	2000
 
-#define O2NET_KEEPALIVE_DELAY_MS_DEFAULT	5000
-#define O2NET_IDLE_TIMEOUT_MS_DEFAULT		10000
+#define O2NET_KEEPALIVE_DELAY_MS_DEFAULT	2000
+#define O2NET_IDLE_TIMEOUT_MS_DEFAULT		30000
 
 
 /* TODO: figure this out.... */
-- 
1.5.3.6

