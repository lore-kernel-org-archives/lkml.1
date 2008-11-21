Return-Path: <linux-kernel-owner+w=401wt.eu-S1756716AbYKUQIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716AbYKUQIY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 11:08:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754453AbYKUQHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 11:07:53 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47821 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754068AbYKUQHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 11:07:51 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FRV: Fix error handling in is_user_addr_valid()
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Fri, 21 Nov 2008 16:07:44 +0000
Message-ID: <20081121160744.17135.78532.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix error handling in is_user_addr_valid() in NOMMU mode to check whether
find_vma() actually worked or not.  This checks whether ptrace() is allowed to
access an address.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/kernel/ptrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/arch/frv/kernel/ptrace.c b/arch/frv/kernel/ptrace.c
index e9af8de..5e7d401 100644
--- a/arch/frv/kernel/ptrace.c
+++ b/arch/frv/kernel/ptrace.c
@@ -83,7 +83,7 @@ static inline int is_user_addr_valid(struct task_struct *child,
 	struct vm_area_struct *vma;
 
 	vma = find_vma(child->mm, start);
-	if (start >= vma->vm_start && start + len <= vma->vm_end)
+	if (vma && start >= vma->vm_start && start + len <= vma->vm_end)
 		return 0;
 
 	return -EIO;

