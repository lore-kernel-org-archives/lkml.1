Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918AbYLSI71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbYLSI71 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 03:59:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbYLSI7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 03:59:17 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43184 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbYLSI7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 03:59:16 -0500
Date: Fri, 19 Dec 2008 03:59:12 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Ankit Jain <me@ankitjain.org>, Al Viro <viro@zeniv.linux.org.uk>,
       mfasheh@suse.com, linux-kernel@vger.kernel.org, joel.becker@oracle.com,
       Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com,
       linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
       ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH v2] fs: Add new pre-allocation ioctls to vfs for
	compatibility with legacy xfs ioctls
Message-ID: <20081219085912.GA30293@infradead.org>
References: <494ABEBC.8060101@ankitjain.org> <20081219043744.GC17177@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081219043744.GC17177@disturbed>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2008 at 03:37:44PM +1100, Dave Chinner wrote:
> XFS_IOC_RESVSP supports invisible I/O, and that means
> XFS_IOC_RESVSP needs to be passed through to vfs_ioctl()
> to vector to XFS to handle.

When the current XFS git tree gets merged to mainline before this
patch.  invisible I/O handling is now FMODE_NOCMTIME in file->f_flags
which this patch will pass through to the filesystem.  We just need
to chage xfs_vn_fallocate ot honour it.

