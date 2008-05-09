Return-Path: <linux-kernel-owner+w=401wt.eu-S932912AbYEIB7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932912AbYEIB7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 21:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756406AbYEIB7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 21:59:38 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.31.125]:46697 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445AbYEIB7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 21:59:37 -0400
Date: Fri, 9 May 2008 03:59:35 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Christoph Hellwig <hch@infradead.org>
cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 06/24] hpfs: dont call notify_change
In-Reply-To: <20080508165247.GC13914@infradead.org>
Message-ID: <Pine.LNX.4.64.0805090357500.3793@artax.karlin.mff.cuni.cz>
References: <20080506091327.259950960@szeredi.hu> <20080506091413.165665963@szeredi.hu>
 <20080508165247.GC13914@infradead.org>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2008, Christoph Hellwig wrote:

> On Tue, May 06, 2008 at 11:13:33AM +0200, Miklos Szeredi wrote:
> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > hpfs_unlink() calls notify_change() to truncate the file before
> > deleting.  Replace with explicit call to hpfs_notify_change().
> > 
> > This is equivalent, except that:
> >  - security_inode_setattr() is not called before hpfs_notify_change()
> >  - fsnotify_change() is not called after hpfs_notify_change()
> > 
> > The truncation is just an implementation detail, so both the security
> > check and the notification are unnecessary.
> > 
> > Possibly even the ctime modification is wrong?
> 
> This code is rahter scary, as we'd lost the content without the file
> when the second remove_dirent attempt fails.  Because of that we should
> at least keep the ctime change so an app can know the file was touched.

Unfortunatelly this is design bug in HPFS --- removing a dirent can 
allocate more space. There's nothing that can be done about it. OS/2 
crashes on panic when this situation is triggered :)

Mikulas

> Again, looks correct but I'm not convinced about all these changes.
