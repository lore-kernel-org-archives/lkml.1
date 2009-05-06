Return-Path: <linux-kernel-owner+w=401wt.eu-S1761649AbZEFWEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761649AbZEFWEt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759831AbZEFVyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:54:43 -0400
Received: from kroah.org ([198.145.64.141]:57133 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761396AbZEFVyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:54:40 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed May  6 14:47:58 2009
Message-Id: <20090506214758.773043321@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 14:45:53 -0700
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
       alan@lxorguk.ukuu.org.uk,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [patch 25/58] bio: fix memcpy corruption in bio_copy_user_iov()
References: <20090506214528.660389067@mini.kroah.org>
Content-Disposition: inline; filename=bio-fix-memcpy-corruption-in-bio_copy_user_iov.patch
In-Reply-To: <20090506215017.GA21981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

commit 69838727bcd819a8fd73a88447801221788b0c6d upstream.

st driver uses blk_rq_map_user() in order to just build a request out
of page frames. In this case, map_data->offset is a non zero value and
iov[0].iov_base is NULL. We need to increase nr_pages for that.

Cc: stable@kernel.org
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/bio.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/bio.c
+++ b/fs/bio.c
@@ -806,6 +806,9 @@ struct bio *bio_copy_user_iov(struct req
 		len += iov[i].iov_len;
 	}
 
+	if (offset)
+		nr_pages++;
+
 	bmd = bio_alloc_map_data(nr_pages, iov_count, gfp_mask);
 	if (!bmd)
 		return ERR_PTR(-ENOMEM);


