Return-Path: <linux-kernel-owner+w=401wt.eu-S1753169AbZHaNB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbZHaNB0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 09:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbZHaNBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 09:01:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49880 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbZHaNBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 09:01:23 -0400
Date: Mon, 31 Aug 2009 09:01:25 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz
Subject: Re: [PATCH 05/10] writeback: support > 1 flusher thread per bdi
Message-ID: <20090831130125.GC20465@infradead.org>
References: <1251720891-19793-1-git-send-email-jens.axboe@oracle.com> <1251720891-19793-6-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251720891-19793-6-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31, 2009 at 02:14:46PM +0200, Jens Axboe wrote:
> Build on the bdi_writeback support by allowing registration of
> more than 1 flusher thread. File systems can call bdi_add_flusher_task(bdi)
> to add more flusher threads to the device. If they do so, they must also
> provide a super_operations function to return the suitable bdi_writeback
> struct from any given inode.

Please drop this for now.  It adds a lot of unused and untestede code
including a dead on arrival inode operation.

Once we are going to add actual multiple flusher threads we can revise
it.  But I don't think for example that the operation in it's current
form makese too much sense - the most logical way to add multiple
flushers per filesystems would be having multiple bdis of some sort.

