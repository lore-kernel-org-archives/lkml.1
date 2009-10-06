Return-Path: <linux-kernel-owner+w=401wt.eu-S1755619AbZJFANB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619AbZJFANB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 20:13:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755509AbZJFANB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 20:13:01 -0400
Received: from mga14.intel.com ([143.182.124.37]:26302 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754606AbZJFANA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 20:13:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,508,1249282800"; 
   d="scan'208";a="195419804"
Date: Tue, 6 Oct 2009 08:12:12 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH] NFS: introduce writeback wait queue
Message-ID: <20091006001212.GA6241@localhost>
References: <20091004030153.GA20327@localhost> <20091004030504.GA20644@localhost> <20091005110010.GW26573@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091005110010.GW26573@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 05, 2009 at 07:00:11PM +0800, Jens Axboe wrote:
> On Sun, Oct 04 2009, Wu Fengguang wrote:
> > Hi Jens,
> > 
> > This is a bug fix for 2.6.32. Maybe other not block-queue based
> > filesystems will have similar issues ..
> 
> Not that I'm aware of, the NFS use is fairly special. Given that this is

Sorry for the confusion. 2.6.32 is safe.  I tested NFS, fuse and cifs.
NFS writes will be throttled at the dirty limit, and fuse/cifs see
near zero nr_writeback/nr_dirty numbers during heavy write.

NFS and fuse does set the bdi congestion state and somehow expects it to
backoff background flushing. This IO priority thing could be fixed for
next merged window.

> purely in the realm of nfs/, I'll let Trond decide how to include and
> push this (when a final patch is agreed upon).
> 
> Thanks for looking into this!

Thanks,
Fengguang
