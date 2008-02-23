Return-Path: <linux-kernel-owner+w=401wt.eu-S936547AbYBWAqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936547AbYBWAqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:46:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765266AbYBWAfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:35:44 -0500
Received: from cantor.suse.de ([195.135.220.2]:44928 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935308AbYBWAfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:35:41 -0500
Date: Fri, 22 Feb 2008 16:31:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Christoph Lameter <clameter@sgi.com>
Subject: [patch 27/38] SLUB: Deal with annoying gcc warning on kfree()
Message-ID: <20080223003114.GB7268@suse.de>
References: <20080223001946.979768610@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="slub-deal-with-annoying-gcc-warning-on-kfree.patch"
In-Reply-To: <20080223002907.GA7268@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Christoph Lameter <clameter@sgi.com>

patch 5bb983b0cce9b7b281af15730f7019116dd42568 in mainline.

gcc 4.2 spits out an annoying warning if one casts a const void *
pointer to a void * pointer. No warning is generated if the
conversion is done through an assignment.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/slub.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2592,6 +2592,7 @@ EXPORT_SYMBOL(ksize);
 void kfree(const void *x)
 {
 	struct page *page;
+	void *object = (void *)x;
 
 	if (unlikely(ZERO_OR_NULL_PTR(x)))
 		return;
@@ -2601,7 +2602,7 @@ void kfree(const void *x)
 		put_page(page);
 		return;
 	}
-	slab_free(page->slab, page, (void *)x, __builtin_return_address(0));
+	slab_free(page->slab, page, object, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(kfree);
 

-- 
