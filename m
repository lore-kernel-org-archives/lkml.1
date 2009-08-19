Return-Path: <linux-kernel-owner+w=401wt.eu-S1753162AbZHSQVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbZHSQVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 12:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbZHSQVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 12:21:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58784 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbZHSQVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 12:21:19 -0400
Date: Wed, 19 Aug 2009 12:21:20 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, hch@infradead.org
Subject: Re: [PATCH 06/17] vfs: Remove sync_page_range_nolock
Message-ID: <20090819162120.GD6150@infradead.org>
References: <1250697884-22288-1-git-send-email-jack@suse.cz> <1250697884-22288-7-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250697884-22288-7-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 06:04:33PM +0200, Jan Kara wrote:
> The last user of sync_page_range_nolock() is generic_file_aio_write_nolock().
> Now we have converted all its callers to not hold i_mutex and so we can
> afford to call sync_page_range() instead of sync_page_range_nolock() from
> there. This non-necessarily acquires i_mutex when syncing block devices but
> that's happening in fsync() path as well and block_fsync() may just drop +
> reacquire i_mutex if we care enough.

Looks good to me, but to stop people from using
generic_file_aio_write_nolock accidentally I would rename it to
blkdev_aio_write, move it to fs/block_dev.c and stop exporting it.  That
way any out of tree or in the merge queue filesystems is forced to use
the appropinquate __generic_file_aio_write.

