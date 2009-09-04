Return-Path: <linux-kernel-owner+w=401wt.eu-S934464AbZIDXHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934464AbZIDXHO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 19:07:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934445AbZIDXHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 19:07:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44120 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933995AbZIDXHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 19:07:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: x86 maintainers <x86@kernel.org>
Subject: [PATCH] x86: Decrease the level of some NUMA messages to KERN_DEBUG
Date: Sat, 5 Sep 2009 01:07:45 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc8-rjw; KDE/4.3.1; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200909050107.45175.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Some NUMA messages in srat_32.c are confusing to users, because they
seem to indicate errors, while in fact they reflect normal behaviour.

Decrease the level of these messages to KERN_DEBUG so that they don't
show up unnecessarily.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/x86/mm/srat_32.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/mm/srat_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/srat_32.c
+++ linux-2.6/arch/x86/mm/srat_32.c
@@ -215,7 +215,7 @@ int __init get_memcfg_from_srat(void)
 		goto out_fail;
 
 	if (num_memory_chunks == 0) {
-		printk(KERN_WARNING
+		printk(KERN_DEBUG
 			 "could not find any ACPI SRAT memory areas.\n");
 		goto out_fail;
 	}
@@ -277,7 +277,7 @@ int __init get_memcfg_from_srat(void)
 	}
 	return 1;
 out_fail:
-	printk(KERN_ERR "failed to get NUMA memory information from SRAT"
+	printk(KERN_DEBUG "failed to get NUMA memory information from SRAT"
 			" table\n");
 	return 0;
 }
