Return-Path: <linux-kernel-owner+w=401wt.eu-S1752787AbZIGKLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbZIGKLa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 06:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbZIGKLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 06:11:30 -0400
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:47197 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752616AbZIGKL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 06:11:29 -0400
Subject: Re: [RFC PATCH] v2 mm: balance_dirty_pages.  reduce calls to
 global_page_state to reduce cache references
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       "chris.mason" <chris.mason@oracle.com>, linux-mm <linux-mm@kvack.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <20090906184214.GL18599@kernel.dk>
References: <1252062330.2271.61.camel@castor>
	 <20090906184214.GL18599@kernel.dk>
Content-Type: text/plain
Date: Mon, 07 Sep 2009 11:11:30 +0100
Message-Id: <1252318290.2348.20.camel@castor>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-09-06 at 20:42 +0200, Jens Axboe wrote:
> On Fri, Sep 04 2009, Richard Kennedy wrote:
> > Reducing the number of times balance_dirty_pages calls global_page_state
> > reduces the cache references and so improves write performance on a
> > variety of workloads.
> > 
> > 'perf stats' of simple fio write tests shows the reduction in cache
> > access.
> > Where the test is fio 'write,mmap,600Mb,pre_read' on AMD AthlonX2 with
> > 3Gb memory (dirty_threshold approx 600 Mb)
> > running each test 10 times, dropping the fasted & slowest values then
> > taking 
> > the average & standard deviation
> > 
> > 		average (s.d.) in millions (10^6)
> > 2.6.31-rc8	648.6 (14.6)
> > +patch		620.1 (16.5)
> 
> This patch looks good to me, I have workloads too here where up to 10%
> of the time is spent in balance_dirty_pages() because of this. I'll give
> this patch a go on the box and test in question tomorrow, but it looks
> promising.
> 

Thanks Jens, 

It will be interesting to see how it works on different hardware &
workload. How many cores are you going to run it on?
wow 10% in balance_dirty_pages! Is that on a large server? or do you
think its peculiar to your workload?

regards
Richard

