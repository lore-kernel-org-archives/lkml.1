Return-Path: <linux-kernel-owner+w=401wt.eu-S932376AbZGABaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376AbZGABaJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:30:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763137AbZGAB3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 21:29:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56972 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759803AbZGAB3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 21:29:53 -0400
Date: Tue, 30 Jun 2009 21:28:27 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com,
       agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org
Subject: Re: [PATCH 02/20] io-controller: Common flat fair queuing code in
	elevaotor layer
Message-ID: <20090701012827.GA13958@redhat.com>
References: <1245443858-8487-1-git-send-email-vgoyal@redhat.com> <1245443858-8487-3-git-send-email-vgoyal@redhat.com> <4A49B364.5000508@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A49B364.5000508@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 02:40:36PM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> ...
> > +
> > +/*
> > + * Do the accounting. Determine how much service (in terms of time slices)
> > + * current queue used and adjust the start, finish time of queue and vtime
> > + * of the tree accordingly.
> > + *
> > + * Determining the service used in terms of time is tricky in certain
> > + * situations. Especially when underlying device supports command queuing
> > + * and requests from multiple queues can be there at same time, then it
> > + * is not clear which queue consumed how much of disk time.
> > + *
> > + * To mitigate this problem, cfq starts the time slice of the queue only
> > + * after first request from the queue has completed. This does not work
> > + * very well if we expire the queue before we wait for first and more
> > + * request to finish from the queue. For seeky queues, we will expire the
> > + * queue after dispatching few requests without waiting and start dispatching
> > + * from next queue.
> > + *
> > + * Not sure how to determine the time consumed by queue in such scenarios.
> > + * Currently as a crude approximation, we are charging 25% of time slice
> > + * for such cases. A better mechanism is needed for accurate accounting.
> > + */
> 
>   Hi Vivek,
> 
>   The comment is out of date, would you update it accordingly?
> 

Thanks Gui. Yes, I will update it in next posting.

Vivek
