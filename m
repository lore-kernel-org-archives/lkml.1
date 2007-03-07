Return-Path: <linux-kernel-owner+w=401wt.eu-S1422947AbXCGRUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422947AbXCGRUk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:20:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422930AbXCGRTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:19:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43927 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422905AbXCGRSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:18:49 -0500
Message-Id: <20070307171711.311565465@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:12:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       mm-commits@vger.kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, jwhiter@redhat.com, swhiteho@redhat.com
Subject: [patch 101/101] gfs2: fix locking mistake
Content-Disposition: inline; filename=gfs2-fix-locking-mistake.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josef Whiter <jwhiter@redhat.com>

Fix a locking mistake in the quota code, we do a mutex_lock instead of a
mutex_unlock.

Signed-off-by: Josef Whiter <jwhiter@redhat.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/gfs2/quota.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.20.1.orig/fs/gfs2/quota.c
+++ linux-2.6.20.1/fs/gfs2/quota.c
@@ -279,7 +279,7 @@ static int bh_get(struct gfs2_quota_data
 		(bh->b_data + sizeof(struct gfs2_meta_header) +
 		 offset * sizeof(struct gfs2_quota_change));
 
-	mutex_lock(&sdp->sd_quota_mutex);
+	mutex_unlock(&sdp->sd_quota_mutex);
 
 	return 0;
 

--
