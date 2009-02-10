Return-Path: <linux-kernel-owner+w=401wt.eu-S1757602AbZBJTT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602AbZBJTT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 14:19:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755935AbZBJTES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 14:04:18 -0500
Received: from kroah.org ([198.145.64.141]:54111 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755948AbZBJTEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 14:04:15 -0500
Date: Tue, 10 Feb 2009 11:01:25 -0800
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
       alan@lxorguk.ukuu.org.uk, Lachlan McIlroy <lachlan@sgi.com>,
       Neil Brown <neilb@suse.de>
Subject: [patch 45/53] XFS: set b_error from bio error in xfs_buf_bio_end_io
Message-ID: <20090210190125.GT14308@kroah.com>
References: <20090210185337.000769713@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="xfs-set-b_error-from-bio-error-in-xfs_buf_bio_end_io.patch"
In-Reply-To: <20090210185924.GA14308@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Lachlan McIlroy <lachlan@redback.melbourne.sgi.com>

commit cfbe52672fbc6f333892e8dde82c35e0a76aa5f5 upstream.

Preserve any error returned by the bio layer.

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>
Reviewed-by: Tim Shimmin <tes@sgi.com>
Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/linux-2.6/xfs_buf.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -1114,8 +1114,7 @@ xfs_buf_bio_end_io(
 	unsigned int		blocksize = bp->b_target->bt_bsize;
 	struct bio_vec		*bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
 
-	if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
-		bp->b_error = EIO;
+	xfs_buf_ioerror(bp, -error);
 
 	do {
 		struct page	*page = bvec->bv_page;

