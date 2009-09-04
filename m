Return-Path: <linux-kernel-owner+w=401wt.eu-S1756967AbZIDPTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967AbZIDPTI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 11:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756905AbZIDPTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 11:19:08 -0400
Received: from brick.kernel.dk ([93.163.65.50]:36819 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756888AbZIDPTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 11:19:07 -0400
Date: Fri, 4 Sep 2009 17:19:09 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: npiggin@suse.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 04/33] fs: brlock vfsmount_lock
Message-ID: <20090904151908.GX18599@kernel.dk>
References: <20090904065142.114706411@nick.local0.net> <20090904065534.447753909@nick.local0.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090904065534.447753909@nick.local0.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 04 2009, npiggin@suse.de wrote:
> Index: linux-2.6/fs/namei.c
> ===================================================================
> --- linux-2.6.orig/fs/namei.c
> +++ linux-2.6/fs/namei.c
> @@ -679,15 +679,16 @@ int follow_up(struct path *path)
>  {
>  	struct vfsmount *parent;
>  	struct dentry *mountpoint;
> -	spin_lock(&vfsmount_lock);
> +
> +	vfsmount_read_unlock();
>  	parent = path->mnt->mnt_parent;
>  	if (parent == path->mnt) {
> -		spin_unlock(&vfsmount_lock);
> +		vfsmount_read_unlock();
>  		return 0;

Hmm, that looks a bit off.

-- 
Jens Axboe

