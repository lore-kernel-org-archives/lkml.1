Return-Path: <linux-kernel-owner+w=401wt.eu-S1755300AbYLCTzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbYLCTzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 14:55:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbYLCTuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:50:23 -0500
Received: from kroah.org ([198.145.64.141]:59523 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751949AbYLCTuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:50:15 -0500
Date: Wed, 3 Dec 2008 11:48:43 -0800
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
       alan@lxorguk.ukuu.org.uk, Tejun Heo <tj@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Hugh Dickins <hugh@veritas.com>
Subject: [patch 013/104] lib/scatterlist.c: fix kunmap() argument in
	sg_miter_stop()
Message-ID: <20081203194843.GN8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="lib-scatterlist.c-fix-kunmap-argument-in-sg_miter_stop.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Arjan van de Ven <arjan@infradead.org>

commit f652c521e0bec2e70cf123f47e80117a7e6ed139 upstream.

kunmap() takes as argument the struct page that orginally got kmap()'d,
however the sg_miter_stop() function passed it the kernel virtual address
instead, resulting in weird stuff.

Somehow I ended up fixing this bug by accident while looking for a bug in
the same area.

Reported-by: kerneloops.org
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 lib/scatterlist.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -395,7 +395,7 @@ void sg_miter_stop(struct sg_mapping_ite
 			WARN_ON(!irqs_disabled());
 			kunmap_atomic(miter->addr, KM_BIO_SRC_IRQ);
 		} else
-			kunmap(miter->addr);
+			kunmap(miter->page);
 
 		miter->page = NULL;
 		miter->addr = NULL;

