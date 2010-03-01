Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435Ab0CAITW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 03:19:22 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:39333 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015Ab0CAITV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 03:19:21 -0500
Date: Mon, 1 Mar 2010 09:19:20 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "czoccolo@gmail.com" <czoccolo@gmail.com>,
       "vgoyal@redhat.com" <vgoyal@redhat.com>,
       "jmoyer@redhat.com" <jmoyer@redhat.com>,
       "guijianfeng@cn.fujitsu.com" <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH] cfq-iosched: quantum check tweak --resend
Message-ID: <20100301081920.GQ5768@kernel.dk>
References: <20100301015047.GA16630@sli10-desk.sh.intel.com> <20100301080233.GO5768@kernel.dk> <20100301081524.GA28563@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100301081524.GA28563@sli10-desk.sh.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 01 2010, Shaohua Li wrote:
> On Mon, Mar 01, 2010 at 04:02:34PM +0800, Jens Axboe wrote:
> > On Mon, Mar 01 2010, Shaohua Li wrote:
> > > Currently a queue can only dispatch up to 4 requests if there are other queues.
> > > This isn't optimal, device can handle more requests, for example, AHCI can
> > > handle 31 requests. I can understand the limit is for fairness, but we could
> > > do a tweak: if the queue still has a lot of slice left, sounds we could
> > > ignore the limit. Test shows this boost my workload (two thread randread of
> > > a SSD) from 78m/s to 100m/s.
> > > Thanks for suggestions from Corrado and Vivek for the patch.
> > 
> > As mentioned before, I think we definitely want to ensure that we drive
> > the full queue depth whenever possible. I think your patch is a bit
> > dangerous, though. The problematic workload here is a buffered write,
> > interleaved with the occasional sync reader. If the sync reader has to
> > endure 32 requests every time, latency rises dramatically for him.
> the patch still matains a hardlimit for dispatched request. For a async,
> the limit is cfq_slice_async/cfq_slice_idle = 5. For sync, the limit is 8.
> And we only pipe out such number of requests at the begining of a slice.
> For the workload you mentioned here, we only dispatch 1 extra request.

OK, that sound appropriate. Final question - why change the quantum and
use quantum/2?

-- 
Jens Axboe

