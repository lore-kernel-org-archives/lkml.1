Return-Path: <linux-kernel-owner+w=401wt.eu-S1752624AbYLYVdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbYLYVdI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 16:33:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbYLYVcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 16:32:55 -0500
Received: from os.inf.tu-dresden.de ([141.76.48.99]:40963 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbYLYVcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 16:32:55 -0500
X-Greylist: delayed 1818 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Dec 2008 16:32:54 EST
Date: Thu, 25 Dec 2008 22:02:35 +0100
From: Adam Lackorzynski <adam@os.inf.tu-dresden.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] 2.6.28, vmalloc.c, vmap_page_range
Message-ID: <20081225210235.GC5431@os.inf.tu-dresden.de>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

in 2.6.28, the flush_cache_vmap in vmap_page_range() is called with the end of
the range twice. The following patch fixes this for me.

Signed-off-by: Adam Lackorzynski <adam@os.inf.tu-dresden.de>
---
 vmalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.28/mm/vmalloc.c	2008-12-25 00:26:37.000000000 +0100
+++ linux-2.6.28.a/mm/vmalloc.c	2008-12-25 21:45:43.118725744 +0100
@@ -155,7 +155,7 @@
 				pgprot_t prot, struct page **pages)
 {
 	pgd_t *pgd;
-	unsigned long next;
+	unsigned long next, start = addr;
 	int err = 0;
 	int nr = 0;
 
@@ -167,7 +167,7 @@
 		if (err)
 			break;
 	} while (pgd++, addr = next, addr != end);
-	flush_cache_vmap(addr, end);
+	flush_cache_vmap(start, end);
 
 	if (unlikely(err))
 		return err;




Adam
-- 
Adam                 adam@os.inf.tu-dresden.de
  Lackorzynski         http://os.inf.tu-dresden.de/~adam/
