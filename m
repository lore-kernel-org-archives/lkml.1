Return-Path: <linux-kernel-owner+w=401wt.eu-S1756802AbZHFVfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbZHFVfH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 17:35:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756773AbZHFVfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 17:35:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44967 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756084AbZHFVfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 17:35:04 -0400
Date: Thu, 6 Aug 2009 17:35:05 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr, fweisbec@gmail.com,
       Alan.Brunelle@hp.com
Subject: Re: [PATCH 1/9] writeback: move dirty inodes from super_block to
	backing_dev_info
Message-ID: <20090806213505.GB20538@infradead.org>
References: <1248989044-21605-1-git-send-email-jens.axboe@oracle.com> <1248989044-21605-2-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248989044-21605-2-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 11:23:56PM +0200, Jens Axboe wrote:
> This is a first step at introducing per-bdi flusher threads. We should
> have no change in behaviour, although sb_has_dirty_inodes() is now
> ridiculously expensive, as there's no easy way to answer that question.
> Not a huge problem, since it'll be deleted in subsequent patches.

Looking at this again and again I don't really like this at all. What
is the problem with having per-bdi flushing threads that just iterate
a list of superblocks per-bdi and then the inodes from there?  That
would keep a lot of the calling conventions much more logical, as we
have to writeback data per-sb for all data integrity and some other
writes.

