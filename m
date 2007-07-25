Return-Path: <linux-kernel-owner+w=401wt.eu-S1764525AbXGYMRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764525AbXGYMRw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 08:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbXGYMRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 08:17:45 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:34728 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696AbXGYMRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 08:17:44 -0400
Date: Wed, 25 Jul 2007 15:17:43 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: linuxppc-dev@ozlabs.org, Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix ppc kernels after build-id addition
Message-ID: <Pine.SOC.4.64.0707251301200.21641@math.ut.ee>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes arch/ppc kernels, at least for prep subarch, after 
build-id addition. Without the patch, kernels were 3 times the size and 
bootloader refused to load them. Now they are back to normal again.
The patch is very similar to David Millers sparc patch, just applied to 
ppc architecture.

Tested only with Roland McGrath's "Use LDFLAGS_MODULE only for .ko 
links" patch applied - boots and works fine.

Signed-off-by: Meelis Roos <mroos@linux.ee>

diff --git a/arch/ppc/kernel/vmlinux.lds.S b/arch/ppc/kernel/vmlinux.lds.S
index c0aac3f..98c1212 100644
--- a/arch/ppc/kernel/vmlinux.lds.S
+++ b/arch/ppc/kernel/vmlinux.lds.S
@@ -91,6 +91,8 @@ SECTIONS
   . = ALIGN(8192);
   .data.init_task : { *(.data.init_task) }
 
+  NOTES
+
   . = ALIGN(4096);
   __init_begin = .;
   .init.text : {

-- 
Meelis Roos (mroos@linux.ee)
