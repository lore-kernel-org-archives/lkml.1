Return-Path: <linux-kernel-owner+w=401wt.eu-S1756837AbZHFVoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837AbZHFVoh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 17:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756779AbZHFVoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 17:44:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43809 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756393AbZHFVog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 17:44:36 -0400
Date: Thu, 6 Aug 2009 17:44:33 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org,
       yanmin_zhang@linux.intel.com, richard@rsk.demon.co.uk,
       damien.wyart@free.fr, fweisbec@gmail.com, Alan.Brunelle@hp.com
Subject: Re: [PATCH 2/9] writeback: switch to per-bdi threads for flushing
	data
Message-ID: <20090806214433.GA866@infradead.org>
References: <1248989044-21605-1-git-send-email-jens.axboe@oracle.com> <1248989044-21605-3-git-send-email-jens.axboe@oracle.com> <20090805163532.GC27505@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090805163532.GC27505@duck.suse.cz>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 06:35:32PM +0200, Jan Kara wrote:
>   Jens, sorry about bitching about this again but you're silently changing
> substantial locking assumptions without writing it *anywhere* and without
> arguing it's safe.
>   Originally, generic_sync_sb_inodes() from writeback path have been
> called with
> a) s_umount_sem held
> b) sb->s_count elevated
>   The second still seems to be true since, if I'm right, we pass here
> non-NULL sb only from sync_filesystem() and that takes care of the
> superblock reference. So that is just a matter of documenting this fact
> before the function.

We'll defintively need to keep both to prevent races vs unmount.  And
with a NULL superblock passed I'm not even sure how we can take care of
it.

