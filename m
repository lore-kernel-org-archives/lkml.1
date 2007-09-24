Return-Path: <linux-kernel-owner+w=401wt.eu-S1760802AbXIXQ1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760802AbXIXQ1v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759119AbXIXQZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:25:12 -0400
Received: from canuck.infradead.org ([209.217.80.40]:47222 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758967AbXIXQZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:25:07 -0400
Date: Mon, 24 Sep 2007 09:20:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Jason Lunz <lunz@falooley.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Woodhouse <dwmw2@infradead.org>,
       Satyam Sharma <satyam@infradead.org>
Subject: [08/50] MTD: Makefile fix for mtdsuper
Message-ID: <20070924162012.GI13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mtd-makefile-fix-for-mtdsuper.patch"
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Satyam Sharma <satyam@infradead.org>

commit bec494775600b1cd7c144d31a09e1f46df9c6324 in mainline.

We want drivers/mtd/{mtdcore, mtdsuper, mtdpart}.c to be built and linked
into the same mtd.ko module. Fix the Makefile to ensure this, and remove
duplicate MODULE_ declarations in mtdpart.c, as mtdcore.c already has them.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mtd/Makefile  |    2 +-
 drivers/mtd/mtdpart.c |    4 ----
 2 files changed, 1 insertion(+), 5 deletions(-)

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
--- a/drivers/mtd/mtdpart.c
+++ b/drivers/mtd/mtdpart.c
@@ -560,7 +560,3 @@ int parse_mtd_partitions(struct mtd_info
 EXPORT_SYMBOL_GPL(parse_mtd_partitions);
 EXPORT_SYMBOL_GPL(register_mtd_parser);
 EXPORT_SYMBOL_GPL(deregister_mtd_parser);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Nicolas Pitre <nico@cam.org>");
-MODULE_DESCRIPTION("Generic support for partitioning of MTD devices");

-- 
