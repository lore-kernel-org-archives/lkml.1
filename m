Return-Path: <linux-kernel-owner+w=401wt.eu-S933121AbXCAIlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933121AbXCAIlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 03:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933122AbXCAIlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 03:41:17 -0500
Received: from smtp.osdl.org ([65.172.181.24]:34517 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933121AbXCAIlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 03:41:16 -0500
Date: Thu, 1 Mar 2007 00:41:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 03/22] fix deadlock in balance_dirty_pages
Message-Id: <20070301004111.c56f4fd1.akpm@linux-foundation.org>
In-Reply-To: <E1HMgmg-0001mc-00@dorka.pomaz.szeredi.hu>
References: <20070227223809.684624012@szeredi.hu>
	<20070227223911.472192712@szeredi.hu>
	<20070228225853.8df5bdd0.akpm@linux-foundation.org>
	<E1HMfp2-0001fc-00@dorka.pomaz.szeredi.hu>
	<20070301002704.8fbbcda2.akpm@linux-foundation.org>
	<E1HMgmg-0001mc-00@dorka.pomaz.szeredi.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Mar 2007 09:37:06 +0100 Miklos Szeredi <miklos@szeredi.hu> wrote:

> > Sigh.  What's this about i_mutex?  That appears to be some critical
> > information which _still_ isn't being communicated.
> > 
> 
> This:
> 
> ssize_t generic_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
> 		unsigned long nr_segs, loff_t pos)
> {
> 	struct file *file = iocb->ki_filp;
> 	struct address_space *mapping = file->f_mapping;
> 	struct inode *inode = mapping->host;
> 	ssize_t ret;
> 
> 	BUG_ON(iocb->ki_pos != pos);
> 
> 	mutex_lock(&inode->i_mutex);
> 	ret = __generic_file_aio_write_nolock(iocb, iov, nr_segs,
> 			&iocb->ki_pos);
> 	mutex_unlock(&inode->i_mutex);
> 
> 
> It's in the stack trace.  I thought it was obvious.

No, it is not obvious.

I'm just not going to apply weird hacks to work around a bug which
I do not understand, and I have spent way too much time trying to understand
this one.

So let us persist.

Please fully describe the role of i_mutex in this hang.
