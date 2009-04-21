Return-Path: <linux-kernel-owner+w=401wt.eu-S1753215AbZDUOsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbZDUOsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 10:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbZDUOsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 10:48:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35664 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbZDUOsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 10:48:18 -0400
Date: Tue, 21 Apr 2009 10:48:10 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Suresh Jayaraman <sjayaraman@suse.de>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Masahiro Tamori <masahiro.tamori@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       linux-nfs@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca,
       LKML <linux-kernel@vger.kernel.org>, linux-embedded@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [ltt-dev] [PATCH] nfs: add support for splice writes
Message-ID: <20090421144810.GA7036@infradead.org>
References: <49D45974.2060202@suse.de> <20090402063235.GB24846@Krystal> <49D45E42.3050502@suse.de> <91e0b5050904020542l6b38d7a6hab6d7ef8b4593425@mail.gmail.com> <49EC0A83.8060802@suse.de> <1240230224.8073.6.camel@heimdal.trondhjem.org> <49EC6CB3.8080800@suse.de> <1240237274.13636.9.camel@heimdal.trondhjem.org> <49EC990B.1030007@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EC990B.1030007@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 09:17:23PM +0530, Suresh Jayaraman wrote:
> +static ssize_t nfs_file_splice_write(struct pipe_inode_info *pipe,
> +				     struct file *filp, loff_t *ppos,
> +				     size_t count, unsigned int flags)
> +{
> +	struct dentry *dentry = filp->f_path.dentry;
> +
> +	dprintk("NFS splice_write(%s/%s, %lu@%Lu)\n",
> +		dentry->d_parent->d_name.name, dentry->d_name.name,
> +		(unsigned long) count, (unsigned long long) *ppos);
> +
> +	return generic_file_splice_write(pipe, filp, ppos, count, flags);
> +}
> +

You need all calls from nfs_file_write, too:

 - most importantly the nfs_revalidate_file_size for O_APPEND
 - the nfs_do_fsync for sync writes
 - probably the stats increment
