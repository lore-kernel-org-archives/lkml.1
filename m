Return-Path: <linux-kernel-owner+w=401wt.eu-S1754893AbXDZTBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbXDZTBO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 15:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754924AbXDZTBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 15:01:14 -0400
Received: from DENETHOR.UNI-MUENSTER.DE ([128.176.180.180]:56677 "EHLO
	denethor.uni-muenster.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893AbXDZTBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 15:01:12 -0400
X-Greylist: delayed 1437 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Apr 2007 15:01:12 EDT
Date: Thu, 26 Apr 2007 20:25:19 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] mm/memory.c: remove warning from an uninitialized spinlock. was: Re: 2.6.21-rc7-mm2
Message-ID: <20070426182519.GA4532@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Remove build warning mm/memory.c:1491: warning: 'ptl' may be used uninitialized in this function.
The spinlock pointer is assigned to null since it gets overwritten right away in
pte_alloc_map_lock().

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---

Index: linux-mm/mm/memory.c
===================================================================
--- linux-mm.orig/mm/memory.c    2007-04-26 19:57:14.000000000 +0200
+++ linux-mm/mm/memory.c 2007-04-26 20:00:30.000000000 +0200
@@ -1488,7 +1488,7 @@
        pte_t *pte;
        int err;
        struct page *pmd_page;
-       spinlock_t *ptl;
+       spinlock_t *ptl = NULL;

        pte = (mm == &init_mm) ?
                pte_alloc_kernel(pmd, addr) :

-- 
Regards/Gruﬂ,
    Boris.
