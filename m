Return-Path: <linux-kernel-owner+w=401wt.eu-S1756169AbXHROGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169AbXHROGy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 10:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbXHROGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 10:06:43 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49231 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755630AbXHROGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 10:06:31 -0400
Date: Sat, 18 Aug 2007 19:49:12 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Jeff Dike <jdike@addtoit.com>
cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Joe Perches <joe@perches.com>
Subject: Re: [PATCH 6/6] UML - Fix hostfs style
In-Reply-To: <20070817194342.GA8759@c2.user-mode-linux.org>
Message-ID: <alpine.LFD.0.999.0708181924020.29105@enigma.security.iitk.ac.in>
References: <20070817194342.GA8759@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 17 Aug 2007, Jeff Dike wrote:

> Style fixes in hostfs.

> Index: linux-2.6.22/fs/hostfs/hostfs_kern.c
> [...]
> @@ -6,22 +6,15 @@
>   * 2003-02-10 Petr Baudis <pasky@ucw.cz>
>   */
>  
> -#include <linux/stddef.h>
>  #include <linux/fs.h>
>  #include <linux/module.h>
> -#include <linux/init.h>
> -#include <linux/slab.h>
> +#include <linux/mm.h>
>  #include <linux/pagemap.h>
> -#include <linux/blkdev.h>
> -#include <linux/list.h>
>  #include <linux/statfs.h>
> -#include <linux/kdev_t.h>
>  #include <linux/swap.h> /* mark_page_accessed */
> -#include <asm/uaccess.h>
>  #include "hostfs.h"
> -#include "kern_util.h"
> -#include "kern.h"
>  #include "init.h"
> +#include "kern.h"

Not really a style fix :-)


> @@ -328,17 +326,17 @@ int hostfs_readdir(struct file *file, vo
> [...]
> -		if(error) break;
> +		if (error) break;

		if (error)
			break;


> @@ -522,28 +523,28 @@ static int init_inode(struct inode *inod
> [...]
>  	else type = OS_TYPE_DIR;

I wonder what's the generally accepted / followed coding style for this,
actually. Personally I'd prefer:

	else
		type = OS_TYPE_DIR;


>  	else inode->i_op = &hostfs_iops;

>  	else inode->i_fop = &hostfs_file_fops;

>  	else inode->i_mapping->a_ops = &hostfs_aops;

>  	else error = read_name(inode, name);

Ditto.


>  	else
>  		err = access_file(name, r, w, x);

Here we've used the (different, and preferred IMHO) style. You could
make this style common throughout this file.


> +	else if (err > 0) {

This is fine, by the way. "if", or even a "{" in the same line after
"else" is okay, but not a statement by itself.


> Index: linux-2.6.22/fs/hostfs/hostfs_user.c
> [...]
> -#include <unistd.h>
>  #include <stdio.h>
> -#include <fcntl.h>
> +#include <stddef.h>
> +#include <unistd.h>
>  #include <dirent.h>
>  #include <errno.h>
> -#include <utime.h>
> +#include <fcntl.h>
>  #include <string.h>
>  #include <sys/stat.h>
>  #include <sys/time.h>
> +#include <sys/types.h>
>  #include <sys/vfs.h>
>  #include "hostfs.h"
> -#include "kern_util.h"
> +#include "os.h"
>  #include "user.h"
> +#include <utime.h>

Not a style fix again ...


>  	else return OS_TYPE_FILE;

>  	else return 0;

>  	else panic("Impossible mode in open_file");

>  	else return fd;

For the "else return" cases, you could consider making the code such that
there's a single return at the end, and a "ret" that is set by the code
appropriately. You'll find counter-examples, sure, but often multiple
"return"s in a function are confusing from a style point of view.


Otherwise, I saw both the patches I was cc'ed on, and both look good
to me, thank you.
