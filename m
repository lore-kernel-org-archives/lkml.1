Return-Path: <linux-kernel-owner+w=401wt.eu-S1757333AbYBQNHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333AbYBQNHv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 08:07:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbYBQNHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 08:07:43 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60607 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbYBQNHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 08:07:42 -0500
Date: Sun, 17 Feb 2008 08:07:33 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, jblunck@suse.de,
       hch@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mmotm] fs/sysfs/file.c d_path fix
Message-ID: <20080217130733.GA11483@infradead.org>
References: <200802161912.m1GJC5Gt031939@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802161912.m1GJC5Gt031939@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2008 at 02:12:05PM -0500, Erez Zadok wrote:
> diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
> index 02223e2..a57b024 100644
> --- a/fs/sysfs/file.c
> +++ b/fs/sysfs/file.c
> @@ -329,9 +329,11 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
>  	struct sysfs_ops *ops;
>  	int error = -EACCES;
>  	char *p;
> +	struct path sysfs_path;
>  
> -	p = d_path(file->f_dentry, sysfs_mount, last_sysfs_file,
> -		   sizeof(last_sysfs_file));
> +	sysfs_path.dentry = file->f_dentry;
> +	sysfs_path.mnt = sysfs_mount;
> +	p = d_path(&sysfs_path, last_sysfs_file, sizeof(last_sysfs_file));

A d_path(file->f_path, ..); should do it, but I'd really like to know
what sysfs crowd was smoking when adding a d_path in ->open.  Guys,
please explain what's going on here.

