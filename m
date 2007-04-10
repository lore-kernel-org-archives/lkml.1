Return-Path: <linux-kernel-owner+w=401wt.eu-S1753678AbXDJAIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678AbXDJAIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 20:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753679AbXDJAI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 20:08:29 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:53677 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753678AbXDJAI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 20:08:28 -0400
Date: Mon, 9 Apr 2007 17:06:02 -0700
Message-Id: <200704100006.l3A062AL020596@zach-dev.vmware.com>
Subject: [PATCH 1/10] I386 sysenter arch pages fix.patch
From: Zachary Amsden <zach@vmware.com>
To: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>
X-OriginalArrivalTime: 10 Apr 2007 00:08:28.0050 (UTC) FILETIME=[5D678720:01C77B04]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In compat mode, the return value here was uninitialized.

Signed-off-by: Zachary Amsden <zach@vmware.com>

diff -r 1fda49a076ed arch/i386/kernel/sysenter.c
--- a/arch/i386/kernel/sysenter.c	Fri Apr 06 14:25:09 2007 -0700
+++ b/arch/i386/kernel/sysenter.c	Fri Apr 06 14:27:31 2007 -0700
@@ -254,7 +254,7 @@ int arch_setup_additional_pages(struct l
 {
 	struct mm_struct *mm = current->mm;
 	unsigned long addr;
-	int ret;
+	int ret = 0;
 	bool compat;
 
 	down_write(&mm->mmap_sem);
