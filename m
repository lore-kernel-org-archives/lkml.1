Return-Path: <linux-kernel-owner+w=401wt.eu-S965131AbXGaEdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965131AbXGaEdx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 00:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965963AbXGaEbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 00:31:24 -0400
Received: from canuck.infradead.org ([209.217.80.40]:34523 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967452AbXGaEbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 00:31:20 -0400
Date: Mon, 30 Jul 2007 21:32:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, agk@redhat.com,
       Milan Broz <mbroz@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 09/26] dm crypt: disable barriers
Message-ID: <20070731043209.GJ3975@kroah.com>
References: <20070731042108.546594256@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dm-crypt-disable-barriers.patch"
In-Reply-To: <20070731043047.GA3975@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Milan Broz <mbroz@redhat.com>

Disable barriers in dm-crypt because of current workqueue processing can
reorder requests.

This must be addresed later but for now disabling barriers is needed to
prevent data corruption.

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9c89f8be1a7d14aad9d2c3f7d90d7d88f82c61e2

 drivers/md/dm-crypt.c |    3 +++
 1 file changed, 3 insertions(+)

--- linux-2.6.21.6.orig/drivers/md/dm-crypt.c
+++ linux-2.6.21.6/drivers/md/dm-crypt.c
@@ -954,6 +954,9 @@ static int crypt_map(struct dm_target *t
 	struct crypt_config *cc = ti->private;
 	struct crypt_io *io;
 
+	if (bio_barrier(bio))
+		return -EOPNOTSUPP;
+
 	io = mempool_alloc(cc->io_pool, GFP_NOIO);
 	io->target = ti;
 	io->base_bio = bio;

-- 
