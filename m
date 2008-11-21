Return-Path: <linux-kernel-owner+w=401wt.eu-S1754964AbYKUIXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964AbYKUIXv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 03:23:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbYKUIXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 03:23:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59283 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752482AbYKUIXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 03:23:41 -0500
Date: Fri, 21 Nov 2008 00:23:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 24/45] CacheFiles: Add a hook to write a single page of
 data to an inode [ver #41]
Message-Id: <20081121002317.69e4fd11.akpm@linux-foundation.org>
In-Reply-To: <20081120144343.10667.530.stgit@warthog.procyon.org.uk>
References: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
	<20081120144343.10667.530.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2008 14:43:43 +0000 David Howells <dhowells@redhat.com> wrote:

> Add an address space operation to write one single page of data to an inode at
> a page-aligned location (thus permitting the implementation to be highly
> optimised).  The data source is a single page.
> 
> This is used by CacheFiles to store the contents of netfs pages into their
> backing file pages.
> 
> Supply a generic implementation for this that uses the write_begin() and
> write_end() address_space operations to bind a copy directly into the page
> cache.
> 
> Hook the Ext2 and Ext3 operations to the generic implementation.
> 
>
> ...
>
> +
> +	/* write the contents of the source page over the page at the specified
> +	 * index in the target address space (the source page does not need to
> +	 * be related to the target address space) */
> +	int (*write_one_page)(struct address_space *, pgoff_t, struct page *);
>  };

Sigh.  I don't normally comment on busted comment layout, but Ingo does
so I'm allowed to ;) See recent discussion around the kmemleak patches.

> +/**
> + * generic_file_buffered_write_one_page - Write a single page of data to an
> + *	inode

kerneldoc doesn't permit line breaks in this context (unless it got
fixed recently)

> + * @mapping - The address space of the target inode
> + * @index - The target page in the target inode to fill
> + * @source - The data to write into the target page
> + *
> + * Write the data from the source page to the page in the nominated address
> + * space at the @index specified.  Note that the file will not be extended if
> + * the page crosses the EOF marker, in which case only the first part of the
> + * page will be written.
> + *
> + * The @source page does not need to have any association with the file or the
> + * target page offset.
> + */

