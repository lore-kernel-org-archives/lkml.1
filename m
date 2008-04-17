Return-Path: <linux-kernel-owner+w=401wt.eu-S1763719AbYDQJLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763719AbYDQJLg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756900AbYDQJKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:10:54 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:58867
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756187AbYDQJKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:10:51 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Carsten Otte <cotte@de.ibm.com>
Subject: [PATCH 01/45] s390: fixup for kvm
Date: Thu, 17 Apr 2008 12:10:06 +0300
Message-Id: <1208423450-29415-2-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208423450-29415-1-git-send-email-avi@qumranet.com>
References: <1208423450-29415-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carsten Otte <cotte@de.ibm.com>

Temporary commit, should appear in mainline shortly.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/s390/lib/uaccess_pt.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/s390/lib/uaccess_pt.c b/arch/s390/lib/uaccess_pt.c
index 5efdfe9..d68b2ee 100644
--- a/arch/s390/lib/uaccess_pt.c
+++ b/arch/s390/lib/uaccess_pt.c
@@ -365,6 +365,9 @@ int futex_atomic_op_pt(int op, int __user *uaddr, int oparg, int *old)
 {
 	int oldval = 0, newval, ret;
 
+	if (!current->mm)
+		return -EFAULT;
+
 	spin_lock(&current->mm->page_table_lock);
 	uaddr = (int __user *) __dat_user_addr((unsigned long) uaddr);
 	if (!uaddr) {
-- 
1.5.5

