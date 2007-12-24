Return-Path: <linux-kernel-owner+w=401wt.eu-S1758017AbXLXAkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017AbXLXAkk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 19:40:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120AbXLXAjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 19:39:35 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57120 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147AbXLXAj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 19:39:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 1/3] PM: Do not destroy/create devices while suspended in msr.c
Date: Mon, 24 Dec 2007 01:56:34 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       Ingo Molnar <mingo@elte.hu>
References: <200712240155.14765.rjw@sisk.pl>
In-Reply-To: <200712240155.14765.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712240156.34961.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The MSR driver should not attempt to destroy/create a suspended
device.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/x86/kernel/msr.c |    3 ---
 1 file changed, 3 deletions(-)

Index: linux-2.6/arch/x86/kernel/msr.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/msr.c
+++ linux-2.6/arch/x86/kernel/msr.c
@@ -155,13 +155,10 @@ static int __cpuinit msr_class_cpu_callb
 
 	switch (action) {
 	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
 		err = msr_device_create(cpu);
 		break;
 	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
 		msr_device_destroy(cpu);
 		break;
 	}

