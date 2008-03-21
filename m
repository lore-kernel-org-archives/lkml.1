Return-Path: <linux-kernel-owner+w=401wt.eu-S1758960AbYCURJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758960AbYCURJU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 13:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757359AbYCURJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 13:09:03 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:35246 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363AbYCURJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 13:09:00 -0400
To: viro@ZenIV.linux.org.uk
CC: haveblue@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, neilb@suse.de, akpm@linux-foundation.org,
       hch@infradead.org, linux-security-module@vger.kernel.org,
       jmorris@namei.org
In-reply-to: <E1JckW9-0001Ub-Rs@pomaz-ex.szeredi.hu> (message from Miklos
	Szeredi on Fri, 21 Mar 2008 17:54:57 +0100)
Subject: Re: r-o bind in nfsd
References: <E1Jciie-0001E6-Dx@pomaz-ex.szeredi.hu> <20080321155451.GU10722@ZenIV.linux.org.uk> <E1Jck2N-0001Q3-7W@pomaz-ex.szeredi.hu> <20080321163520.GV10722@ZenIV.linux.org.uk> <E1JckW9-0001Ub-Rs@pomaz-ex.szeredi.hu>
Message-Id: <E1Jckjd-0001X8-IM@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 21 Mar 2008 18:08:53 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Nobody wants to send vfsmounts to the filesystem.  But vfs_...() are
> still part of the "upper layer", not the filesystem, so I'm not
> convinced yet.  For example:
> 
> -extern int vfs_mkdir(struct inode *, struct dentry *, int);
> +extern int vfs_mkdir(const struct path *, struct dentry *, int);
> 
> There's one caller of vfs_mkdir that can't do this: cgroup_clone().
> But that can call cgroup_mkdir() instead.
> 
> And having the vfsmount available within vfs_...() functions means,
> that the mnt_want_write() check can be moved inside, which means that
> callers get simpler and less likely to be buggy.  Those are all
> advantages IMO, regardless of any security module issues.

Or we can introduce another set of exported functions (path_mkdir(),
...), and leave vfs_...() alone.  And then the only question is if
LSM's can live with ordering change.

Miklos
