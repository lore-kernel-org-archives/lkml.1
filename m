Return-Path: <linux-kernel-owner+w=401wt.eu-S1758729AbYIAQnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729AbYIAQnP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 12:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753661AbYIAQm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 12:42:58 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:53429 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195AbYIAQm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 12:42:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Iso8/dXQ5pYjznadV3LKay8uPOadRhEINYXuT7TLbi2pT7r/kgzlG9GGUx8H3xJldp
         ocQk02npMQc+rzNiibypN7DdElU42AxSe/JJt/yf/RcKl5aQVY4m6feIRKEG3CUkxJRy
         H4qC5tcm93x6llrfFou76HoORihyJAK61ojMM=
Date: Mon, 1 Sep 2008 20:44:33 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] proc: remove unused get_dma_list()
Message-ID: <20080901164433.GD24546@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/arm/kernel/dma.c |   17 -----------------
 fs/proc/proc_misc.c   |    1 -
 2 files changed, 18 deletions(-)

--- a/arch/arm/kernel/dma.c
+++ b/arch/arm/kernel/dma.c
@@ -26,23 +26,6 @@ EXPORT_SYMBOL(dma_spin_lock);
 static dma_t dma_chan[MAX_DMA_CHANNELS];
 
 /*
- * Get dma list for /proc/dma
- */
-int get_dma_list(char *buf)
-{
-	dma_t *dma;
-	char *p = buf;
-	int i;
-
-	for (i = 0, dma = dma_chan; i < MAX_DMA_CHANNELS; i++, dma++)
-		if (dma->lock)
-			p += sprintf(p, "%2d: %14s %s\n", i,
-				     dma->d_ops->type, dma->device_id);
-
-	return p - buf;
-}
-
-/*
  * Request DMA channel
  *
  * On certain platforms, we have to allocate an interrupt as well...
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -66,7 +66,6 @@
 extern int get_hardware_list(char *);
 extern int get_stram_list(char *);
 extern int get_exec_domain_list(char *);
-extern int get_dma_list(char *);
 
 static int proc_calc_metrics(char *page, char **start, off_t off,
 				 int count, int *eof, int len)

