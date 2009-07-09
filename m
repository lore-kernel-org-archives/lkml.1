Return-Path: <linux-kernel-owner+w=401wt.eu-S1759387AbZGIIHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759387AbZGIIHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 04:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759018AbZGIIG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 04:06:57 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:43107 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758629AbZGIIGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 04:06:54 -0400
Message-ID: <4A55A4AE.3000206@mxs.nes.nec.co.jp>
Date: Thu, 09 Jul 2009 17:05:02 +0900
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: kexec-ml <kexec@lists.infradead.org>
Subject: [PATCH] kdump: Enable kdump if 2nd-kernel is loaded.
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

This patch enables a kdump if 2nd-kernel is loaded.
(The patch is based on linux-2.6.31-rc2.)

Now, a kdump is enabled if a kernel parameter "oops=panic" is specified and
2nd-kernel is loaded. I think that a kdump should be enabled regardless of
"oops=panic" if 2nd-kernel is loaded, because a system administrator loads
2nd-kernel for enabling a kdump.

* Reference
  The discussion about this patch
  http://lists.infradead.org/pipermail/kexec/2009-July/003417.html


Thanks
Ken'ichi Ohmichi

Signed-off-by: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>
Acked-by: Simon Horman <horms@verge.net.au>
---
--- a/kernel/kexec.c	2009-07-08 12:30:26.000000000 +0900
+++ b/kernel/kexec.c	2009-07-08 12:38:08.000000000 +0900
@@ -57,6 +57,8 @@ struct resource crashk_res = {
 
 int kexec_should_crash(struct task_struct *p)
 {
+	if (kexec_crash_image)
+		return 1;
 	if (in_interrupt() || !p->pid || is_global_init(p) || panic_on_oops)
 		return 1;
 	return 0;

_______________________________________________
kexec mailing list
kexec@lists.infradead.org
http://lists.infradead.org/mailman/listinfo/kexec

