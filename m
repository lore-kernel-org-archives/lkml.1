Return-Path: <linux-kernel-owner+w=401wt.eu-S1030852AbXDPQZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030852AbXDPQZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 12:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030856AbXDPQZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 12:25:33 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:42623 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030851AbXDPQZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 12:25:32 -0400
Date: Mon, 16 Apr 2007 10:25:30 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       Tony Jones <tonyj@suse.de>
Subject: Re: [nameidata 1/2] Don't pass NULL nameidata to vfs_create
Message-ID: <20070416162530.GA12207@parisc-linux.org>
References: <20070412090809.917795000@suse.de> <20070412090836.207973000@suse.de> <20070412100628.GA25078@infradead.org> <200704161811.30364.agruen@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704161811.30364.agruen@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2007 at 06:11:30PM +0200, Andreas Gruenbacher wrote:
> +static inline int
> +nfsd_do_create(struct inode *dir, struct dentry *child, struct vfsmount *mnt,
> +	       int mode)
> +{
> +	struct nameidata nd = {
> +		.dentry = child,
> +		.mnt = mnt,
> +	};
> +
> +	return vfs_create(dir, child, mode, &nd);
> +}
> +

Wouldn't it normally result in fewer instructions (on most architectures
... maybe not x86) to keep the same argument order as vfs_create?  ie:

static inline int nfsd_do_create(struct inode *dir, struct dentry *child,
				 int mode, struct vfsmount *mnt)

