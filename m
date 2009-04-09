Return-Path: <linux-kernel-owner+w=401wt.eu-S935587AbZDIRtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935587AbZDIRtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 13:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760273AbZDIRtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 13:49:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54123 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758138AbZDIRtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 13:49:09 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Make clean_rootfs()'s existence dependent on
	CONFIG_BLK_DEV_RAM
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, shaohua.li@intel.com, arjan@infradead.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org
Date: Thu, 09 Apr 2009 18:47:23 +0100
Message-ID: <20090409174723.7787.8779.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make clean_rootfs()'s existence dependent on CONFIG_BLK_DEV_RAM as it's only
called if that is 'y'.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 init/initramfs.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)


diff --git a/init/initramfs.c b/init/initramfs.c
index 80cd713..e44f2d9 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -515,6 +515,7 @@ skip:
 	initrd_end = 0;
 }
 
+#ifdef CONFIG_BLK_DEV_RAM
 #define BUF_SIZE 1024
 static void __init clean_rootfs(void)
 {
@@ -561,6 +562,7 @@ static void __init clean_rootfs(void)
 	sys_close(fd);
 	kfree(buf);
 }
+#endif
 
 static int __init populate_rootfs(void)
 {

