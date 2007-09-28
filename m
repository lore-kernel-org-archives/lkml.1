Return-Path: <linux-kernel-owner+w=401wt.eu-S1757062AbXI1SkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062AbXI1SkV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 14:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbXI1SkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 14:40:08 -0400
Received: from verein.lst.de ([213.95.11.210]:48013 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776AbXI1SkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 14:40:06 -0400
Date: Fri, 28 Sep 2007 20:40:03 +0200
From: Christoph Hellwig <hch@lst.de>
To: jblunck@suse.de
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@lst.de,
       agruen@suse.de, tiwai@suse.de
Subject: Re: [patch 08/10] Introduce path_get()
Message-ID: <20070928184003.GH14269@lst.de>
References: <20070927141200.820970144@X40.localnet> <20070927141228.805874619@X40.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927141228.805874619@X40.localnet>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 04:12:08PM +0200, jblunck@suse.de wrote:
> This introduces the symmetric function to path_put() for getting a reference
> to the dentry and vfsmount of a struct path in the right order.

Looks good in general,

>  /**
> + * path_get - get a reference to a path
> + * @path: path to get the reference to
> + *
> + * Given a path increment the reference count to the dentry and the vfsmount.
> + */
> +struct path *path_get(struct path *path)
> +{
> +	mntget(path->mnt);
> +	dget(path->dentry);
> +	return path;
> +}

but the calling convention is rather odd, because the only thing callers
might do with this is to dereference and then assign it.  Maybe this
should just return void to make it more clear what's going on?

