Return-Path: <linux-kernel-owner+w=401wt.eu-S1756000AbXD0Pfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbXD0Pfi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 11:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756006AbXD0Pfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 11:35:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:49038 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756000AbXD0PfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 11:35:22 -0400
Date: Fri, 27 Apr 2007 08:32:45 -0700
From: Greg KH <gregkh@suse.de>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Tejun Heo <htejun@gmail.com>, maneesh@in.ibm.com,
       dmitry.torokhov@gmail.com, cornelia.huck@de.ibm.com, oneukum@suse.de,
       rpurdie@rpsys.net, James.Bottomley@SteelEye.com,
       stern@rowland.harvard.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/14] sysfs: fix i_ino handling in sysfs
Message-ID: <20070427153245.GA10999@suse.de>
References: <11760923274128-git-send-email-htejun@gmail.com> <463216EA.20203@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <463216EA.20203@sandeen.net>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 10:29:46AM -0500, Eric Sandeen wrote:
>  Tejun Heo wrote:
> > Inode number handling was incorrect in two ways.
> > 1. sysfs uses the inode number allocated by new_inode() and never
> >    hashes it.  When reporting the inode number, it uses iunique() if
> >    inode is inaccessible.  This is incorrect because iunique() assumes
> >    the inodes are hashed.  This can cause duplicate inode numbers and
> >    the condition is likely to happen because new_inode() and iunique()
> >    use separate increasing static counters to scan for empty slot.
> > 2. sysfs_dirent->s_dentry can go away anytime and can't be referenced
> >    unless the caller knows the dentry is not and not going to be
> >    deleted.
> > This patch makes sysfs report the pointer to sysfs_dirent as ino.
> > ino_t is always as big as or larger than unsigned long && sysfs_dirent
> > hierarchy is the internal representation of the sysfs tree, so it
> > makes sense and simple to implement.
> 
>  what about 32-bit stats from 32-bit apps on 64-bit systems?  This will make 
>  64-bit inode numbers commonplace in sysfs; will this cause problems?  it 
>  seems that if they get truncated to 32 bits the possibility of duplicate 
>  inode nrs will come back...

Yes, this turned out to be a problem as the ppc people found out :)

Tejun had some follow-on patches fixing this issue up.

thanks,

greg k-h
