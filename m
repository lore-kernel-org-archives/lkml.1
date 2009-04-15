Return-Path: <linux-kernel-owner+w=401wt.eu-S1755087AbZDOWGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087AbZDOWGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 18:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbZDOWGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 18:06:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45478 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751362AbZDOWGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 18:06:39 -0400
Date: Wed, 15 Apr 2009 14:59:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, wli@holomorphy.com, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] hugetlbfs: return negative error code for bad mount
 option
Message-Id: <20090415145910.22910363.akpm@linux-foundation.org>
In-Reply-To: <20090413035623.GA4156@localhost.localdomain>
References: <20090413035623.GA4156@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Apr 2009 12:56:23 +0900
Akinobu Mita <akinobu.mita@gmail.com> wrote:

> This fixes the following BUG:
> 
> # mount -o size=MM -t hugetlbfs none /huge
> hugetlbfs: Bad value 'MM' for mount option 'size=MM'
> ------------[ cut here ]------------
> kernel BUG at fs/super.c:996!

I can't tell where this BUG (or WARN?) is happening unless I know
exactly which kernel version was tested.

I assume that it is BUG_ON(!mnt->mnt_sb); in vfs_kern_mount()?

> Also, remove unused #include <linux/quotaops.h>
> 
> Cc: William Irwin <wli@holomorphy.com>
> Cc: stable@kernel.org
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
> 
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 23a3c76..153d968 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -26,7 +26,6 @@
>  #include <linux/pagevec.h>
>  #include <linux/parser.h>
>  #include <linux/mman.h>
> -#include <linux/quotaops.h>
>  #include <linux/slab.h>
>  #include <linux/dnotify.h>
>  #include <linux/statfs.h>
> @@ -842,7 +841,7 @@ hugetlbfs_parse_options(char *options, struct hugetlbfs_config *pconfig)
>  bad_val:
>   	printk(KERN_ERR "hugetlbfs: Bad value '%s' for mount option '%s'\n",
>  	       args[0].from, p);
> - 	return 1;
> + 	return -EINVAL;
>  }
>  
>  static int

