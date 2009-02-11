Return-Path: <linux-kernel-owner+w=401wt.eu-S1758486AbZBKV1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758486AbZBKV1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 16:27:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757665AbZBKV0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 16:26:53 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:22949 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757520AbZBKV0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 16:26:53 -0500
Date: Wed, 11 Feb 2009 13:16:37 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: gregkh@suse.de
Subject: [PATCH 3/9] staging/android/ram_console: fix printk format warning
Message-Id: <20090211131637.05a752ef.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.49934295.02D9:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix android printk format warnings:

linux-next-20090209/drivers/staging/android/ram_console.c:228: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'
linux-next-20090209/drivers/staging/android/ram_console.c:228: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'
linux-next-20090209/drivers/staging/android/ram_console.c:326: warning: format '%x' expects type 'unsigned int', but argument 2 has type 'size_t'
linux-next-20090209/drivers/staging/android/ram_console.c:326: warning: format '%x' expects type 'unsigned int', but argument 3 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/android/ram_console.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- mmotm-2009-0210-1635.orig/drivers/staging/android/ram_console.c
+++ mmotm-2009-0210-1635/drivers/staging/android/ram_console.c
@@ -225,7 +225,7 @@ static int __init ram_console_init(struc
 		buffer_size - sizeof(struct ram_console_buffer);
 
 	if (ram_console_buffer_size > buffer_size) {
-		pr_err("ram_console: buffer %p, invalid size %d, datasize %d\n",
+		pr_err("ram_console: buffer %p, invalid size %zu, datasize %zu\n",
 		       buffer, buffer_size, ram_console_buffer_size);
 		return 0;
 	}
@@ -322,7 +322,7 @@ static int ram_console_driver_probe(stru
 	}
 	buffer_size = res->end - res->start + 1;
 	start = res->start;
-	printk(KERN_INFO "ram_console: got buffer at %x, size %x\n",
+	printk(KERN_INFO "ram_console: got buffer at %zx, size %zx\n",
 	       start, buffer_size);
 	buffer = ioremap(res->start, buffer_size);
 	if (buffer == NULL) {
