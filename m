Return-Path: <linux-kernel-owner+w=401wt.eu-S1763481AbZAWB1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763481AbZAWB1x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 20:27:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756082AbZAWBPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 20:15:40 -0500
Received: from kroah.org ([198.145.64.141]:50896 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760002AbZAWBPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 20:15:19 -0500
Date: Thu, 22 Jan 2009 17:13:05 -0800
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
       alan@lxorguk.ukuu.org.uk, Nick Piggin <npiggin@suse.de>,
       Chris Mason <chris.mason@oracle.com>,
       Dave Chinner <david@fromorbit.com>
Subject: [patch 41/46] mm: write_cache_pages more terminate quickly
Message-ID: <20090123011305.GP19756@kroah.com>
References: <20090123010651.683741823@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mm-write_cache_pages-more-terminate-quickly.patch"
In-Reply-To: <20090123011110.GA19756@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andrew Morton <akpm@linux-foundation.org>

commit 82fd1a9a8ced9607312b54859572bcc6211e8919 upstream.

Now that we have the early-termination logic in place, it makes sense to
bail out early in all other cases where done is set to 1.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/page-writeback.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -983,12 +983,15 @@ continue_unlock:
 
 			if (wbc->sync_mode == WB_SYNC_NONE) {
 				wbc->nr_to_write--;
-				if (wbc->nr_to_write <= 0)
+				if (wbc->nr_to_write <= 0) {
 					done = 1;
+					break;
+				}
 			}
 			if (wbc->nonblocking && bdi_write_congested(bdi)) {
 				wbc->encountered_congestion = 1;
 				done = 1;
+				break;
 			}
 		}
 		pagevec_release(&pvec);

