Return-Path: <linux-kernel-owner+w=401wt.eu-S935023AbYAaWOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935023AbYAaWOl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 17:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934491AbYAaWKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 17:10:47 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:40304 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934361AbYAaWKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 17:10:38 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Andy Whitcroft <apw@shadowen.org>,
       Mel Gorman <mel@csn.ul.ie>, Christoph Lameter <clameter@sgi.com>
Subject: [PATCH] mm: fix section mismatch warning in sparse.c
Date: Thu, 31 Jan 2008 23:10:36 +0100
Message-Id: <1201817440-5081-7-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.3.5.628.ga1309
In-Reply-To: <20080131220430.GA4874@uranus.ravnborg.org>
References: <20080131220430.GA4874@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warning:
WARNING: mm/built-in.o(.text+0x22069): Section mismatch in reference from the function sparse_early_usemap_alloc() to the function .init.text:__alloc_bootmem_node()

static sparse_early_usemap_alloc() were used only by sparse_init()
and with sparse_init() annotated _init it is safe to
annotate sparse_early_usemap_alloc with __init too.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <clameter@sgi.com>
---
 mm/sparse.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/sparse.c b/mm/sparse.c
index a2183cb..231c7b5 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -237,7 +237,7 @@ static unsigned long *__kmalloc_section_usemap(void)
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
-static unsigned long *sparse_early_usemap_alloc(unsigned long pnum)
+static unsigned long *__init sparse_early_usemap_alloc(unsigned long pnum)
 {
 	unsigned long *usemap;
 	struct mem_section *ms = __nr_to_section(pnum);
-- 
1.5.4.rc3.14.g44397

