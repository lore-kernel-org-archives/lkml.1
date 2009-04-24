Return-Path: <linux-kernel-owner+w=401wt.eu-S1759398AbZDXSlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759398AbZDXSlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 14:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbZDXSk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 14:40:57 -0400
Received: from verein.lst.de ([213.95.11.210]:59140 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832AbZDXSk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 14:40:56 -0400
Date: Fri, 24 Apr 2009 20:40:47 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: get_fs_excl/put_fs_excl/has_fs_excl
Message-ID: <20090424184047.GA17001@lst.de>
References: <20090423191817.GA22521@lst.de> <20090423192123.GL4593@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423192123.GL4593@kernel.dk>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 09:21:24PM +0200, Jens Axboe wrote:
> The intent was to add some sort of notification mechanism from the file
> system to inform the IO scheduler (and others?) that this process is how
> holding a file system wide resource. So if you have a low priority
> process getting access to such a resource, you want to boost its
> priority to avoid higher priority apps getting stuck beind it. Sort of a
> poor mans priority inheritance.
> 
> It would be wonderful if you could kick this process more into gear on
> the fs side...

So what are the calls in lock_super/unlock_super supposed to be for?
->write_super?  While that can sync bits out most of the heavy lifting
is now done in ->sync_fs for most filesystems.  ->remount_fs?  This is
going to block all other I/O anyway.  ->put_super?  Surely not :)

ext3/4 internal bits?  Doesn't seem to be used for any journal related
activity but mostly as protection against resizing (the whole lock_super
usage in ext3/4 looks odd to me, interestingly there's none at all in
ext2.  Maybe someone of the extN crowd should audit and get rid of it in
favour of a better fs-specific lock)

