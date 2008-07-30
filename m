Return-Path: <linux-kernel-owner+w=401wt.eu-S1755758AbYG3DnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758AbYG3DnK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 23:43:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbYG3Dm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 23:42:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64914 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbYG3Dmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 23:42:55 -0400
Message-ID: <488FE2B9.2040101@cn.fujitsu.com>
Date: Wed, 30 Jul 2008 11:40:41 +0800
From: zhangxiliang <zhangxiliang@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: sgrubb@redhat.com, viro@zeniv.linux.org.uk, eparis@redhat.com,
       Linux Audit <linux-audit@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] the loginuid field should be output in all AUDIT_CONFIG_CHANGE
 audit messages
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the audit message which type is "AUDIT_CONFIG_CHANGE", the output format should contain "auid" field.

Signed-off-by: Zhang Xiliang <zhangxiliang@cn.fujitsu.com>
---
 kernel/auditfilter.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 98c50cc..8a184f5 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -1022,8 +1022,9 @@ static void audit_update_watch(struct audit_parent *parent,
 			struct audit_buffer *ab;
 			ab = audit_log_start(NULL, GFP_KERNEL,
 				AUDIT_CONFIG_CHANGE);
+			audit_log_format(ab, "auid=%u", current->loginuid);
 			audit_log_format(ab,
-				"op=updated rules specifying path=");
+				" op=updated rules specifying path=");
 			audit_log_untrustedstring(ab, owatch->path);
 			audit_log_format(ab, " with dev=%u ino=%lu\n",
 				 dev, ino);
@@ -1058,7 +1059,8 @@ static void audit_remove_parent_watches(struct audit_parent *parent)
 				struct audit_buffer *ab;
 				ab = audit_log_start(NULL, GFP_KERNEL,
 					AUDIT_CONFIG_CHANGE);
-				audit_log_format(ab, "op=remove rule path=");
+				audit_log_format(ab, "auid=%u", current->loginuid);
+				audit_log_format(ab, " op=remove rule path=");
 				audit_log_untrustedstring(ab, w->path);
 				if (r->filterkey) {
 					audit_log_format(ab, " key=");
-- 
1.5.4.2


-- 
Regards
Zhang Xiliang


