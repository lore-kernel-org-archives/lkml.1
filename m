Return-Path: <linux-kernel-owner+w=401wt.eu-S932903AbZHUSIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903AbZHUSIA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 14:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932590AbZHUSH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 14:07:59 -0400
Received: from verein.lst.de ([213.95.11.210]:57483 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932544AbZHUSH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 14:07:58 -0400
Date: Fri, 21 Aug 2009 20:07:59 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 06/17] vfs: Rename generic_file_aio_write_nolock
Message-ID: <20090821180759.GA31965@lst.de>
References: <1250875447-15622-1-git-send-email-jack@suse.cz> <1250875447-15622-7-git-send-email-jack@suse.cz> <20090821173034.GB30254@lst.de> <20090821175617.GA10145@duck.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090821175617.GA10145@duck.novell.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 21, 2009 at 07:56:17PM +0200, Jan Kara wrote:
> On Fri 21-08-09 19:30:34, Christoph Hellwig wrote:
> > On Fri, Aug 21, 2009 at 07:23:56PM +0200, Jan Kara wrote:
> > > generic_file_aio_write_nolock() is now used only by block devices and raw
> > > character device. Filesystems should use __generic_file_aio_write() in case
> > > generic_file_aio_write() doesn't suit them. So rename the function to
> > > device_aio_write().
> > 
> > This might turn into nitpicking, but it's really only useful for
> > writing to block devices.  Raw isn't a real character interface but
> > basically a convuled way to open a block device using O_DIRECT.
> > 
> > So I would recommend to renamed it to blkdev_aio_write, move it to
> > fs/block_dev.c and stop exporting it.
>   But what should 'raw' use then? It can be compiled as a module so it
> needs to call something that's exported.

Oh, ouch - I didn't think that we would allow it to be modular.  We need
to keep exporting it then.  Hopefully the name change keeps people from
using it in filesystems.

