Return-Path: <linux-kernel-owner+w=401wt.eu-S964785AbXCZK1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964785AbXCZK1Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 06:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753623AbXCZK1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 06:27:25 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:5489 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616AbXCZK1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 06:27:24 -0400
X-IronPort-AV: i="4.14,329,1170651600"; 
   d="scan'208"; a="25491099:sNHT20836081"
Subject: [PATCH -mm]  vdso print fatal signals: fix compiling error bug in
	nommu arch
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: mingo@elte.hu, arjan@infradead.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Mon, 26 Mar 2007 18:27:56 +0800
Message-Id: <1174904876.32691.90.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

As struct mm_struct vm_mm is hidden in struct vm_area_struct in NOMMU
arch, this is a fixing method when compiling failure on blackfin arch.

Signed-off-by: Bryan Wu <bryan.wu@analog.com> 
---

 kernel/signal.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6/kernel/signal.c
===================================================================
--- linux-2.6.orig/kernel/signal.c
+++ linux-2.6/kernel/signal.c
@@ -807,7 +807,11 @@
 
 static int print_vma(struct vm_area_struct *vma)
 {
+#ifdef CONFIG_MMU
 	struct mm_struct *mm = vma->vm_mm;
+#else
+	struct mm_struct *mm = 0;
+#endif
 	struct file *file = vma->vm_file;
 	int flags = vma->vm_flags;
 	unsigned long ino = 0;
_

Thanks,
-Bryan Wu
