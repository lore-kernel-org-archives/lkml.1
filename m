Return-Path: <linux-kernel-owner+w=401wt.eu-S1753586AbZHaRcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbZHaRcX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 13:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbZHaRcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 13:32:22 -0400
Received: from brick.kernel.dk ([93.163.65.50]:60244 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765AbZHaRcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 13:32:22 -0400
Date: Mon, 31 Aug 2009 19:32:24 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, akpm@linux-foundation.org,
       jack@suse.cz
Subject: Re: [PATCH 05/10] writeback: support > 1 flusher thread per bdi
Message-ID: <20090831173223.GY12579@kernel.dk>
References: <1251720891-19793-1-git-send-email-jens.axboe@oracle.com> <1251720891-19793-6-git-send-email-jens.axboe@oracle.com> <20090831130125.GC20465@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090831130125.GC20465@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31 2009, Christoph Hellwig wrote:
> On Mon, Aug 31, 2009 at 02:14:46PM +0200, Jens Axboe wrote:
> > Build on the bdi_writeback support by allowing registration of
> > more than 1 flusher thread. File systems can call bdi_add_flusher_task(bdi)
> > to add more flusher threads to the device. If they do so, they must also
> > provide a super_operations function to return the suitable bdi_writeback
> > struct from any given inode.
> 
> Please drop this for now.  It adds a lot of unused and untestede code
> including a dead on arrival inode operation.

OK, will drop the multi thread support, I'll retain the worker items
though.

> Once we are going to add actual multiple flusher threads we can revise
> it.  But I don't think for example that the operation in it's current
> form makese too much sense - the most logical way to add multiple
> flushers per filesystems would be having multiple bdis of some sort.

Sure, it was more of a proof-of-concept, since I think it'll be
important at higher buffered output rates with a single thread becoming
a bottle neck. But I have no issues with dropping it for now, it'll be
easy enough to re-introduce.

I'll post an updated patch series later tonight/tomorrow with the
changes.

-- 
Jens Axboe

