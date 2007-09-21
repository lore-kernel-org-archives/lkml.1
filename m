Return-Path: <linux-kernel-owner+w=401wt.eu-S1764394AbXIUVbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764394AbXIUVbf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 17:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763718AbXIUVbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 17:31:20 -0400
Received: from mail.suse.de ([195.135.220.2]:53179 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763653AbXIUVbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 17:31:17 -0400
Subject: patch mtd-makefile-fix-for-mtdsuper.patch queued to -stable tree
To: satyam@infradead.org, dwmw2@infradead.org, gregkh@suse.de,
       linux-kernel@vger.kernel.org, lunz@falooley.org, stable@kernel.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@suse.de>
Date: Fri, 21 Sep 2007 14:31:53 -0700
In-Reply-To: <alpine.LFD.0.999.0709050421330.20571@enigma.security.iitk.ac.in>
Message-Id: <20070921213114.4064A14540D1@imap.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that we have just queued up the patch titled

     Subject: MTD: Makefile fix for mtdsuper

to the 2.6.22-stable tree.  Its filename is

     mtd-makefile-fix-for-mtdsuper.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From stable-bounces@linux.kernel.org Tue Sep  4 15:57:55 2007
From: Satyam Sharma <satyam@infradead.org>
Date: Wed, 5 Sep 2007 04:40:52 +0530 (IST)
Subject: MTD: Makefile fix for mtdsuper
To: Jason Lunz <lunz@falooley.org>
Cc: David Woodhouse <dwmw2@infradead.org>, lkml <linux-kernel@vger.kernel.org>, Stable Branch <stable@kernel.org>
Message-ID: <alpine.LFD.0.999.0709050421330.20571@enigma.security.iitk.ac.in>

From: Satyam Sharma <satyam@infradead.org>

commit bec494775600b1cd7c144d31a09e1f46df9c6324 in mainline.

We want drivers/mtd/{mtdcore, mtdsuper, mtdpart}.c to be built and linked
into the same mtd.ko module. Fix the Makefile to ensure this, and remove
duplicate MODULE_ declarations in mtdpart.c, as mtdcore.c already has them.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/drivers/mtd/Makefile
+++ b/drivers/mtd/Makefile
@@ -3,9 +3,9 @@
 #
 
 # Core functionality.
+obj-$(CONFIG_MTD)		+= mtd.o
 mtd-y				:= mtdcore.o mtdsuper.o
 mtd-$(CONFIG_MTD_PARTITIONS)	+= mtdpart.o
-obj-$(CONFIG_MTD)		+= $(mtd-y)
 
 obj-$(CONFIG_MTD_CONCAT)	+= mtdconcat.o
 obj-$(CONFIG_MTD_REDBOOT_PARTS) += redboot.o
diff --git a/drivers/mtd/mtdpart.c b/drivers/mtd/mtdpart.c
index 9c62368..6174a97 100644
--- a/drivers/mtd/mtdpart.c
+++ b/drivers/mtd/mtdpart.c
@@ -560,7 +560,3 @@ int parse_mtd_partitions(struct mtd_info *master, const char **types,
 EXPORT_SYMBOL_GPL(parse_mtd_partitions);
 EXPORT_SYMBOL_GPL(register_mtd_parser);
 EXPORT_SYMBOL_GPL(deregister_mtd_parser);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Nicolas Pitre <nico@cam.org>");
-MODULE_DESCRIPTION("Generic support for partitioning of MTD devices");

_______________________________________________
stable mailing list
stable@linux.kernel.org
http://linux.kernel.org/mailman/listinfo/stable



Patches currently in stable-queue which might be from satyam@infradead.org are

queue-2.6.22/mtd-makefile-fix-for-mtdsuper.patch
