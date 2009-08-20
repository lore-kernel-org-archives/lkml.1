Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbZHTMEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbZHTMEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 08:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754188AbZHTMEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 08:04:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53139 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754186AbZHTMEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 08:04:36 -0400
Date: Thu, 20 Aug 2009 14:04:36 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       Evgeniy Polyakov <zbr@ioremap.net>, ocfs2-devel@oss.oracle.com,
       Joel Becker <joel.becker@oracle.com>
Subject: Re: [PATCH 02/17] vfs: Export __generic_file_aio_write() and add
	some comments
Message-ID: <20090820120436.GB16486@duck.novell.com>
References: <1250697884-22288-1-git-send-email-jack@suse.cz> <1250697884-22288-3-git-send-email-jack@suse.cz> <20090819161145.GB6150@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090819161145.GB6150@infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 19-08-09 12:11:45, Christoph Hellwig wrote:
> On Wed, Aug 19, 2009 at 06:04:29PM +0200, Jan Kara wrote:
> > Rename __generic_file_aio_write_nolock() to __generic_file_aio_write(), add
> > comments to write helpers explaining how they should be used and export
> > __generic_file_aio_write() since it will be used by some filesystems.
> 
> The renaming and commenting looks good to me, and the export is fine
> with me given that we'll actually use it later one.
> 
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Can we maybe get rid of generic_file_aio_write_nolock after you patch
> series?
  In principle we could. It's just that block devices don't need i_mutex
for serializing writes so I found it dumb to serialize writes to the block
device needlessly. But we could move generic_file_aio_write_nolock to
blockdev.c and name it like blockdev_aio_write() since noone else uses
it after my series. I guess I'll do that.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
