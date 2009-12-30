Return-Path: <linux-kernel-owner+w=401wt.eu-S1753198AbZL3Srv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbZL3Srv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 13:47:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbZL3Sru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 13:47:50 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:47491 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127AbZL3Sru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 13:47:50 -0500
Date: Wed, 30 Dec 2009 19:47:49 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
       Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH] cfq-iosched: replace sync_flight by
	rq_in_driver[BLK_RW_SYNC]
Message-ID: <20091230184748.GF4489@kernel.dk>
References: <1262185738-11942-1-git-send-email-czoccolo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262185738-11942-1-git-send-email-czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 30 2009, Corrado Zoccolo wrote:
> According to my intuition (and brief testing), sync_flight is always
> equal to rq_in_driver[BLK_RW_SYNC] at the point of usage, so it can
> be removed and replaced by the other.

They are not fully identical. ->sync_flight is incremented on insertion
on the dispatch list, ->rq_in_driver not until the request is activated
(eg the driver has retrieved it and wants to dispatch to the hardware).
They will usually be identical, but that may not be true for requeues
for instance.

-- 
Jens Axboe

