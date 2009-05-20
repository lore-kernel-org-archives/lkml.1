Return-Path: <linux-kernel-owner+w=401wt.eu-S1756798AbZETSul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798AbZETSul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 14:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755578AbZETSuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 14:50:32 -0400
Received: from oblivion.subreption.com ([66.240.236.22]:51579 "EHLO
	mail.subreption.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338AbZETSub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 14:50:31 -0400
Date: Wed, 20 May 2009 11:50:05 -0700
From: "Larry H." <research@subreption.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, pageexec@freemail.hu, faith@redhat.com
Subject: [patch 3/5] Apply the PG_sensitive flag to audit subsystem
Message-ID: <20090520185005.GC10756@oblivion.subreption.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Subreption LLC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch deploys the use of the PG_sensitive page allocator flag
within the audit subsystem. It's not necessarily a high profile
target for use of this flag, but could be expected to contain
potentially sensitive information under some circumstances.

Signed-off-by: Larry H. <research@subreption.com>

---
 kernel/audit.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6/kernel/audit.c
===================================================================
--- linux-2.6.orig/kernel/audit.c
+++ linux-2.6/kernel/audit.c
@@ -1061,6 +1061,9 @@ static struct audit_buffer * audit_buffe
 	}
 	spin_unlock_irqrestore(&audit_freelist_lock, flags);
 
+	if (!(gfp_mask & GFP_SENSITIVE))
+		gfp_mask |= GFP_SENSITIVE;
+
 	if (!ab) {
 		ab = kmalloc(sizeof(*ab), gfp_mask);
 		if (!ab)
