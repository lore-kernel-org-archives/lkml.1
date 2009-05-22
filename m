Return-Path: <linux-kernel-owner+w=401wt.eu-S1755518AbZEVCZC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbZEVCZC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 22:25:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbZEVCYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 22:24:54 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:26475 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbZEVCYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 22:24:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:user-agent;
        b=IgSlRmptgqxQFb4O/v2siLqwIiTw8HhLPuuH50mgMQGwU2tVI+EhJF58HjgcueCerh
         OYEf8XuVQG44l51x+NWE7HIx7dXHYaz+GHDV3LxSN2gG2tEgqSyOKIXXQlb0gWkS14K4
         DRFuxOCg8YFaTuxc5YgLwXi80bbxTdhhBoSaA=
Date: Fri, 22 May 2009 10:22:41 +0800
From: Zhenwen Xu <helight.xu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, eparis@redhat.com
Subject: p used before making sure it is not NULL in kernel/auditsc.c
Message-ID: <20090522022241.GA3350@helight>
Reply-To: Zhenwen Xu <helight.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

p used before making sure it is not NULL in kernel/auditsc.c

here we should make sure the p is not NULL then use it.



Signed-off-by: Zhenwen Xu <helight.xu@gmail.com>
---
 kernel/auditsc.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 7d6ac7c..876fdd1 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -341,13 +341,14 @@ static int put_tree_ref(struct audit_context *ctx, struct audit_chunk *chunk)
 {
 	struct audit_tree_refs *p = ctx->trees;
 	int left = ctx->tree_count;
+
+	if (!p)
+		return 0;
 	if (likely(left)) {
 		p->c[--left] = chunk;
 		ctx->tree_count = left;
 		return 1;
 	}
-	if (!p)
-		return 0;
 	p = p->next;
 	if (p) {
 		p->c[30] = chunk;
-- 
1.5.6.5

-- 
--------------------------------
http://zhwen.org - Open and Free
