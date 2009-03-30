Return-Path: <linux-kernel-owner+w=401wt.eu-S1755710AbZC3VKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710AbZC3VKV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 17:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbZC3VKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 17:10:06 -0400
Received: from rcsinet13.oracle.com ([148.87.113.125]:43610 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbZC3VKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 17:10:05 -0400
Date: Mon, 30 Mar 2009 14:08:44 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>, mingo <mingo@redhat.com>
Subject: [PATCH] dma-debug: fix printk formats (i386)
Message-Id: <20090330140844.af1c9a1d.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.49D134EB.02A1:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warnings in dma-debug:

lib/dma-debug.c:645: warning: format '%016llx' expects type 'long long unsigned int', but argument 6 has type 'dma_addr_t'
lib/dma-debug.c:662: warning: format '%016llx' expects type 'long long unsigned int', but argument 6 has type 'dma_addr_t'
lib/dma-debug.c:676: warning: format '%016llx' expects type 'long long unsigned int', but argument 6 has type 'dma_addr_t'
lib/dma-debug.c:686: warning: format '%016llx' expects type 'long long unsigned int', but argument 6 has type 'dma_addr_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 lib/dma-debug.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-next-20090330.orig/lib/dma-debug.c
+++ linux-next-20090330/lib/dma-debug.c
@@ -645,7 +645,7 @@ static void check_sync(struct device *de
 		err_printk(dev, NULL, "DMA-API: device driver tries "
 				"to sync DMA memory it has not allocated "
 				"[device address=0x%016llx] [size=%llu bytes]\n",
-				addr, size);
+				(unsigned long long)addr, size);
 		goto out;
 	}
 
@@ -663,7 +663,7 @@ static void check_sync(struct device *de
 				"DMA memory with different direction "
 				"[device address=0x%016llx] [size=%llu bytes] "
 				"[mapped with %s] [synced with %s]\n",
-				addr, entry->size,
+				(unsigned long long)addr, entry->size,
 				dir2name[entry->direction],
 				dir2name[direction]);
 	}
@@ -677,7 +677,7 @@ static void check_sync(struct device *de
 				"device read-only DMA memory for cpu "
 				"[device address=0x%016llx] [size=%llu bytes] "
 				"[mapped with %s] [synced with %s]\n",
-				addr, entry->size,
+				(unsigned long long)addr, entry->size,
 				dir2name[entry->direction],
 				dir2name[direction]);
 
@@ -687,7 +687,7 @@ static void check_sync(struct device *de
 				"device write-only DMA memory to device "
 				"[device address=0x%016llx] [size=%llu bytes] "
 				"[mapped with %s] [synced with %s]\n",
-				addr, entry->size,
+				(unsigned long long)addr, entry->size,
 				dir2name[entry->direction],
 				dir2name[direction]);
 
