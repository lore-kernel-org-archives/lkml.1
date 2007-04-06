Return-Path: <linux-kernel-owner+w=401wt.eu-S2992600AbXDFA7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992600AbXDFA7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 20:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992796AbXDFA7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 20:59:09 -0400
Received: from smtp.osdl.org ([65.172.181.24]:59789 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992600AbXDFA7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 20:59:07 -0400
Date: Thu, 5 Apr 2007 17:59:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/3] epoll cleanups - epoll include diet ...
Message-Id: <20070405175905.733705cf.akpm@linux-foundation.org>
In-Reply-To: <send-serie.davidel@xmailserver.org.19972.1175650506.1>
References: <send-serie.davidel@xmailserver.org.19972.1175650506.1>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Apr 2007 18:35:06 -0700
Davide Libenzi <davidel@xmailserver.org> wrote:

> Remove some unneeded include files from epoll code.
> 

Our definitions of "unneeded" might differ.

> 
> Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
> 
> 
> - Davide
> 
> 
> 
> Index: linux-2.6.21-rc5.mm4/fs/eventpoll.c
> ===================================================================
> --- linux-2.6.21-rc5.mm4.orig/fs/eventpoll.c	2007-04-03 17:59:54.000000000 -0700
> +++ linux-2.6.21-rc5.mm4/fs/eventpoll.c	2007-04-03 18:33:30.000000000 -0700
> @@ -1,6 +1,6 @@
>  /*
> - *  fs/eventpoll.c ( Efficent event polling implementation )
> - *  Copyright (C) 2001,...,2006	 Davide Libenzi
> + *  fs/eventpoll.c (Efficent event notification implementation)
> + *  Copyright (C) 2001,...,2007	 Davide Libenzi
>   *
>   *  This program is free software; you can redistribute it and/or modify
>   *  it under the terms of the GNU General Public License as published by
> @@ -17,30 +17,21 @@
>  #include <linux/sched.h>
>  #include <linux/fs.h>
>  #include <linux/file.h>
> -#include <linux/signal.h>
>  #include <linux/errno.h>
> -#include <linux/mm.h>
>  #include <linux/slab.h>
>  #include <linux/poll.h>
>  #include <linux/string.h>
>  #include <linux/list.h>
>  #include <linux/hash.h>
>  #include <linux/spinlock.h>
> -#include <linux/syscalls.h>
>  #include <linux/rwsem.h>
>  #include <linux/rbtree.h>
>  #include <linux/wait.h>
>  #include <linux/eventpoll.h>
> -#include <linux/mount.h>
> -#include <linux/bitops.h>
>  #include <linux/mutex.h>
>  #include <linux/anon_inodes.h>
>  #include <asm/uaccess.h>
> -#include <asm/system.h>
> -#include <asm/io.h>
> -#include <asm/mman.h>
>  #include <asm/atomic.h>
> -#include <asm/semaphore.h>

epoll uses signal stuff and might need signal.h.  It implements syscalls
and it certainly needs to have those syscall's prototypes in scope.  It
surely uses stuff from mm.h (doesn't everything??)

I am suspecting that this patch relies upon accidental nested inclusions
from within other headers.  But that is super-fragile: change a config
item, switch to a different architecture and whoops, it doesn't compile any
more.

Maybe I'm wrong, and you somehow worked out that none of these things which
these headers define, and none the things which these headers' includees
define is used in epoll.c or in the headers which are included after these
headers, or in those headers' includees.  If so, how the heck did you do
that?


