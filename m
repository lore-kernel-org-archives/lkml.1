Return-Path: <linux-kernel-owner+w=401wt.eu-S1756697AbYGKFae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697AbYGKFae (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 01:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbYGKF37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 01:29:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:26668 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640AbYGKF36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 01:29:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,342,1212390000"; 
   d="scan'208";a="410167814"
Subject: [linux-next] [PATCH V2 1/4] swsusp: call plaform_begin before
	swsusp_shrinnk_memory
From: Zhang Rui <rui.zhang@intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@suse.cz>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Fri, 11 Jul 2008 13:29:06 +0800
Message-Id: <1215754146.1617.58.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


call platform_begin before swsusp shrink memory so that
we can allocate enough pages for ACPI NVS memory region
in platform_begin.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 kernel/power/disk.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/power/disk.c
===================================================================
--- linux-2.6.orig/kernel/power/disk.c	2008-07-01 09:32:36.000000000 +0800
+++ linux-2.6/kernel/power/disk.c	2008-07-03 09:08:20.000000000 +0800
@@ -243,12 +243,12 @@
 {
 	int error;
 
-	/* Free memory before shutting down devices. */
-	error = swsusp_shrink_memory();
+	error = platform_begin(platform_mode);
 	if (error)
 		return error;
 
-	error = platform_begin(platform_mode);
+	/* Free memory before shutting down devices. */
+	error = swsusp_shrink_memory();
 	if (error)
 		goto Close;
 


