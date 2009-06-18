Return-Path: <linux-kernel-owner+w=401wt.eu-S1761558AbZFRGs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761558AbZFRGs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 02:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759704AbZFRGst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 02:48:49 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49647 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757267AbZFRGss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 02:48:48 -0400
Message-ID: <4A39E34F.20707@jp.fujitsu.com>
Date: Thu, 18 Jun 2009 15:48:47 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
CC: Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       kexec@lists.infradead.org
Subject: [PATCH 3/7] ia64, kexec: Unregister MCA handler before kexec
References: <4A39E247.4030908@jp.fujitsu.com>
In-Reply-To: <4A39E247.4030908@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We cannot handle machine check errors during kernel transition.
To avoid entering MCA handler from early stage of new kernel, unregister
the entry point from SAL before leave from current kernel.
Then SAL will make all MCAs to warmboot safely.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Haren Myneni <hbabu@us.ibm.com>
Cc: kexec@lists.infradead.org
---
 arch/ia64/kernel/machine_kexec.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/kernel/machine_kexec.c b/arch/ia64/kernel/machine_kexec.c
index d35fc39..eb4f1cc 100644
--- a/arch/ia64/kernel/machine_kexec.c
+++ b/arch/ia64/kernel/machine_kexec.c
@@ -106,6 +106,9 @@ static void ia64_machine_kexec(struct unw_frame_info *info, void *arg)
 		ia64_sal_set_vectors(SAL_VECTOR_OS_INIT, 0, 0, 0, 0, 0, 0);
 	}
 
+	/* Unregister mca handler - No more recovery on current kernel */
+	ia64_sal_set_vectors(SAL_VECTOR_OS_MCA, 0, 0, 0, 0, 0, 0);
+
 	/* Interrupts aren't acceptable while we reboot */
 	local_irq_disable();
 
-- 
1.6.0


