Return-Path: <linux-kernel-owner+w=401wt.eu-S1755972AbXKUVGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbXKUVGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 16:06:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755294AbXKUVGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 16:06:00 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48178 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755153AbXKUVF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 16:05:59 -0500
Date: Wed, 21 Nov 2007 13:05:58 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Modules: Include sections.h to avoid defining linker variables
 explicitly
Message-ID: <Pine.LNX.4.64.0711211304580.3664@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Module.c should not define linker variables on its own. We have an include
file for that.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 kernel/module.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: linux-2.6/kernel/module.c
===================================================================
--- linux-2.6.orig/kernel/module.c	2007-11-21 13:02:39.415358527 -0800
+++ linux-2.6/kernel/module.c	2007-11-21 13:03:16.534858271 -0800
@@ -46,6 +46,7 @@
 #include <asm/semaphore.h>
 #include <asm/cacheflush.h>
 #include <linux/license.h>
+#include <asm/sections.h>
 
 extern int module_sysfs_initialized;
 
@@ -338,9 +339,6 @@ static inline unsigned int block_size(in
 	return val;
 }
 
-/* Created by linker magic */
-extern char __per_cpu_start[], __per_cpu_end[];
-
 static void *percpu_modalloc(unsigned long size, unsigned long align,
 			     const char *name)
 {
