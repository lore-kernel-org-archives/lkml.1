Return-Path: <linux-kernel-owner+w=401wt.eu-S1759476AbXEaP4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759476AbXEaP4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 11:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbXEaP4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 11:56:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420AbXEaP4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 11:56:44 -0400
Date: Thu, 31 May 2007 11:56:37 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, axboe@kernel.dk,
       clameter@sgi.com, tony.luck@intel.com, randy.dunlap@oracle.com,
       dgc@sgi.com, sam@ravnborg.org
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20070531155637.21151.32534.sendpatchset@prarit.boston.redhat.com>
Subject: [PATCH]: -mm tree remove __exit from loop_exit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, please patch ASAP as compile on SGI ia64 is broken.  Please note this
patch does not address why modpost did not pick up this error.

ie) ./scripts/mod/modpost drivers/block/built-in.o yields no information about
the section mismatch.  AFAIK, it should spit out a loud WARNING.

Patch against 2.6.22-rc3-mm1.

Current mm tree does not build with sn2_defconfig.  Build results in error:

`.exit.text' referenced in section `.init.text' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
make: *** [.tmp_vmlinux1] Error 1

__exit loop_exit is now being called from __init loop_init which causes this error.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

--- linux/drivers/block/loop.c.orig	2007-05-31 11:15:21.000000000 -0400
+++ linux/drivers/block/loop.c	2007-05-31 11:11:05.000000000 -0400
@@ -1456,7 +1456,7 @@ static struct kobject *loop_probe(dev_t 
 	return kobj;
 }
 
-static void __exit loop_exit(void)
+static void loop_exit(void)
 {
 	unsigned long range;
 	struct loop_device *lo, *next;
