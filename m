Return-Path: <linux-kernel-owner+w=401wt.eu-S1754235AbZCIJVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbZCIJVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 05:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753582AbZCIJVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 05:21:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55157 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753997AbZCIJV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 05:21:29 -0400
Message-ID: <49B4DF9C.3090102@cn.fujitsu.com>
Date: Mon, 09 Mar 2009 17:21:32 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: fix memory leak in bio_clone()
References: <49B4DD9C.5030902@cn.fujitsu.com>
In-Reply-To: <49B4DD9C.5030902@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, there was a typo in the previous patch..

=============

From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] block: fix memory leak in bio_clone()

If bio_integrity_clone() fails, bio_clone() returns NULL without freeing
the newly allocated bio.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/bio.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 124b95c..c687847 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -465,8 +465,10 @@ struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask)
 
 		ret = bio_integrity_clone(b, bio, fs_bio_set);
 
-		if (ret < 0)
+		if (ret < 0) {
+			bio_put(b);
 			return NULL;
+		}
 	}
 
 	return b;
-- 
1.5.4.rc3

