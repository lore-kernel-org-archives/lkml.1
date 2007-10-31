Return-Path: <linux-kernel-owner+w=401wt.eu-S1756538AbXJaHQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538AbXJaHQ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 03:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753995AbXJaHQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 03:16:19 -0400
Received: from THUNK.ORG ([69.25.196.29]:37558 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884AbXJaHQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 03:16:18 -0400
Date: Wed, 31 Oct 2007 03:13:53 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: Jan Blunck <jblunck@suse.de>, Christoph Hellwig <hch@lst.de>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC 0/2] readdir() as an inode operation
Message-ID: <20071031071353.GB20965@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Jan Blunck <jblunck@suse.de>, Christoph Hellwig <hch@lst.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
References: <20071020100903.717837398@X40.localnet> <20071030152604.GC27039@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071030152604.GC27039@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2007 at 04:26:04PM +0100, Jan Kara wrote:
> > This is a first try to move readdir() to become an inode operation. This is
> > necessary for a VFS implementation of "something like union-mounts" where a
> > readdir() needs to read the directory contents of multiple directories.
> > Besides that the new interface is no longer giving the struct file to the
> > filesystem implementations anymore.
> > 
> > Comments, please?
>   Hmm, are you sure there are no users which keep some per-struct-file
> information for directories? File offset is one such obvious thing which
> you've handled but actually filesystem with more complicated structure
> of directory may remember some hints about where we really are, keep
> some readahead information or so...

For example, the ext3 filesystem, when it is supported hash tree, does
exactly this.  See ext3_htree_store_dirent() in fs/ext3/dir.c and
ext3_htree_fill_tree() in fs/ext3/namei.c.

So your patch would break ext3 htree support.

						- Ted
