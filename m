Return-Path: <linux-kernel-owner+w=401wt.eu-S1758656AbXIXMiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656AbXIXMiZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 08:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756123AbXIXMiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 08:38:17 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40217 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102AbXIXMiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 08:38:16 -0400
Date: Mon, 24 Sep 2007 13:38:13 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, trond.myklebust@fys.uio.no, adilger@clusterfs.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 2/2] VFS: allow filesystem to override mknod capability checks
Message-ID: <20070924123813.GB17409@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Miklos Szeredi <miklos@szeredi.hu>, trond.myklebust@fys.uio.no,
	adilger@clusterfs.com, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <E1IZmze-0003q9-00@dorka.pomaz.szeredi.hu> <E1IZn0c-0003qS-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IZn0c-0003qS-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2007 at 02:25:54PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Add a new super block flag, that results in the VFS not checking if
> the current process has enough privileges to do an mknod().
> 
> If this flag is set, all mounts for this super block will have the
> "nodev" flag implied.
> 
> This is needed on filesystems, where an unprivileged user may be able
> to create a device node, without causing security problems.
> 
> One such example is "mountlo" a loopback mount utility implemented
> with fuse and UML, which runs as an unprivileged userspace process.
> In this case the user does in fact have the right to create device
> nodes within the filesystem image, as long as the user has write
> access to the image.  Since the filesystem is mounted with "nodev",
> adding device nodes is not a security concern.

This one looks okay, but I'd prefer to not put it in until we actually
have proper non-privilegued mounts.

