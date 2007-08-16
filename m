Return-Path: <linux-kernel-owner+w=401wt.eu-S933260AbXHPWVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933260AbXHPWVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 18:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761026AbXHPWVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 18:21:13 -0400
Received: from mx1.suse.de ([195.135.220.2]:56840 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759709AbXHPWVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 18:21:12 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell
To: casey@schaufler-ca.com
Subject: Re: Adding a security parameter to VFS functions
Date: Fri, 17 Aug 2007 00:20:19 +0200
User-Agent: KMail/1.9.5
Cc: David Howells <dhowells@redhat.com>, torvalds@osdl.org,
       viro@ftp.linux.org.uk, sds@tycho.nsa.gov, linux-fsdevel@vger.kernel.org,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
References: <45343.31878.qm@web36610.mail.mud.yahoo.com>
In-Reply-To: <45343.31878.qm@web36610.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708170020.19939.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 August 2007 18:23, Casey Schaufler wrote:
> > Hi Linus, Al,
> > 
> > Would you object greatly to functions like vfs_mkdir() gaining a security
> > parameter?
> 
> Could you describe how this compares to the proposal that the
> AppArmor developers suggested recently? I expect that we can 
> reduce the amount of discussion required, and maybe avoid some
> confusion if you could do that.

That's from one of those patches:

-int vfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
+int vfs_mkdir(struct inode *dir, struct dentry *dentry, struct vfsmount *mnt,
+             int mode)

We need the vfsmount in the LSM hooks in addition to the dentry in order to 
figure out where in the filesystem namespace we are. The various vfs_ 
functions are the ones calling the LSM hooks. (The same could be achieved 
passing a struct path instead.)

-- Andreas
