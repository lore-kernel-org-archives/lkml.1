Return-Path: <linux-kernel-owner+w=401wt.eu-S1751473AbXBNA15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473AbXBNA15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 19:27:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbXBNA15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 19:27:57 -0500
Received: from smtp.osdl.org ([65.172.181.24]:33970 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473AbXBNA15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 19:27:57 -0500
Date: Tue, 13 Feb 2007 16:27:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: linux-kernel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
       ericvh@gmail.com
Subject: Re: [RESEND][PATCH] 9p: add write-cache support to loose cache mode
Message-Id: <20070213162742.2fb1fa06.akpm@linux-foundation.org>
In-Reply-To: <11714109311262-git-send-email-ericvh@gmail.com>
References: <11714109311262-git-send-email-ericvh@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 13 Feb 2007 17:55:31 -0600 Eric Van Hensbergen <ericvh@gmail.com> wrote:
> +static ssize_t
> +v9fs_file_write(struct file *filp, const char __user * data,
> +		size_t count, loff_t * offset)
> +{
> +	struct inode *inode = filp->f_path.dentry->d_inode;
> +
> +	ssize_t ret;
> +
> +	dprintk(DEBUG_VFS, "count %d offset %x\n", 
> +			(int)count, (int)*offset);
> +	ret = v9fs_write(filp, data, NULL, count, offset);
> +	invalidate_inode_pages2(inode->i_mapping);
> +	return ret;
> +}
> +

invalidate_inode_pages2() can fail.  It might be worth at least warning here
if it does.
