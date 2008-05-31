Return-Path: <linux-kernel-owner+w=401wt.eu-S1753783AbYEaKsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbYEaKsh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 06:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbYEaKs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 06:48:27 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:59615 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867AbYEaKs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 06:48:26 -0400
To: hch@infradead.org
Cc: miklos@szeredi.hu, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, jmorris@namei.org, sds@tycho.nsa.gov,
       eparis@redhat.com, casey@schaufler-ca.com, agruen@suse.de,
       jjohansen@suse.de, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 01/15] security: pass path to inode_create
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20080529134903.615127628@szeredi.hu>
	<20080529134958.655985182@szeredi.hu>
	<20080531083052.GH24135@infradead.org>
In-Reply-To: <20080531083052.GH24135@infradead.org>
Message-Id: <200805311948.HAD69220.tFOVHQOFSOFLJM@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sat, 31 May 2008 19:48:22 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Christoph Hellwig wrote:
> On Thu, May 29, 2008 at 03:49:04PM +0200, Miklos Szeredi wrote:
> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > In the inode_create() security operation and related functions pass
> > the path (vfsmount + dentry) to the parent directory instead of the
> > inode.  AppArmor will need this.
> 
> So you're once again switching vfs_ to a pass a vfsmount argument, this
> time hidden under struct path.  It's really hard to grasp a "no"
> sometimes, isn't it? :)
> 
The vfs-cleanups git tree is developed for passing "vfsmount" argument so that
r/o bind mounts shall not fail to check "vfsmount" by reconstructing vfs_*() callers
and marking vfs_*() as "static".

If this vfs-cleanups git tree has no problem regarding "vfsmount" argument,
I think there is no advantage of adding security_path_*() hooks inside the path_*() functions
since everybody calls the vfs_*() functions via path_*() functions.

Passing "vfsmount" to vfs_*() functions is better for AppArmor and TOMOYO and auditing purpose
(we can obtain the absolute pathname compared to the relative pathname from the mount point) than
adding security_path_*(), isn't it?

Are you worrying that there might be a case where the "vfsmount" argument passed to
path_*() functions is invalid or NULL?
