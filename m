Return-Path: <linux-kernel-owner+w=401wt.eu-S1758136AbZIFSmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136AbZIFSmO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 14:42:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758108AbZIFSmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 14:42:13 -0400
Received: from brick.kernel.dk ([93.163.65.50]:50905 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758094AbZIFSmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 14:42:12 -0400
Date: Sun, 6 Sep 2009 20:42:14 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       "chris.mason" <chris.mason@oracle.com>, linux-mm <linux-mm@kvack.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [RFC PATCH] v2 mm: balance_dirty_pages.  reduce calls to
	global_page_state to reduce cache references
Message-ID: <20090906184214.GL18599@kernel.dk>
References: <1252062330.2271.61.camel@castor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252062330.2271.61.camel@castor>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 04 2009, Richard Kennedy wrote:
> Reducing the number of times balance_dirty_pages calls global_page_state
> reduces the cache references and so improves write performance on a
> variety of workloads.
> 
> 'perf stats' of simple fio write tests shows the reduction in cache
> access.
> Where the test is fio 'write,mmap,600Mb,pre_read' on AMD AthlonX2 with
> 3Gb memory (dirty_threshold approx 600 Mb)
> running each test 10 times, dropping the fasted & slowest values then
> taking 
> the average & standard deviation
> 
> 		average (s.d.) in millions (10^6)
> 2.6.31-rc8	648.6 (14.6)
> +patch		620.1 (16.5)

This patch looks good to me, I have workloads too here where up to 10%
of the time is spent in balance_dirty_pages() because of this. I'll give
this patch a go on the box and test in question tomorrow, but it looks
promising.

-- 
Jens Axboe

