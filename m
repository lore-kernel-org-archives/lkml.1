Return-Path: <linux-kernel-owner+w=401wt.eu-S937092AbYEUT51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937092AbYEUT51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 15:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760130AbYEUT5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 15:57:11 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:34960 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755764AbYEUT5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 15:57:10 -0400
Date: Wed, 21 May 2008 22:54:54 +0300
From: Adrian Bunk <bunk@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] frv: export empty_zero_page
Message-ID: <20080521195454.GJ15355@cs181133002.pp.htv.fi>
References: <20080521191639.GI15355@cs181133002.pp.htv.fi> <20080521174203.GG15355@cs181133002.pp.htv.fi> <7195.1211396122@redhat.com> <7398.1211397885@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7398.1211397885@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 08:24:45PM +0100, David Howells wrote:
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > > > EXPORT_SYMBOL_GPL(empty_zero_page);
> > > 
> > > EXPORT_SYMBOL() as elsewhere please.
> > 
> > ia64 also has EXPORT_SYMBOL_GPL...
> 
> Okay, everywhere barring ia64 then.

Updated patch below.

> David

cu
Adrian


<--  snip  -->


This patch fixes the following build error:

<--  snip  -->

...
  MODPOST 1845 modules
ERROR: "empty_zero_page" [fs/ext4/ext4dev.ko] undefined!
...
make[2]: *** [__modpost] Error 1

<--  snip  -->

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/frv/mm/init.c |    3 +++
 1 file changed, 3 insertions(+)

69b697b58fe1a9d7f871285768efdbec443ad2e8 diff --git a/arch/frv/mm/init.c b/arch/frv/mm/init.c
index b841ecf..9af7740 100644
--- a/arch/frv/mm/init.c
+++ b/arch/frv/mm/init.c
@@ -26,6 +26,7 @@
 #include <linux/types.h>
 #include <linux/bootmem.h>
 #include <linux/highmem.h>
+#include <linux/module.h>
 
 #include <asm/setup.h>
 #include <asm/segment.h>
@@ -56,7 +57,9 @@ DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
  */
 static unsigned long empty_bad_page_table;
 static unsigned long empty_bad_page;
+
 unsigned long empty_zero_page;
+EXPORT_SYMBOL(empty_zero_page);
 
 /*****************************************************************************/
 /*

