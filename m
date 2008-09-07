Return-Path: <linux-kernel-owner+w=401wt.eu-S1752304AbYIHAVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbYIHAVe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 20:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750910AbYIHAVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 20:21:25 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:7740 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbYIHAVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 20:21:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xCQtHS/ewtLJgc4oCFxNmrCrf4nhnXg/akH0TX+SUpqD6UT2EDYF3dd9du6lX9kfka
         WPCAWz8WFssqWwgCo46H6WaCHbO/gD7e+CB9ld7AhGrdcdWDHHbCCuPyHH7NQT/lqw5C
         jFFNsJVfKvURzggrLdD+w8xX0cfrGISVmpxyc=
Date: Mon, 8 Sep 2008 07:47:21 +0800
From: Yan Li <elliot.li.tech@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, joerg.roedel@amd.com, elliot.li.tech@gmail.com,
       rjmaomao@gmail.com
Subject: [PATCH 2/2] avoid mtrr warning message when running as VMware guest
Message-ID: <20080907234720.GA30734@yantp.cn.ibm.com>
References: <20080221115452.GB13948@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080221115452.GB13948@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch depends on VMware detection.

Signed-off-by: Yan Li <elliot.li.tech@gmail.com>
---
 arch/x86/kernel/cpu/mtrr/main.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index b117d7f..7e2bd23 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -45,6 +45,7 @@
 #include <asm/processor.h>
 #include <asm/msr.h>
 #include <asm/kvm_para.h>
+#include <asm/vmware.h>
 #include "mtrr.h"
 
 u32 num_var_ranges = 0;
@@ -1496,8 +1497,8 @@ int __init mtrr_trim_uncached_memory(unsigned long end_pfn)
 
 	/* kvm/qemu doesn't have mtrr set right, don't trim them all */
 	if (!highest_pfn) {
-		WARN(!kvm_para_available(), KERN_WARNING
-				"WARNING: strange, CPU MTRRs all blank?\n");
+		WARN(!(kvm_para_available() || (is_vmware_guest())),
+		     KERN_WARNING "WARNING: strange, CPU MTRRs all blank?\n");
 		return 0;
 	}
 
-- 
1.5.6.3


-- 
Li, Yan

"Everything that is really great and inspiring is created by the
individual who can labor in freedom."
              - Albert Einstein, in Out of My Later Years (1950)
