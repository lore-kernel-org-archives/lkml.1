Return-Path: <linux-kernel-owner+w=401wt.eu-S1763542AbYETBMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763542AbYETBMo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 21:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbYETBMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 21:12:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64240 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbYETBMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 21:12:34 -0400
Message-ID: <4832259E.8070105@cn.fujitsu.com>
Date: Tue, 20 May 2008 09:13:02 +0800
From: Peng Haitao <penght@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: sgrubb@redhat.com
CC: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] remove useless argument type in audit_filter_user()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The second argument "type" is not used in audit_filter_user(), so I think that type can be removed. If I'm wrong, please tell me.

Signed-off-by: Peng Haitao <penght@cn.fujitsu.com>
---
 include/linux/audit.h |    2 +-
 kernel/audit.c        |    2 +-
 kernel/auditfilter.c  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 2af9ec0..018f143 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -537,7 +537,7 @@ extern void		    audit_log_d_path(struct audit_buffer *ab,
 					     struct path *path);
 extern void		    audit_log_lost(const char *message);
 				/* Private API (for audit.c only) */
-extern int audit_filter_user(struct netlink_skb_parms *cb, int type);
+extern int audit_filter_user(struct netlink_skb_parms *cb);
 extern int audit_filter_type(int type);
 extern int  audit_receive_filter(int type, int pid, int uid, int seq,
 			 void *data, size_t datasz, uid_t loginuid, u32 sid);
diff --git a/kernel/audit.c b/kernel/audit.c
index b782b04..136e559 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -645,7 +645,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		if (!audit_enabled && msg_type != AUDIT_USER_AVC)
 			return 0;
 
-		err = audit_filter_user(&NETLINK_CB(skb), msg_type);
+		err = audit_filter_user(&NETLINK_CB(skb));
 		if (err == 1) {
 			err = 0;
 			if (msg_type == AUDIT_USER_TTY) {
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 2f2914b..46337f2 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -1714,7 +1714,7 @@ static int audit_filter_user_rules(struct netlink_skb_parms *cb,
 	return 1;
 }
 
-int audit_filter_user(struct netlink_skb_parms *cb, int type)
+int audit_filter_user(struct netlink_skb_parms *cb)
 {
 	enum audit_state state = AUDIT_DISABLED;
 	struct audit_entry *e;
-- 
1.5.3

-- 
Regards
Peng Haitao

