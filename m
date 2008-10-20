Return-Path: <linux-kernel-owner+w=401wt.eu-S1755434AbYJTXFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbYJTXFt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 19:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbYJTXFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 19:05:41 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:47854 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbYJTXFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 19:05:40 -0400
Date: Tue, 21 Oct 2008 00:04:04 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Dave Airlie <airlied@redhat.com>, Keith Packard <keithp@keithp.com>,
       Eric Anholt <eric@anholt.net>, Nick Piggin <npiggin@suse.de>,
       Matt Mackall <mpm@selenic.com>, David Howells <dhowells@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Export tiny shmem_file_setup for DRM-GEM
In-Reply-To: <Pine.LNX.4.64.0810191242220.22825@blonde.site>
Message-ID: <Pine.LNX.4.64.0810202355590.11071@blonde.site>
References: <Pine.LNX.4.64.0810191242220.22825@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're trying to keep the !CONFIG_SHMEM tiny-shmem.c (using ramfs without
swap) in synch with CONFIG_SHMEM shmem.c (and mpm is preparing patches
to combine them).  I was glad to see EXPORT_SYMBOL_GPL(shmem_file_setup)
go into shmem.c, but why not support DRM-GEM when !CONFIG_SHMEM too?
But caution says still depend on MMU, since !CONFIG_MMU is.. different.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: Matt Mackall <mpm@selenic.com>
Acked-by: Dave Airlie <airlied@redhat.com>
---

 drivers/gpu/drm/Kconfig |    2 +-
 mm/tiny-shmem.c         |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -6,7 +6,7 @@
 #
 menuconfig DRM
 	tristate "Direct Rendering Manager (XFree86 4.1.0 and higher DRI support)"
-	depends on (AGP || AGP=n) && PCI && !EMULATED_CMPXCHG && SHMEM
+	depends on (AGP || AGP=n) && PCI && !EMULATED_CMPXCHG && MMU
 	help
 	  Kernel-level support for the Direct Rendering Infrastructure (DRI)
 	  introduced in XFree86 4.0. If you say Y here, you need to select
--- a/mm/tiny-shmem.c
+++ b/mm/tiny-shmem.c
@@ -95,6 +95,7 @@ put_dentry:
 put_memory:
 	return ERR_PTR(error);
 }
+EXPORT_SYMBOL_GPL(shmem_file_setup);
 
 /**
  * shmem_zero_setup - setup a shared anonymous mapping
