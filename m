Return-Path: <linux-kernel-owner+w=401wt.eu-S1753257AbZL3Sph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbZL3Sph (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 13:45:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbZL3Sph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 13:45:37 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:47470 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830AbZL3Spg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 13:45:36 -0500
Date: Wed, 30 Dec 2009 19:45:35 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
       Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH] cfq-iosched: non-rot devices do not need queue merging
Message-ID: <20091230184535.GE4489@kernel.dk>
References: <1262175004-2132-1-git-send-email-czoccolo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262175004-2132-1-git-send-email-czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 30 2009, Corrado Zoccolo wrote:
> Non rotational devices' performances are not affected by
> distance of requests, so there is no point in having overhead
> to merge queues of nearby requests.

If the distance is zero, it may still make a big difference (at least
for writes). This check would be better as "ncq and doesn't suck", ala

        blk_queue_nonrot(q) && tagged

like we do elsewhere.

-- 
Jens Axboe

