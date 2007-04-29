Return-Path: <linux-kernel-owner+w=401wt.eu-S1755139AbXD2LFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139AbXD2LFl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 07:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755182AbXD2LAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 07:00:47 -0400
Received: from ns1.suse.de ([195.135.220.2]:52105 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755160AbXD2KxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:53:10 -0400
From: Andi Kleen <ak@suse.de>
References: <200704291252.514680000@suse.de>
In-Reply-To: <200704291252.514680000@suse.de>
To: Joerg Roedel <joerg.roedel@amd.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [21/48] x86: remove constant_tsc reporting from /proc/cpuinfo' power flags
Message-Id: <20070429105310.12DE015108@wotan.suse.de>
Date: Sun, 29 Apr 2007 12:53:10 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Joerg Roedel <joerg.roedel@amd.com>

remove the reporting of the constant_tsc flag from the "power management"
field in /proc/cpuinfo.  The NULL value there was replaced by "" because
the former would result in a printout of [8] if the flag is set.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/kernel/cpu/proc.c |    3 +--
 arch/x86_64/kernel/setup.c  |    5 ++---
 2 files changed, 3 insertions(+), 5 deletions(-)

Index: linux/arch/i386/kernel/cpu/proc.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/proc.c
+++ linux/arch/i386/kernel/cpu/proc.c
@@ -72,8 +72,7 @@ static int show_cpuinfo(struct seq_file 
 		"stc",
 		"100mhzsteps",
 		"hwpstate",
-		NULL,
-		NULL,	/* constant_tsc - moved to flags */
+		"",	/* constant_tsc - moved to flags */
 		/* nothing */
 	};
 	struct cpuinfo_x86 *c = v;
Index: linux/arch/x86_64/kernel/setup.c
===================================================================
--- linux.orig/arch/x86_64/kernel/setup.c
+++ linux/arch/x86_64/kernel/setup.c
@@ -979,9 +979,8 @@ static int show_cpuinfo(struct seq_file 
 		"stc",
 		"100mhzsteps",
 		"hwpstate",
-		NULL,	/* tsc invariant mapped to constant_tsc */
-		NULL,
-		/* nothing */	/* constant_tsc - moved to flags */
+		"",	/* tsc invariant mapped to constant_tsc */
+		/* nothing */
 	};
 
 
