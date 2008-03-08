Return-Path: <linux-kernel-owner+w=401wt.eu-S1757187AbYCHIRH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187AbYCHIRH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 03:17:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbYCHIQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 03:16:58 -0500
Received: from po-out-1718.google.com ([72.14.252.152]:16486 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbYCHIQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 03:16:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:message-id:to:cc:subject:from:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=aYy94tWs+2qxmjHZvj38fhkIcsjJhIiCpdCnJ3G5ZN8e0STVUWAnSZ0g75SF9F+4xhIVfhKL8OFUlG9mODHlZWKIY8YLEi+D1dw2gTB1DWJBOBx2m3k4/vMsjQJuhl0+WIv1t/vZH9NHuQ2d6DHIiiSZWQ6ahxEWQok0maJR4oE=
Date: Sat, 08 Mar 2008 16:11:05 +0800 (CST)
Message-Id: <20080308.161105.253167431.xiyou.wangcong@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "G. Vaughan" <gvaughan@jpl.nasa.gov>,
       Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Fix check after use in kernel/exit.c
From: WANG Cong <xiyou.wangcong@gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


mm_release won't check the mm_struct pointer, so it should
be checked before this call.

This patch was first posted here[1], and I don't know
why it was not accepted yet.

Thanks to "G. Vaughan" to remind me about this.

1. http://lkml.org/lkml/2007/11/15/520

Cc: Ingo Molnar <mingo@elte.hu>
Cc: "G. Vaughan" <gvaughan@jpl.nasa.gov>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
 kernel/exit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index cd20bf0..0cb9cce 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -582,9 +582,9 @@ static void exit_mm(struct task_struct * tsk)
 {
 	struct mm_struct *mm = tsk->mm;
 
-	mm_release(tsk, mm);
 	if (!mm)
 		return;
+	mm_release(tsk, mm);
 	/*
 	 * Serialize with any possible pending coredump.
 	 * We must hold mmap_sem around checking core_waiters
-- 
1.5.2.4

