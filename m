Return-Path: <linux-kernel-owner+w=401wt.eu-S1755772AbXIDW5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772AbXIDW5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 18:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781AbXIDW5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 18:57:43 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45967 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbXIDW5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 18:57:42 -0400
Date: Wed, 5 Sep 2007 04:40:52 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Jason Lunz <lunz@falooley.org>
cc: David Woodhouse <dwmw2@infradead.org>, lkml <linux-kernel@vger.kernel.org>,
       Stable Branch <stable@kernel.org>
Subject: Re: [mtd] allow modular mtdsuper
In-Reply-To: <20070904222154.GA12804@falooley.org>
Message-ID: <alpine.LFD.0.999.0709050421330.20571@enigma.security.iitk.ac.in>
References: <20070904222154.GA12804@falooley.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,


On Tue, 4 Sep 2007, Jason Lunz wrote:
> 
> Declare mtdsuper to be gpl-licensed so it can access get_mtd_device and
> put_mtd_device when loaded as a module.

The actual issue was a bit different -- refer commit bec494775600b1cd in
latest -git (patch included below).

David, it looks like .22 had this problem as well. If we care enough, you
could forward this on to -stable (cc'ed, just in case).

Satyam

[MTD] Makefile fix for mtdsuper

We want drivers/mtd/{mtdcore, mtdsuper, mtdpart}.c to be built and linked
into the same mtd.ko module. Fix the Makefile to ensure this, and remove
duplicate MODULE_ declarations in mtdpart.c, as mtdcore.c already has them.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Signed-off-by: David Woodhouse <dwmw2@infradead.org>

---

 drivers/mtd/Makefile  |    2 +-
 drivers/mtd/mtdpart.c |    4 ----
 2 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/Makefile b/drivers/mtd/Makefile
index 451adcc..6d958a4 100644
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
