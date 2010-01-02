Return-Path: <linux-kernel-owner+w=401wt.eu-S1752517Ab0ABEhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab0ABEhl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 23:37:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483Ab0ABEhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 23:37:08 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:46872 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab0ABEhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 23:37:05 -0500
Date: Fri, 1 Jan 2010 20:35:54 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>,
       torvalds <torvalds@linux-foundation.org>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>,
       David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 3/4] DocBook/mtdnand: fix ioremap return type
Message-Id: <20100101203554.e2dd3ce6.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4B3ECD5C.007E:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: H Hartley Sweeten <hsweeten@visionengravers.com>
Subject: DocBook: fix ioremap return type

ioremap() returns a void __iomem * not an unsigned long.  Update the
Documentation file to reflect this.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 Documentation/DocBook/mtdnand.tmpl |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- linux-2.6.33-rc2-git4.orig/Documentation/DocBook/mtdnand.tmpl
+++ linux-2.6.33-rc2-git4/Documentation/DocBook/mtdnand.tmpl
@@ -174,7 +174,7 @@
 		</para>
 		<programlisting>
 static struct mtd_info *board_mtd;
-static unsigned long baseaddr;
+static void __iomem *baseaddr;
 		</programlisting>
 		<para>
 			Static example
@@ -182,7 +182,7 @@ static unsigned long baseaddr;
 		<programlisting>
 static struct mtd_info board_mtd;
 static struct nand_chip board_chip;
-static unsigned long baseaddr;
+static void __iomem *baseaddr;
 		</programlisting>
 	</sect1>
 	<sect1 id="Partition_defines">
@@ -283,8 +283,8 @@ int __init board_init (void)
 	}
 
 	/* map physical address */
-	baseaddr = (unsigned long)ioremap(CHIP_PHYSICAL_ADDRESS, 1024);
-	if(!baseaddr){
+	baseaddr = ioremap(CHIP_PHYSICAL_ADDRESS, 1024);
+	if (!baseaddr) {
 		printk("Ioremap to access NAND chip failed\n");
 		err = -EIO;
 		goto out_mtd;
@@ -316,7 +316,7 @@ int __init board_init (void)
 	goto out;
 
 out_ior:
-	iounmap((void *)baseaddr);
+	iounmap(baseaddr);
 out_mtd:
 	kfree (board_mtd);
 out:
@@ -341,7 +341,7 @@ static void __exit board_cleanup (void)
 	nand_release (board_mtd);
 
 	/* unmap physical address */
-	iounmap((void *)baseaddr);
+	iounmap(baseaddr);
 	
 	/* Free the MTD device structure */
 	kfree (board_mtd);
