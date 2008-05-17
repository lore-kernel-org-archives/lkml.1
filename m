Return-Path: <linux-kernel-owner+w=401wt.eu-S1760293AbYEQA2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760293AbYEQA2i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 20:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754921AbYEQA23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 20:28:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49366 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754220AbYEQA22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 20:28:28 -0400
Date: Fri, 16 May 2008 17:28:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.26
Message-Id: <20080516172816.9d98c0f2.akpm@linux-foundation.org>
In-Reply-To: <20080516170310.35d7b407.randy.dunlap@oracle.com>
References: <20080420072053.6bcb7884.akpm@linux-foundation.org>
	<20080516170310.35d7b407.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2008 17:03:10 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Sun, 20 Apr 2008 07:20:53 -0700 Andrew Morton wrote:
> 
> > 
> > These can be found at
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25/2.6.25-mm1
> > 
> > 
> > 
> >  #
> >  # documentation
> >  #
> >  documentation-build-source-files-in-documentation-sub-dir.patch
> >  documentation-build-source-files-in-documentation-sub-dir-update.patch
> >  documentation-build-source-files-in-documentation-sub-dir-disable.patch
> > 
> > Merge
> 
> Hi,
> What happened to/with these?

I was going to ask you that.  Last I heard,

a) stuff broke and

b) you had an updated version somewhere.

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

I didn't apply that.  I guess the "Don't have any idea" bit was scary.
