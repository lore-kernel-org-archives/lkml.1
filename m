Return-Path: <linux-kernel-owner+w=401wt.eu-S1755570AbYIIAPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbYIIAPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 20:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753980AbYIIAPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 20:15:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37883 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753929AbYIIAPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 20:15:06 -0400
Date: Mon, 8 Sep 2008 17:14:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Sesterhenn <snakebyte@gmx.de>
Cc: linux-kernel@vger.kernel.org, zippel@linux-m68k.org
Subject: Re: [Patch] hfs: fix namelength memory corruption
Message-Id: <20080908171450.e57e6fcf.akpm@linux-foundation.org>
In-Reply-To: <20080908133505.GA3031@alice>
References: <20080908133505.GA3031@alice>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Sep 2008 15:35:05 +0200
Eric Sesterhenn <snakebyte@gmx.de> wrote:

> hi,
> 
> this is basically the same as
> hfsplus-fix-buffer-overflow-with-a-corrupted-image.patch.

I can't really use the above text in a changelog.  Think how it will
look in git in two years time.

> We use the length parameter for a memcopy without checking it and
> thereby corruption memory. 

"corrupting".

I assume that this bug was found using a deliberately corrupted
filesystem?  If so, that sort of thing should be described in the
changelog.

Please spend a little more time (say, 60 seconds) preparing patch
descriptions.


> Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>
> 
> --- linux/fs/hfs/catalog.c.orig	2008-09-08 15:20:15.000000000 +0200
> +++ linux/fs/hfs/catalog.c	2008-09-08 15:21:02.000000000 +0200
> @@ -190,6 +190,10 @@ int hfs_cat_find_brec(struct super_block
>  
>  	fd->search_key->cat.ParID = rec.thread.ParID;
>  	len = fd->search_key->cat.CName.len = rec.thread.CName.len;
> +	if (len > HFS_NAMELEN) {
> +		printk(KERN_ERR "hfs: bad catalog namelength\n");
> +		return -EIO;
> +	}
>  	memcpy(fd->search_key->cat.CName.name, rec.thread.CName.name, len);
>  	return hfs_brec_find(fd);
>  }

Please send a full changelog for this patch.

I can (and often do) end up writing these things myself, but it's not a
very satisfactory arrangement, particularly when I'm not provided with
sufficient information to do so.

Thanks.
