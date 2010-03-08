Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab0CHO2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 09:28:52 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:63955 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178Ab0CHO2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 09:28:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=D3+G+TwuTp/vY9UftBOzhLJxUc37cFLVwK+T7i4ViuhTR9tf+r5cN6wxr0UbgaCYGa
         D/V1DdP5WGwD6aep2wsxBtXDe1xiUneeIwOlVCIsOOGz1lPK5Aei6Nwa1NZTn1ZdxfwA
         RpiIuvBvjYMDdoDjvliF54BJE9Qw4r8H/5ytw=
Date: Tue, 9 Mar 2010 06:27:42 +0800
From: wzt.wzt@gmail.com
To: linux-kernel@vger.kernel.org
Cc: linux-audit@redhat.com, eparis@redhat.com, faith@redhat.com
Subject: [PATCH] Kernel: Fix coding style in kernel/audit.c
Message-ID: <20100308222742.GB17489@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix coding style in kernel/audit.c

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 kernel/audit.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 5feed23..5164696 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -331,12 +331,12 @@ static int audit_set_backlog_limit(int limit, uid_t loginuid, u32 sessionid,
 static int audit_set_enabled(int state, uid_t loginuid, u32 sessionid, u32 sid)
 {
 	int rc;
+
 	if (state < AUDIT_OFF || state > AUDIT_LOCKED)
 		return -EINVAL;
 
 	rc =  audit_do_config_change("audit_enabled", &audit_enabled, state,
 				     loginuid, sessionid, sid);
-
 	if (!rc)
 		audit_ever_enabled |= !!state;
 
@@ -346,8 +346,8 @@ static int audit_set_enabled(int state, uid_t loginuid, u32 sessionid, u32 sid)
 static int audit_set_failure(int state, uid_t loginuid, u32 sessionid, u32 sid)
 {
 	if (state != AUDIT_FAIL_SILENT
-	    && state != AUDIT_FAIL_PRINTK
-	    && state != AUDIT_FAIL_PANIC)
+		&& state != AUDIT_FAIL_PRINTK
+		&& state != AUDIT_FAIL_PANIC)
 		return -EINVAL;
 
 	return audit_do_config_change("audit_failure", &audit_failure, state,
@@ -366,7 +366,7 @@ static int audit_set_failure(int state, uid_t loginuid, u32 sessionid, u32 sid)
 static void audit_hold_skb(struct sk_buff *skb)
 {
 	if (audit_default &&
-	    skb_queue_len(&audit_skb_hold_queue) < audit_backlog_limit)
+		skb_queue_len(&audit_skb_hold_queue) < audit_backlog_limit)
 		skb_queue_tail(&audit_skb_hold_queue, skb);
 	else
 		kfree_skb(skb);
@@ -1163,9 +1163,9 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
 				entries over the normal backlog limit */
 
 	while (audit_backlog_limit
-	       && skb_queue_len(&audit_skb_queue) > audit_backlog_limit + reserve) {
+		&& skb_queue_len(&audit_skb_queue) > audit_backlog_limit + reserve) {
 		if (gfp_mask & __GFP_WAIT && audit_backlog_wait_time
-		    && time_before(jiffies, timeout_start + audit_backlog_wait_time)) {
+			&& time_before(jiffies, timeout_start + audit_backlog_wait_time)) {
 
 			/* Wait for auditd to drain the queue a little */
 			DECLARE_WAITQUEUE(wait, current);
@@ -1173,7 +1173,7 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
 			add_wait_queue(&audit_backlog_wait, &wait);
 
 			if (audit_backlog_limit &&
-			    skb_queue_len(&audit_skb_queue) > audit_backlog_limit)
+				skb_queue_len(&audit_skb_queue) > audit_backlog_limit)
 				schedule_timeout(timeout_start + audit_backlog_wait_time - jiffies);
 
 			__set_current_state(TASK_RUNNING);
@@ -1316,18 +1316,18 @@ void audit_log_n_hex(struct audit_buffer *ab, const unsigned char *buf,
 	BUG_ON(!ab->skb);
 	skb = ab->skb;
 	avail = skb_tailroom(skb);
-	new_len = len<<1;
+	new_len = len << 1;
 	if (new_len >= avail) {
 		/* Round the buffer request up to the next multiple */
-		new_len = AUDIT_BUFSIZ*(((new_len-avail)/AUDIT_BUFSIZ) + 1);
+		new_len = AUDIT_BUFSIZ * (((new_len - avail) / AUDIT_BUFSIZ) + 1);
 		avail = audit_expand(ab, new_len);
 		if (!avail)
 			return;
 	}
 
 	ptr = skb_tail_pointer(skb);
-	for (i=0; i<len; i++) {
-		*ptr++ = hex[(buf[i] & 0xF0)>>4]; /* Upper nibble */
+	for (i = 0; i < len; i++) {
+		*ptr++ = hex[(buf[i] & 0xF0) >> 4]; /* Upper nibble */
 		*ptr++ = hex[buf[i] & 0x0F];	  /* Lower nibble */
 	}
 	*ptr = 0;
-- 
1.6.5.3

