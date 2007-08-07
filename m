Return-Path: <linux-kernel-owner+w=401wt.eu-S936901AbXHGVe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936901AbXHGVe3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936547AbXHGVJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 17:09:24 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:55230 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936537AbXHGVJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 17:09:22 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, satyam@infradead.org,
       cornelia.huck@de.ibm.com, stern@rowland.harvard.edu,
       Tejun Heo <htejun@gmail.com>,
       Linux Containers <containers@lists.osdl.org>, gregkh@suse.de
Subject: [PATCH 0/25] Sysfs cleanups & tagged directory support
References: <11860582832964-git-send-email-htejun@gmail.com>
Date: Tue, 07 Aug 2007 15:06:21 -0600
In-Reply-To: <11860582832964-git-send-email-htejun@gmail.com> (Tejun Heo's
	message of "Thu, 2 Aug 2007 21:38:03 +0900")
Message-ID: <m1643rkqb6.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The following patchset applies on top of the last round of
sysfs cleanups that Tejun sent out on the 2nd.

My target with this patchset is to support sysfs directories
with a tag on struct sysfs_dirent making them visible only
on selected mounts of sysfs.

After going around and around the different possibilities I
believe I have finally found something that works and is
reasonably maintainable.   I believe I have achieved that
with only introducing some extra complexity in a few very localized
places.

The worst part is the code to support multiple superblocks and thus
multiple dentry tress for sysfs.  I had allocate a linked list in
sysfs_move_dir for all of the possible dentries I would need to call
d_move on. Bleh.  It works, it is correct and it is an atomic
rename.

Eric


sysfs: Move all of inode initialization into sysfs_init_inode
sysfs: Remove sysfs_instantiate
sysfs: Use kill_anon_super
sysfs: Make sysfs_mount static
sysfs: In sysfs_lookup don't open code sysfs_find_dirent
sysfs: Simplify readdir.
sysfs: Rewrite sysfs_drop_dentry.
sysfs: Implement __sysfs_get_dentry
sysfs: Move sysfs_get_dentry below __sysfs_get_dentry
sysfs: Rewrite sysfs_get_dentry in terms of __sysfs_get_dentry
sysfs: Remove s_dentry
sysfs: Introduce sysfs_rename_mutex
sysfs: Simply sysfs_get_dentry
sysfs: Don't use lookup_one_len_kern
vfs: Remove lookup_one_len_kern
sysfs: Support for preventing unmounts.
sysfs: Rewrite rename in terms of sysfs dirents
sysfs: Rewrite sysfs_move_dir in terms of sysfs dirents
sysfs: sysfs_get_dentry add a sb parameter
sysfs: Rename Support multiple superblocks
sysfs: sysfs_chmod_file handle multiple superblocks
sysfs: sysfs_uptdate_file handle multiple superblocks
sysfs: Implement sysfs tagged directory support.
sysfs: Implement sysfs_delete_link and sysfs_rename_link
driver core: Implement tagged directory support for device classes.
