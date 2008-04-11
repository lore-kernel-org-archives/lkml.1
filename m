Return-Path: <linux-kernel-owner+w=401wt.eu-S1757656AbYDKBOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757656AbYDKBOM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 21:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758545AbYDKBNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 21:13:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53586 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758196AbYDKBNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 21:13:50 -0400
Date: Thu, 10 Apr 2008 18:11:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       sam@ravnborg.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2] documentation: build source files in Documentation
 sub-dir
Message-Id: <20080410181153.92a5724d.akpm@linux-foundation.org>
In-Reply-To: <20080410175630.d862af9e.randy.dunlap@oracle.com>
References: <20080403124529.3f2efb79.randy.dunlap@oracle.com>
	<20080408134613.a047a7b6.akpm@linux-foundation.org>
	<20080409123551.42c5da0d.randy.dunlap@oracle.com>
	<20080409145409.615cd236.akpm@linux-foundation.org>
	<20080410175630.d862af9e.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Apr 2008 17:56:30 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Wed, 9 Apr 2008 14:54:09 -0700 Andrew Morton wrote:
> 
> > make allmodconfig
> > gcc -I$(/bin/pwd)/include Documentation/accounting/getdelays.c -o getdelays
> > 
> > In file included from /usr/src/devel/include/linux/netlink.h:5,
> >                  from /usr/src/devel/include/linux/genetlink.h:4,
> >                  from Documentation/accounting/getdelays.c:26:
> > /usr/src/devel/include/linux/types.h:203: error: expected specifier-qualifier-list before '__kernel_daddr_t'
> 
> 
> Those __kernel_* types shouldn't be used outside of the #ifdef __KERNEL__
> block, should they?
> 
> Patch below fixes kernel side for me.  Don't have any idea what it
> may do to userspace users of the header file.
> 
> ---
>  include/linux/types.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- mmotm-2008-0410-0157.orig/include/linux/types.h
> +++ mmotm-2008-0410-0157/include/linux/types.h
> @@ -200,8 +200,8 @@ typedef u32 resource_size_t;
>  #endif	/* __KERNEL__ */
>  
>  struct ustat {
> -	__kernel_daddr_t	f_tfree;
> -	__kernel_ino_t		f_tinode;
> +	daddr_t			f_tfree;
> +	ino_t			f_tinode;
>  	char			f_fname[6];
>  	char			f_fpack[6];
>  };

hm.

It'd be nice to know how git-x86 managed to make this happen.  I haven't
looked, apart from noting that it doesn't seem to touch any of the relevant
files.

