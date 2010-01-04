Return-Path: <linux-kernel-owner+w=401wt.eu-S1753769Ab0ADSdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab0ADSdK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 13:33:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753722Ab0ADSdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 13:33:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753599Ab0ADSdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 13:33:02 -0500
Date: Mon, 4 Jan 2010 13:32:55 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, Jens Axboe <jens.axboe@oracle.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH] cfq-iosched: non-rot devices do not need read queue
	merging
Message-ID: <20100104183255.GE7968@redhat.com>
References: <20091230213439.GQ4489@kernel.dk> <1262211768-10858-1-git-send-email-czoccolo@gmail.com> <20100104144711.GA7968@redhat.com> <4e5e476b1001040836p2c8d7486x807a1a89b61c2458@mail.gmail.com> <x49wrzxak5n.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49wrzxak5n.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 04, 2010 at 11:51:00AM -0500, Jeff Moyer wrote:
> Corrado Zoccolo <czoccolo@gmail.com> writes:
> 
> > Hi Vivkek,
> >
> > On Mon, Jan 4, 2010 at 3:47 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> On Wed, Dec 30, 2009 at 11:22:47PM +0100, Corrado Zoccolo wrote:
> >>> Non rotational devices' performances are not affected by
> >>> distance of read requests, so there is no point in having
> >>> overhead to merge such queues.
> >>> This doesn't apply to writes, so this patch changes the
> >>> queued[] field, to be indexed by READ/WRITE instead of
> >>> SYNC/ASYNC, and only compute proximity for queues with
> >>> WRITE requests.
> >>>
> >>
> >> Hi Corrado,
> >>
> >> What's the reason that reads don't benefit from merging queues and hence
> >> merging requests and only writes do on SSD?
> >
> > On SSDs, reads are just limited by the maximum transfer rate, and
> > larger (i.e. merged) reads will just take proportionally longer.
> 
> This is simply not true.  You can get more bandwidth from an SSD (I just
> checked numbers for 2 vendors' devices) by issuing larger read requests,
> no matter whether the access pattern is sequential or random.
> 

In my simple testing of 4 fio threads doing direct sequential reads
throughput varies significantly if I vary bs from 4K to 128K.

bs=4K		65MB/s
bs=128K		228MB/s

Thanks
Vivek
