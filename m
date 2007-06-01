Return-Path: <linux-kernel-owner+w=401wt.eu-S1762037AbXFABRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762037AbXFABRV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 21:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760690AbXFABQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 21:16:04 -0400
Received: from mail.kroah.org ([69.55.234.183]:46586 "EHLO perch.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757812AbXFABP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 21:15:59 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-pci@atrey.karlin.mff.cuni.cz
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/5] msi: fix ARM compile
Date: Thu, 31 May 2007 18:16:53 -0700
Message-Id: <11806606172653-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2
In-Reply-To: <20070601011612.GA28262@kroah.com>
References: <20070601011612.GA28262@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/pci/msi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index d9cbd58..f7f7470 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -15,10 +15,10 @@
 #include <linux/pci.h>
 #include <linux/proc_fs.h>
 #include <linux/msi.h>
+#include <linux/smp.h>
 
 #include <asm/errno.h>
 #include <asm/io.h>
-#include <asm/smp.h>
 
 #include "pci.h"
 #include "msi.h"
-- 
1.5.2

