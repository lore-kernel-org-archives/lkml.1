Return-Path: <linux-kernel-owner+w=401wt.eu-S1757730AbXI2J0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730AbXI2J0N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 05:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755032AbXI2J0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 05:26:00 -0400
Received: from verein.lst.de ([213.95.11.210]:35912 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196AbXI2J0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 05:26:00 -0400
Date: Sat, 29 Sep 2007 11:25:57 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: jblunck@suse.de, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       hch@lst.de, tiwai@suse.de
Subject: Re: [patch] Combine path_put and path_put_conditional
Message-ID: <20070929092557.GB25343@lst.de>
References: <20070927141200.820970144@X40.localnet> <200709282243.51243.agruen@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709282243.51243.agruen@suse.de>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2007 at 10:43:50PM +0200, Andreas Gruenbacher wrote:
> Here is another cleanup on top of Jan's set. Comments?
> 
> 
> The name path_put_conditional (formerly, dput_path) is a little unclear.
> Replace (path_put_conditional + path_put) with path_walk_put_both,
> "put a pair of paths after a path_walk" (see the kerneldoc).

I think this function is a good idea.  The name seems odd to me, but
I don't really have a better idea either.

> +static void path_walk_put_both(struct path *path1, struct path *path2)
> +{
> +	dput(path1->dentry);
> +	dput(path2->dentry);
> +	mntput(path1->mnt);
> +	if (path1->mnt != path2->mnt)
> +		mntput(path2->mnt);
>  }

Why do you opencode the path_put for path1?

