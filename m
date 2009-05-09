Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042AbZEINCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbZEINCG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 09:02:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbZEINBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 09:01:54 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53578 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070AbZEINBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 09:01:53 -0400
Date: Sat, 9 May 2009 14:01:52 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Jeff Mahoney <jeffm@suse.com>, reiserfs-devel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.30-rc: reiserfs_delete_xattrs log spam (bug 13122)
Message-ID: <20090509130152.GD8633@ZenIV.linux.org.uk>
References: <4A057951.8040501@s5r6.in-berlin.de> <tkrat.fe49a8c298128f65@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tkrat.fe49a8c298128f65@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 09, 2009 at 02:44:25PM +0200, Stefan Richter wrote:
> On  9 May, Stefan Richter wrote:
> > I just switched from 2.6.29.1 to 2.6.30-rc5, and I'm getting the same as 
> > the reporter of http://bugzilla.kernel.org/show_bug.cgi?id=13122 alias
> > http://marc.info/?l=linux-kernel&m=123990989515105, i.e. repetitions of
> >  >>>
> > May  9 14:27:22 stein REISERFS warning (device sda1): jdm-20004 
> > reiserfs_delete_xattrs: Couldn't delete all xattrs (-13)
> > May  9 14:27:22 stein
> > <<<
> > 
> > This happens in irregular intervals, but a lot of times --- presumably 
> > when certain files are accessed.  I'm on a recently set-up Gentoo 
> > machine.  I created its root filesystem using the Gentoo x86-64 minimal 
> > boot CD; my guess is that the kernel of the boot CD had 
> > CONFIG_REISERFS_FS_XATTR enabled.  All kernels which I used since then 
> > have it disabled:  2.6.27-gentoo-r8, 2.6.29.1, now 2.6.30-rc5.
> 
> PS:  Also, the following came up at this (= first) boot of 2.6.30-rc, as
> a warm reboot from 2.6.29.1. I have no idea whether it's connected to
> the issue.

That WARN_ON() is fixed in the patches in VFS queue; should be gone in
-next and I'm going to push a bunch of fixes to Linus today, this one
among them.

The first one you've reported is a different story.  Could you try to
bisect it?
