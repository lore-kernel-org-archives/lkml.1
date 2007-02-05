Return-Path: <linux-kernel-owner+w=401wt.eu-S932984AbXBESXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932984AbXBESXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 13:23:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932993AbXBESXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 13:23:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47572 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932984AbXBESXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 13:23:11 -0500
From: Tony Jones <tonyj@suse.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       Tony Jones <tonyj@suse.de>, linux-security-module@vger.kernel.org,
       agruen@suse.de
Date: Mon, 05 Feb 2007 10:22:13 -0800
Message-Id: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
Subject: [RFC 0/28] Patches to pass vfsmount to LSM inode security hooks
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Introduction
------------

The following are a set of patches the goal of which is to pass vfsmounts
through select portions of the VFS layer sufficient to be visible to the LSM
inode operation hooks.

They are being posted now as a request for comment.  Presently the AppArmor
code - being a user of the LSM interface - does not receive the vfsmount 
correspoding to an operation and has to employ convoluted and slow mechanisms 
in an attempt to determine the vfsmount which are error prone. Therefore these
patches or some variant of them are viewed as a necessary precursor for the 
AppArmor code being resubmitted. 

It is currently planned to resubmit the AppArmor code to the list in the next 
month.  We apologise greatly for the silence since the last submission, a 
combination of research into different designs, other work pressures and just 
not doing the "right thing". Regardless, early discussion and feedback on 
the interface changes presented here is appreciated.

Limitations of the current patches
----------------------------------

NULL is passed for the vfsmount from all NFS functions,  this is analagous
to the current NULL nameidata for security_inode_permission.  NULL is also 
passed in certain cases for internal filesystem data which is not visible in
the normal namespace (Reiserfs being one example).

Struct vfsmount is passed to the LSM inode hooks rather than struct nameidata 
as the hooks do not require the intent data and also as a few hooks are called
when only a struct file is available.

Possible changes
----------------

A second parameter is now being passed to many functions. One alternative is 
to ammend the LSM interface (and struct nameidata) to use struct path instead
but this would be a larger change.

Patches
-------

security-create.diff
	Pass struct vfsmount to the inode_create LSM hook.
	
proc_setattr.diff
	Remove redundant check from proc_setattr().

remove_suid.diff
	Pass struct file down to remove_suid and children
	
vfs-notify_change.diff
	Add a vfsmount parameter to notify_change()
	
security-setattr.diff
	Pass struct vfsmount to the inode_setattr LSM hook
	
vfs-mkdir.diff
	Add struct vfsmount parameter to vfs_mkdir()
	
security-mkdir.diff
	Pass struct vfsmount to the inode_mkdir LSM hook
	
vfs-mknod.diff
	Add a struct vfsmount parameter to vfs_mknod()
	
security-mknod.diff
	Pass struct vfsmount to the inode_mknod LSM hook
	
vfs-symlink.diff
	Add a struct vfsmount parameter to vfs_symlink()
	
security-symlink.diff
	Pass struct vfsmount to the inode_symlink LSM hook.
	
security-readlink.diff
	Pass struct vfsmount to the inode_readlink LSM hook
	
vfs-link.diff
	Add struct vfsmount parameters to vfs_link()
	
security-link.diff
	Pass struct vfsmount to the inode_link LSM hook
	
vfs-rmdir.diff
	Add a struct vfsmount parameter to vfs_rmdir()
	
security-rmdir.diff
	Pass struct vfsmount to the inode_rmdir LSM hook
	
vfs-unlink.diff
	Add a struct vfsmount parameter to vfs_unlink()
	
security-unlink.diff
	Pass struct vfsmount to the inode_unlink LSM hook
	
vfs-rename.diff
	Add struct vfsmount parameters to vfs_rename()
	
security-rename.diff
	Pass struct vfsmount to the inode_rename LSM hook
	
vfs-setxattr.diff
	Add a struct vfsmount parameter to vfs_setxattr()
	
security-setxattr.diff
	Pass struct vfsmount to the inode_setxattr LSM hook
	
vfs-getxattr.diff
	Add a struct vfsmount parameter to vfs_getxattr()
	
security-getxattr.diff
	Pass struct vfsmount to the inode_getxattr LSM hook
	
vfs-listxattr.diff
	Add a struct vfsmount parameter to vfs_listxattr()
	
security-listxattr.diff
	Pass struct vfsmount to the inode_listxattr LSM hook
	
vfs-removexattr.diff
	Add a struct vfsmount parameter to vfs_removexattr()
	
security-removexattr.diff
	Pass struct vfsmount to the inode_removexattr LSM hook
