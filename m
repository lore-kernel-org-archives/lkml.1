Return-Path: <linux-kernel-owner+w=401wt.eu-S1752291AbZKCScc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbZKCScc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 13:32:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbZKCScb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 13:32:31 -0500
Received: from [95.166.99.235] ([95.166.99.235]:44435 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbZKCScb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 13:32:31 -0500
Date: Tue, 3 Nov 2009 19:32:36 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Shi, Alex" <alex.shi@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: kernel building regression on 32-rc5 kernel
Message-ID: <20091103183235.GD8742@kernel.dk>
References: <F7C8A4D3A9905B45A80E4C194793FA651553C00D3D@PDSMSX501.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F7C8A4D3A9905B45A80E4C194793FA651553C00D3D@PDSMSX501.ccr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 03 2009, Shi, Alex wrote:
> I found the kernel building will have about 20%~ 30% regressions on
> our NHM machines. My kernel build do the following things 15 times:
> 
> make mrproper; echo \"3\">/proc/sys/vm/drop_caches; make defconfig;
> make -j${2timescpunumbers}
> 
> 
> 
> Bisect found it is due to the commitment:
> 
> commit a6151c3a5c8e1ff5a28450bc8d6a99a2a0add0a7

I looked over that commit and found one typo, can you check with this
patch applied?

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 069a610..5802e32 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2051,7 +2051,7 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
 	 * it's a metadata request and the current queue is doing regular IO.
 	 */
 	if (rq_is_meta(rq) && !cfqq->meta_pending)
-		return false;
+		return true;
 
 	/*
 	 * Allow an RT request to pre-empt an ongoing non-RT cfqq timeslice.

-- 
Jens Axboe

