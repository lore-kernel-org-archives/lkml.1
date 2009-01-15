Return-Path: <linux-kernel-owner+w=401wt.eu-S932968AbZAOUOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968AbZAOUOr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:14:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765907AbZAOUAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:00:50 -0500
Received: from kroah.org ([198.145.64.141]:48955 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765334AbZAOUAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:00:37 -0500
Date: Thu, 15 Jan 2009 11:58:04 -0800
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
       alan@lxorguk.ukuu.org.uk, NeilBrown <neilb@suse.de>
Subject: [patch 23/94] md: fix bitmap-on-external-file bug.
Message-ID: <20090115195804.GW14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="md-fix-bitmap-on-external-file-bug.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: NeilBrown <neilb@suse.de>

commit 538452700d95480c16e7aa6b10ff77cd937d33f4 upstream.

commit a2ed9615e3222645007fc19991aedf30eed3ecfd
fixed a bug with 'internal' bitmaps, but in the process broke
'in a file' bitmaps.  So they are broken in 2.6.28

This fixes it, and needs to go in 2.6.28-stable.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/bitmap.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -964,9 +964,11 @@ static int bitmap_init_from_disk(struct 
 				 */
 				page = bitmap->sb_page;
 				offset = sizeof(bitmap_super_t);
-				read_sb_page(bitmap->mddev, bitmap->offset,
-					     page,
-					     index, count);
+				if (!file)
+					read_sb_page(bitmap->mddev,
+						     bitmap->offset,
+						     page,
+						     index, count);
 			} else if (file) {
 				page = read_page(file, index, bitmap, count);
 				offset = 0;

