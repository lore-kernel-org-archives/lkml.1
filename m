Return-Path: <linux-kernel-owner+w=401wt.eu-S1754904AbXLFJgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbXLFJgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 04:36:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbXLFJgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 04:36:13 -0500
Received: from [222.73.24.84] ([222.73.24.84]:52714 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751566AbXLFJgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 04:36:12 -0500
Message-ID: <4757C1DA.6060603@cn.fujitsu.com>
Date: Thu, 06 Dec 2007 17:33:14 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: paulus@samba.org
CC: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/3] POWERPC: don't cast a pointer to pointer of list_head
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The casting is safe only when the list_head member is the
first member of the structure.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

---
 arch/ppc/syslib/ocp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/ppc/syslib/ocp.c b/arch/ppc/syslib/ocp.c
index 3f5be2c..d42d408 100644
--- a/arch/ppc/syslib/ocp.c
+++ b/arch/ppc/syslib/ocp.c
@@ -376,7 +376,7 @@ ocp_remove_one_device(unsigned int vendor, unsigned int function, int index)
 
 	down_write(&ocp_devices_sem);
 	dev = __ocp_find_device(vendor, function, index);
-	list_del((struct list_head *)dev);
+	list_del(&dev->link);
 	up_write(&ocp_devices_sem);
 
 	DBG(("ocp: ocp_remove_one_device(vendor: %x, function: %x, index: %d)... done.\n", vendor, function, index));
-- 
1.5.3.rc7

