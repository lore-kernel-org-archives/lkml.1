Return-Path: <linux-kernel-owner+w=401wt.eu-S932875AbZHURah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932875AbZHURah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 13:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932668AbZHURaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 13:30:35 -0400
Received: from verein.lst.de ([213.95.11.210]:56106 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932471AbZHURae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 13:30:34 -0400
Date: Fri, 21 Aug 2009 19:30:34 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, hch@lst.de,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 06/17] vfs: Rename generic_file_aio_write_nolock
Message-ID: <20090821173034.GB30254@lst.de>
References: <1250875447-15622-1-git-send-email-jack@suse.cz> <1250875447-15622-7-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250875447-15622-7-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 21, 2009 at 07:23:56PM +0200, Jan Kara wrote:
> generic_file_aio_write_nolock() is now used only by block devices and raw
> character device. Filesystems should use __generic_file_aio_write() in case
> generic_file_aio_write() doesn't suit them. So rename the function to
> device_aio_write().

This might turn into nitpicking, but it's really only useful for
writing to block devices.  Raw isn't a real character interface but
basically a convuled way to open a block device using O_DIRECT.

So I would recommend to renamed it to blkdev_aio_write, move it to
fs/block_dev.c and stop exporting it.

