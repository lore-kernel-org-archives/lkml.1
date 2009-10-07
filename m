Return-Path: <linux-kernel-owner+w=401wt.eu-S933046AbZJGMcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933046AbZJGMcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 08:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932985AbZJGMcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 08:32:50 -0400
Received: from tservice.ru ([195.178.208.66]:46478 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932969AbZJGMct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 08:32:49 -0400
Date: Wed, 7 Oct 2009 16:32:11 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Li Shaohua <shaohua.li@intel.com>,
       Myklebust Trond <Trond.Myklebust@netapp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@suse.de>,
       linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/45] writeback: quit on wrap for .range_cyclic (pohmelfs)
Message-ID: <20091007123211.GA29371@ioremap.net>
References: <20091007073818.318088777@intel.com> <20091007074902.268825252@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091007074902.268825252@intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Wed, Oct 07, 2009 at 03:38:27PM +0800, Wu Fengguang (fengguang.wu@intel.com) wrote:
> Convert wbc.range_cyclic to new behavior: when past EOF, abort writeback
> of the inode, which instructs writeback_single_inode() to delay it for 
> a while if necessary.
> 
> It removes one inefficient .range_cyclic IO pattern when writeback_index
> wraps:
> 	submit [10000-10100], (wrap), submit [0-100]
> In which the submitted pages may be consisted of two distant ranges.
> 
> It also prevents submitting pointless IO for busy overwriters.

I have no objections against this patchset, since I followed the
upstream writeback behaviour and did not personally observe such wraps
which would be otherwise handled in a single run.

> CC: Evgeniy Polyakov <zbr@ioremap.net>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

-- 
	Evgeniy Polyakov
