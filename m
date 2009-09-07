Return-Path: <linux-kernel-owner+w=401wt.eu-S1751913AbZIGHj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbZIGHj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 03:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751813AbZIGHjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 03:39:25 -0400
Received: from cantor.suse.de ([195.135.220.2]:44693 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417AbZIGHjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 03:39:25 -0400
Date: Mon, 7 Sep 2009 09:39:27 +0200
From: Nick Piggin <npiggin@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 04/33] fs: brlock vfsmount_lock
Message-ID: <20090907073927.GG1875@wotan.suse.de>
References: <20090904065142.114706411@nick.local0.net> <20090904065534.447753909@nick.local0.net> <20090904151908.GX18599@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090904151908.GX18599@kernel.dk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 04, 2009 at 05:19:09PM +0200, Jens Axboe wrote:
> On Fri, Sep 04 2009, npiggin@suse.de wrote:
> > Index: linux-2.6/fs/namei.c
> > ===================================================================
> > --- linux-2.6.orig/fs/namei.c
> > +++ linux-2.6/fs/namei.c
> > @@ -679,15 +679,16 @@ int follow_up(struct path *path)
> >  {
> >  	struct vfsmount *parent;
> >  	struct dentry *mountpoint;
> > -	spin_lock(&vfsmount_lock);
> > +
> > +	vfsmount_read_unlock();
> >  	parent = path->mnt->mnt_parent;
> >  	if (parent == path->mnt) {
> > -		spin_unlock(&vfsmount_lock);
> > +		vfsmount_read_unlock();
> >  		return 0;
> 
> Hmm, that looks a bit off.

Thanks Jens, good catch. Yes I haven't actually even tested NFS or
NFSD yet, which I should do soon because they do some interesting
things with the dcache.
