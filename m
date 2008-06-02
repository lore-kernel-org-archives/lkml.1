Return-Path: <linux-kernel-owner+w=401wt.eu-S1760640AbYFBMpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760640AbYFBMpd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 08:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756747AbYFBMpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 08:45:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:59930 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756015AbYFBMpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 08:45:21 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: Novell, SuSE Labs
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [patch 01/15] security: pass path to inode_create
Date: Mon, 2 Jun 2008 14:45:10 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Miklos Szeredi <miklos@szeredi.hu>, hch@infradead.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       jmorris@namei.org, sds@tycho.nsa.gov, eparis@redhat.com,
       casey@schaufler-ca.com, jjohansen@suse.de,
       penguin-kernel@i-love.sakura.ne.jp, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
References: <20080529134903.615127628@szeredi.hu> <E1K38aL-0003KY-Qq@pomaz-ex.szeredi.hu> <20080602123244.GC8562@parisc-linux.org>
In-Reply-To: <20080602123244.GC8562@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806021445.13831.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 June 2008 14:32:46 Matthew Wilcox wrote:
> The point is to resolve pathnames into dev_t + inode in the
> context where the rule is set up.  Then you can implement (say)
> security_inode_permission() without needing to pass in a vfsmount -- all
> you need are the inode->i_ino and inode->i_sb->s_dev to do a comparison.

Without the vfsmount, when something is mounted in more than once place, you 
cannot report which of the name aliases a process is accessing. This is 
unacceptable; the logs would become unusable. With pathname-based, the 
AppArmor and TOMOYO folks really mean pathname-based, not a hybrid pathname / 
mount point model.

> Yes, if someone mounts /etc onto /etc2/ and has a rule to allow them to
> access /etc/shadow, they will then be able to access /etc2/shadow as
> well (which they weren't able to under previous apparmour).  But I can't
> think of a way that permits Something Bad to happen (since the contents
> of the file could have been accessed through /etc/shadow *anyway*).

Yes, when a security policy specifies different permissions for the same 
object on different paths, processes are of course limited to the least 
restrictive of those paths.

One consequence of this is that pathname-based models must control who is 
allowed to create aliases where, of course.

Andreas
