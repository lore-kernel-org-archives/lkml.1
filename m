Return-Path: <linux-kernel-owner+w=401wt.eu-S932975AbXC3XGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932975AbXC3XGM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 19:06:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933004AbXC3XGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 19:06:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:28529 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932975AbXC3XGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 19:06:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,355,1170662400"; 
   d="scan'208"; a="205856242:sNHT148064868"
From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 2.6.21-rc5 2/3] msi: fix ARM compile
To: greg@kroah.com
Cc: linux@arm.linux.org.uk, linux-pci@atrey.karlin.mff.cuni.cz,
       ebiederm@xmission.com, linux-kernel@vger.kernel.org
Date: Fri, 30 Mar 2007 16:05:55 -0700
Message-ID: <20070330230555.14060.62139.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20070330220243.14060.14389.stgit@dwillia2-linux.ch.intel.com>
References: <20070330220243.14060.14389.stgit@dwillia2-linux.ch.intel.com>
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
index ad33e01..7a7152b 100644
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
