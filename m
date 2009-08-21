Return-Path: <linux-kernel-owner+w=401wt.eu-S1755708AbZHUR4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708AbZHUR4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 13:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754875AbZHUR4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 13:56:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51315 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016AbZHUR4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 13:56:17 -0400
Date: Fri, 21 Aug 2009 19:56:17 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 06/17] vfs: Rename generic_file_aio_write_nolock
Message-ID: <20090821175617.GA10145@duck.novell.com>
References: <1250875447-15622-1-git-send-email-jack@suse.cz> <1250875447-15622-7-git-send-email-jack@suse.cz> <20090821173034.GB30254@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090821173034.GB30254@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 21-08-09 19:30:34, Christoph Hellwig wrote:
> On Fri, Aug 21, 2009 at 07:23:56PM +0200, Jan Kara wrote:
> > generic_file_aio_write_nolock() is now used only by block devices and raw
> > character device. Filesystems should use __generic_file_aio_write() in case
> > generic_file_aio_write() doesn't suit them. So rename the function to
> > device_aio_write().
> 
> This might turn into nitpicking, but it's really only useful for
> writing to block devices.  Raw isn't a real character interface but
> basically a convuled way to open a block device using O_DIRECT.
> 
> So I would recommend to renamed it to blkdev_aio_write, move it to
> fs/block_dev.c and stop exporting it.
  But what should 'raw' use then? It can be compiled as a module so it
needs to call something that's exported.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
