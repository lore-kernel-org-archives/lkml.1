Return-Path: <linux-kernel-owner+w=401wt.eu-S1758455AbYCUO77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758455AbYCUO77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 10:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754330AbYCUO7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 10:59:50 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:37919 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099AbYCUO7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 10:59:49 -0400
To: haveblue@us.ibm.com
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, neilb@suse.de,
       akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, hch@infradead.org
Subject: r-o bind in nfsd
Message-Id: <E1Jciie-0001E6-Dx@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 21 Mar 2008 15:59:44 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why is it that in fs/nfsd/vfs.c only vfs_mknod() and vfs_rename() are
surrounded by mnt_want_write/mnt_drop_write, and not the other
operations (vfs_create, vfs_mkdir, vfs_symlink, ...)?

I noticed this while looking at the AppArmor patches, which need to
pass the vfsmount down to the security module.  And I'm wondering, why
can't mnt_want_write() and mnt_drop_write() be done _inside_ vfs_foo()?

I know there are a few cases, where filesystems call vfs_foo()
internally, where the vfsmount isn't available, but I think the proper
solution is just to fix those places, and not recurse back into the
VFS (which is AFAICS in all those cases totally unnecessary anyway).
This would make everybody happy, no?

Miklos
