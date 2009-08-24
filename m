Return-Path: <linux-kernel-owner+w=401wt.eu-S1752110AbZHXJ3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbZHXJ3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 05:29:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbZHXJ3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 05:29:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39656 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbZHXJ3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 05:29:05 -0400
Date: Mon, 24 Aug 2009 11:29:05 +0200
From: Jan Kara <jack@suse.cz>
To: Jamie Lokier <jamie@shareable.org>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, hch@lst.de,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/17] Make O_SYNC handling use standard syncing path
	(Version 2)
Message-ID: <20090824092905.GA10080@duck.novell.com>
References: <1250875447-15622-1-git-send-email-jack@suse.cz> <20090822162711.GA7542@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090822162711.GA7542@shareable.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 22-08-09 17:27:11, Jamie Lokier wrote:
> Jan Kara wrote:
> > The patch set unifines O_SYNC handling with standard fsync() path.  After this,
> > we have just one place forcing a single file to disk so filesystems like ext3 /
> > ext4 don't have to force a transaction commit in ext?_file_write for O_SYNC
> > files / IS_SYNC inodes.  The code is also cleaner this way (actually about 150
> > lines shorter), we don't sync the inode several times as it happened previously
> > etc.
> 
> Afaik, O_SYNC requires just the written data to be committed to disk,
> but fsync() requires all dirty data for the file (including written by
> other processes / descriptors) to be committed to disk.
> 
> So doing the equivalent of fsync() after write might be the wrong
> thing to do.
  It's OK, we essentially end up doing fdatasync() on the range of the file
where the write happened. So no unnecessary writing happens.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
