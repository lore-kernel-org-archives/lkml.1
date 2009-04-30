Return-Path: <linux-kernel-owner+w=401wt.eu-S1765699AbZD3Rak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765699AbZD3Rak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764661AbZD3RIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:08:11 -0400
Received: from kroah.org ([198.145.64.141]:56648 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764630AbZD3RH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:07:58 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:46 2009
Message-Id: <20090430165745.938579337@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:56:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Shaohua Li <shaohua.li@intel.com>,
       Dave Airlie <airlied@redhat.com>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch 51/88] agp: zero pages before sending to userspace
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=0093-agp-zero-pages-before-sending-to-userspace.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Shaohua Li <shaohua.li@intel.com>

upstream commit: 59de2bebabc5027f93df999d59cc65df591c3e6e

CVE-2009-1192

AGP pages might be mapped into userspace finally, so the pages should be
set to zero before userspace can use it. Otherwise there is potential
information leakage.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/agp/generic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/char/agp/generic.c
+++ b/drivers/char/agp/generic.c
@@ -1226,7 +1226,7 @@ int agp_generic_alloc_pages(struct agp_b
 	int i, ret = -ENOMEM;
 
 	for (i = 0; i < num_pages; i++) {
-		page = alloc_page(GFP_KERNEL | GFP_DMA32);
+		page = alloc_page(GFP_KERNEL | GFP_DMA32 | __GFP_ZERO);
 		/* agp_free_memory() needs gart address */
 		if (page == NULL)
 			goto out;
@@ -1257,7 +1257,7 @@ void *agp_generic_alloc_page(struct agp_
 {
 	struct page * page;
 
-	page = alloc_page(GFP_KERNEL | GFP_DMA32);
+	page = alloc_page(GFP_KERNEL | GFP_DMA32 | __GFP_ZERO);
 	if (page == NULL)
 		return NULL;
 


