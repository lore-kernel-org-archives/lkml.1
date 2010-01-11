Return-Path: <linux-kernel-owner+w=401wt.eu-S1752967Ab0AKBrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab0AKBrq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 20:47:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827Ab0AKBrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 20:47:46 -0500
Received: from mga09.intel.com ([134.134.136.24]:63787 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919Ab0AKBrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 20:47:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,252,1262592000"; 
   d="scan'208";a="482919968"
Date: Mon, 11 Jan 2010 09:47:30 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Yanmin Zhang <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH] cfq-iosched: rework seeky detection
Message-ID: <20100111014730.GA22362@sli10-desk.sh.intel.com>
References: <1263052757-23436-1-git-send-email-czoccolo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263052757-23436-1-git-send-email-czoccolo@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 09, 2010 at 11:59:17PM +0800, Corrado Zoccolo wrote:
> Current seeky detection is based on average seek lenght.
> This is suboptimal, since the average will not distinguish between:
> * a process doing medium sized seeks
> * a process doing some sequential requests interleaved with larger seeks
> and even a medium seek can take lot of time, if the requested sector
> happens to be behind the disk head in the rotation (50% probability).
> 
> Therefore, we change the seeky queue detection to work as follows:
> * each request can be classified as sequential if it is very close to
>   the current head position, i.e. it is likely in the disk cache (disks
>   usually read more data than requested, and put it in cache for
>   subsequent reads). Otherwise, the request is classified as seeky.
> * an history window of the last 32 requests is kept, storing the
>   classification result.
> * A queue is marked as seeky if more than 1/8 of the last 32 requests
>   were seeky.
> 
> This patch fixes a regression reported by Yanmin, on mmap 64k random
> reads.
Can we not count a big request (say the request data is >= 32k) as seeky
regardless the seek distance? In this way we can also make a 64k random sync
read not as seeky.

Thanks,
Shaohua
