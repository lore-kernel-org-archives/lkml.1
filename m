Return-Path: <linux-kernel-owner+w=401wt.eu-S1761601AbZC3VAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761601AbZC3VAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 17:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761572AbZC3VAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 17:00:12 -0400
Received: from [76.245.85.235] ([76.245.85.235]:57873 "EHLO cynthia.pants.nu"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1761566AbZC3VAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 17:00:11 -0400
Date: Mon, 30 Mar 2009 13:59:28 -0700
From: Brad Boyer <flar@allandria.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] splice: implement default splice_read method
Message-ID: <20090330205927.GA7707@cynthia.pants.nu>
References: <E1LoNev-0007kP-U7@pomaz-ex.szeredi.hu> <E1LoNie-0007m5-B4@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1LoNie-0007m5-B4@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 10:04:28PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> If f_op->splice_read() is not implemented fall back to a plain read.
> Use vfs_readv() to read into previously allocated pages.
> 
> This will allow splice and functions using splice, such as the loop
> device, to work on all filesystems.  This includes "direct_io" files
> in fuse which bypass the page cache.

Based on your description, I would have expected this patch to make
the loop driver work seamlessly. Unless I'm misreading something, I
think the loop driver will still error out if the fs driver in question
doesn't explicitly set splice_read.o

>From drivers/block/loop.c:
724         /* new backing store needs to support loop (eg splice_read) */
725         if (!inode->i_fop->splice_read)
726                 goto out_putf;
727 

Did you accidentally leave out some changes? Please let me know if I
am missing something obvious.

	Brad Boyer
	flar@allandria.com

