Return-Path: <linux-kernel-owner+w=401wt.eu-S1753788AbXLBHtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbXLBHtg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 02:49:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbXLBHt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 02:49:28 -0500
Received: from cantor.suse.de ([195.135.220.2]:54042 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbXLBHt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 02:49:27 -0500
Date: Sat, 1 Dec 2007 23:54:37 -0800
From: Greg KH <gregkh@suse.de>
To: rae l <crquan@gmail.com>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: Since sysfs_mount is static and used only in sysfs_init
	function, it could be just an automatic variable.
Message-ID: <20071202075437.GA19897@suse.de>
References: <91b13c310712011231k3604214bx3559387c568cce09@mail.gmail.com> <20071202044825.GA7004@suse.de> <91b13c310712012252k5307735x782582fd2d7abd94@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91b13c310712012252k5307735x782582fd2d7abd94@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 02, 2007 at 02:52:17PM +0800, rae l wrote:
> On Dec 2, 2007 12:48 PM, Greg KH <gregkh@suse.de> wrote:
> ...
> > > and where is a detailed explaination on kern_mount? could someone give
> > > some comments or documentation pointers on this?
> >
> > See the patches that Eric Biederman just posted to lkml for why this
> > structure is a static pointer this way right now, it's in preparation
> > for future patches.
> I have checked commit 7d0c7d676cc066413e1583b5af9fba8011972d41 by Eric
> W. Biederman,
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=7d0c7d676cc066413e1583b5af9fba8011972d41
> 
> which just make sysfs_mount from externally visible to static that
> could be only used in one c file,
> 
> but I mean that the static variable is still on kernel bss section,
> this consumes a pointer (4 or 8 bytes) memory,
> 
> through a grep from fs/sysfs/, it appears that the variable
> sysfs_mount is only used in the sysfs_init function,
> 
> $ grep -RsInw sysfs_mount fs/sysfs/
> fs/sysfs/mount.c:25:static struct vfsmount *sysfs_mount;
> fs/sysfs/mount.c:101:           sysfs_mount = kern_mount(&sysfs_fs_type);
> fs/sysfs/mount.c:102:           if (IS_ERR(sysfs_mount)) {
> fs/sysfs/mount.c:104:                   err = PTR_ERR(sysfs_mount);
> fs/sysfs/mount.c:105:                   sysfs_mount = NULL;
> 
> we could mark this variable an automatic one, which scope is just in
> this function, thus created and destroyed with the stack,
> this approach does not consume a pointer on kernel bss section,
> 
> Why not do this?

Again, see the patches he _just_ posted to lkml, the specific message
you are looking for is:
	Message-ID: <m11wa693t0.fsf@ebiederm.dsl.xmission.com>
	Subject: [PATCH 01/10] sysfs: Make sysfs_mount static again.

Also see the whole long thread for more details.

If you have further questions about this, please ask Eric.

thanks,

greg k-h
