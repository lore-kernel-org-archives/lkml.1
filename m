Return-Path: <linux-kernel-owner+w=401wt.eu-S932319AbYEHQxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319AbYEHQxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 12:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932127AbYEHQxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 12:53:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52911 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932126AbYEHQxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 12:53:11 -0400
Date: Thu, 8 May 2008 12:52:47 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Subject: Re: [patch 06/24] hpfs: dont call notify_change
Message-ID: <20080508165247.GC13914@infradead.org>
References: <20080506091327.259950960@szeredi.hu> <20080506091413.165665963@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080506091413.165665963@szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 11:13:33AM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> hpfs_unlink() calls notify_change() to truncate the file before
> deleting.  Replace with explicit call to hpfs_notify_change().
> 
> This is equivalent, except that:
>  - security_inode_setattr() is not called before hpfs_notify_change()
>  - fsnotify_change() is not called after hpfs_notify_change()
> 
> The truncation is just an implementation detail, so both the security
> check and the notification are unnecessary.
> 
> Possibly even the ctime modification is wrong?

This code is rahter scary, as we'd lost the content without the file
when the second remove_dirent attempt fails.  Because of that we should
at least keep the ctime change so an app can know the file was touched.

Again, looks correct but I'm not convinced about all these changes.
