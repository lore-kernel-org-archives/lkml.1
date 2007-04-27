Return-Path: <linux-kernel-owner+w=401wt.eu-S1755349AbXD0BVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbXD0BVn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 21:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755350AbXD0BVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 21:21:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:56012 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755349AbXD0BVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 21:21:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,459,1170662400"; 
   d="scan'208";a="79877189"
From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 1/2] msi: fix ARM compile
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Date: Thu, 26 Apr 2007 18:21:38 -0700
Message-ID: <20070427012138.30322.850.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In file included from drivers/pci/msi.c:22:
include/asm/smp.h:17:26: asm/arch/smp.h: No such file or directory
include/asm/smp.h:20:3: #error "<asm-arm/smp.h> included in non-SMP build"
include/asm/smp.h:23:1: warning: "raw_smp_processor_id" redefined
In file included from include/linux/sched.h:65,
                 from include/linux/mm.h:4,
                 from drivers/pci/msi.c:10:
include/linux/smp.h:85:1: warning: this is the location of the previous
definition

Tested on powerpc, i386, and x86_64.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Eric W. Biederman <ebiederm@xmission.com>
---

 drivers/pci/msi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 435c195..c642e3b 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -16,10 +16,10 @@
 #include <linux/pci.h>
 #include <linux/proc_fs.h>
 #include <linux/msi.h>
+#include <linux/smp.h>
 
 #include <asm/errno.h>
 #include <asm/io.h>
-#include <asm/smp.h>
 
 #include "pci.h"
 #include "msi.h"
