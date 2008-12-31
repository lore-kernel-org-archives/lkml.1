Return-Path: <linux-kernel-owner+w=401wt.eu-S1756801AbYLaWXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbYLaWXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 17:23:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbYLaWXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 17:23:07 -0500
Received: from byss.tchmachines.com ([208.76.80.75]:43407 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbYLaWXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 17:23:06 -0500
X-Greylist: delayed 2293 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Dec 2008 17:23:06 EST
Date: Wed, 31 Dec 2008 13:44:46 -0800
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, travis@sgi.com
Subject: [patch] x86: Fix incorrect __read_mostly on _boot_cpu_pda
Message-ID: <20081231214446.GA6856@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pda rework (commit 3461b0af025251bbc6b3d56c821c6ac2de6f7209)
to remove static boot cpu pdas introduced a bug.  _boot_cpu_pda is the
actual pda used by the boot cpu and is definitely not "__read_mostly" and
ended up polluting the read mostly section with writes.  This bug caused
regression of about 8-10% on certain syscall intensive workloads.

Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>

Index: linux-2.6/arch/x86/kernel/head64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head64.c	2008-12-30 15:28:08.000000000 -0800
+++ linux-2.6/arch/x86/kernel/head64.c	2008-12-31 10:36:21.000000000 -0800
@@ -27,7 +27,7 @@
 #include <asm/trampoline.h>
 
 /* boot cpu pda */
-static struct x8664_pda _boot_cpu_pda __read_mostly;
+static struct x8664_pda _boot_cpu_pda;
 
 #ifdef CONFIG_SMP
 /*
