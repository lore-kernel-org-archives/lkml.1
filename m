Return-Path: <linux-kernel-owner+w=401wt.eu-S937531AbXG2Vp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937531AbXG2Vp0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 17:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935849AbXG2Vox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 17:44:53 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:48382 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935709AbXG2Vow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 17:44:52 -0400
Date: Sun, 29 Jul 2007 23:44:51 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Mike Houston <mikeserv@bmts.com>
cc: Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: nvidia installer DIW with 2.6.23-rc1
In-Reply-To: <20070729141206.4181e25b.mikeserv@bmts.com>
Message-ID: <Pine.LNX.4.64.0707292343490.9488@fbirervta.pbzchgretzou.qr>
References: <200707291057.34291.gene.heskett@gmail.com>
 <20070729141206.4181e25b.mikeserv@bmts.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 29 2007 14:12, Mike Houston wrote:
>I know it's off topic here, but this will help people.
>
>When that happens, check their forum. Chances are someone has
>posted, and the nvidia developers have answered with a patch, code
>snippet, quick instructions to get it to compile or advice to try a
>beta driver if applicable.

At least for solidarity for those stuck with it, patch below.

>To build nvidia kernel module failed in
>kernel-2.6.23-0.41.rc0.git14.fc8
>http://www.nvnews.net/vbulletin/showthread.php?t=95296

	Jan
===

---
 nv-linux.h |    2 +-
 nv.c       |    6 ++----
 2 files changed, 3 insertions(+), 5 deletions(-)

Index: nv_kernel-100.14.11/nv-linux.h
===================================================================
--- nv_kernel-100.14.11.orig/nv-linux.h
+++ nv_kernel-100.14.11/nv-linux.h
@@ -533,7 +533,7 @@ static inline unsigned long nv_virt_to_p
 #define NV_KMEM_CACHE_CREATE(kmem_cache, name, type)            \
     {                                                           \
         kmem_cache = kmem_cache_create(name, sizeof(type),      \
-                        0, 0, NULL, NULL);                      \
+                        0, 0, NULL);                      \
     } 
 
 #define NV_KMEM_CACHE_DESTROY(kmem_cache)                       \
Index: nv_kernel-100.14.11/nv.c
===================================================================
--- nv_kernel-100.14.11.orig/nv.c
+++ nv_kernel-100.14.11/nv.c
@@ -1566,8 +1566,7 @@ failed:
         if (apm_nv_dev[i] != NULL) pm_unregister(apm_nv_dev[i]);
 #endif
 
-    if (unregister_chrdev(nv_major, "nvidia") < 0)
-        nv_printf(NV_DBG_ERRORS, "NVRM: unregister nv chrdev failed\n");
+    unregister_chrdev(nv_major, "nvidia");
 
     for (i = 0; i < num_nv_devices; i++)
     {
@@ -1598,8 +1597,7 @@ static void __exit nvidia_exit_module(vo
 
     nv_printf(NV_DBG_INFO, "NVRM: nvidia_exit_module\n");
 
-    if (unregister_chrdev(nv_major, "nvidia") < 0)
-        nv_printf(NV_DBG_ERRORS, "NVRM: unregister nv chrdev failed\n");
+    unregister_chrdev(nv_major, "nvidia");
 
     for (i = 0; i < num_nv_devices; i++)
     {
