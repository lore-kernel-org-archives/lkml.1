Return-Path: <linux-kernel-owner+w=401wt.eu-S1757938AbXLJVA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938AbXLJVA4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 16:00:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754573AbXLJVAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 16:00:47 -0500
Received: from gw.goop.org ([64.81.55.164]:49271 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956AbXLJVAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 16:00:46 -0500
Message-ID: <475DA8F9.10605@goop.org>
Date: Mon, 10 Dec 2007 13:00:41 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [PATCH] xen: relax signature check
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some versions of Xen 3.x set their magic number to "xen-3.[12]", so
relax the test to match them.

[ Linus: Please apply for 2.6.24. Thanks - J ]

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/x86/xen/enlighten.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

===================================================================
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1131,7 +1131,7 @@ asmlinkage void __init xen_start_kernel(
 	if (!xen_start_info)
 		return;
 
-	BUG_ON(memcmp(xen_start_info->magic, "xen-3.0", 7) != 0);
+	BUG_ON(memcmp(xen_start_info->magic, "xen-3", 5) != 0);
 
 	/* Install Xen paravirt ops */
 	pv_info = xen_info;


