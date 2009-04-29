Return-Path: <linux-kernel-owner+w=401wt.eu-S1759455AbZD2WgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759455AbZD2WgA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 18:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759668AbZD2WVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 18:21:43 -0400
Received: from kroah.org ([198.145.64.141]:40532 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759938AbZD2WVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 18:21:39 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Apr 29 15:09:28 2009
Message-Id: <20090429220928.710421504@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 29 Apr 2009 15:07:37 -0700
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
Subject: [patch 38/58] agp: zero pages before sending to userspace
References: <20090429220659.339950874@mini.kroah.org>
Content-Disposition: inline; filename=0093-agp-zero-pages-before-sending-to-userspace.patch
In-Reply-To: <20090429221657.GA11765@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

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
 drivers/char/agp/generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/agp/generic.c
+++ b/drivers/char/agp/generic.c
@@ -1207,7 +1207,7 @@ void *agp_generic_alloc_page(struct agp_
 {
 	struct page * page;
 
-	page = alloc_page(GFP_KERNEL | GFP_DMA32);
+	page = alloc_page(GFP_KERNEL | GFP_DMA32 | __GFP_ZERO);
 	if (page == NULL)
 		return NULL;
 


