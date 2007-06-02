Return-Path: <linux-kernel-owner+w=401wt.eu-S1763521AbXFBTJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763521AbXFBTJT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 15:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759958AbXFBTJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 15:09:06 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:51895 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758490AbXFBTJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 15:09:04 -0400
Date: Sat, 2 Jun 2007 21:09:07 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] the ASYNC_* options shouldn't be user visible
Message-ID: <20070602190907.GK5500@stusta.de>
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070530235823.793f00d9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 11:58:23PM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.22-rc2-mm1:
>...
>  git-md-accel.patch
>...
>  git trees
>...


The ASYNC_* options are for internal helper code and should therefore 
not be user visible.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

BTW: Please move the async_tx directory under drivers/ or lib/

 async_tx/Kconfig |   28 ++++++++--------------------
 1 file changed, 8 insertions(+), 20 deletions(-)

--- linux-2.6.22-rc3-mm1/async_tx/Kconfig.old	2007-06-02 19:30:32.000000000 +0200
+++ linux-2.6.22-rc3-mm1/async_tx/Kconfig	2007-06-02 19:31:20.000000000 +0200
@@ -1,27 +1,15 @@
-menuconfig ASYNC_CORE
-	tristate "Asynchronous Bulk Memory Transfers/Transforms"
-	default n
-	---help---
-	  This enables the async_tx interface layer for dma (offload) engines.
-	  Subsystems coded to this api will use offload engines for bulk memory
-	  operations (e.g. memcpy, memset, xor...).  When an offload engine is not
-	  available the interface will implicitly fall back to a software
-	  implementation of the operation.
-
-	  If unsure, say N
-
-if ASYNC_CORE
+config ASYNC_CORE
+	tristate
 
 config ASYNC_MEMCPY
-	default m
-	tristate "async_memcpy support"
+	tristate
+	select ASYNC_CORE
 
 config ASYNC_XOR
-	default m
-	tristate "async_xor support"
+	tristate
+	select ASYNC_CORE
 
 config ASYNC_MEMSET
-	default m
-	tristate "async_memset support"
+	tristate
+	select ASYNC_CORE
 
-endif

