Return-Path: <linux-kernel-owner+w=401wt.eu-S1754771AbYKLAaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbYKLAaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:30:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbYKLA0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:26:14 -0500
Received: from kroah.org ([198.145.64.141]:42175 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753298AbYKLA0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:26:12 -0500
Date: Tue, 11 Nov 2008 16:23:14 -0800
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
       alan@lxorguk.ukuu.org.uk, Mike Miller <mike.miller@hp.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [patch 11/49] cciss: fix sysfs broken symlink regression
Message-ID: <20081112002314.GL10989@kroah.com>
References: <20081112001401.926965113@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cciss-fix-sysfs-broken-symlink-regression.patch"
In-Reply-To: <20081112002215.GA10989@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mike Miller <mike.miller@hp.com>

commit 404443081ce5e6f68b5f7eda16c959835ff200c0 upstream

Regression introduced by commit 6ae5ce8e8d4de666f31286808d2285aa6a50fa40
("cciss: remove redundant code").

This patch fixes a broken symlink in sysfs that was introduced by the
above commit.  We broke it in 2.6.27-rc on or about 20080804.  Some
installers are broken if this symlink does not exist and they may not
detect the logical drives configured on the controller.  It does not
require being backported into 2.6.26.x or earlier kernels.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/block/cciss.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1365,6 +1365,7 @@ static void cciss_add_disk(ctlr_info_t *
 	disk->first_minor = drv_index << NWD_SHIFT;
 	disk->fops = &cciss_fops;
 	disk->private_data = &h->drv[drv_index];
+	disk->driverfs_dev = &h->pdev->dev;
 
 	/* Set up queue information */
 	blk_queue_bounce_limit(disk->queue, h->pdev->dma_mask);

-- 
