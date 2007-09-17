Return-Path: <linux-kernel-owner+w=401wt.eu-S1759688AbXIQVC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759688AbXIQVC2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 17:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754317AbXIQVCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 17:02:19 -0400
Received: from mail.gmx.net ([213.165.64.20]:48737 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753869AbXIQVCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 17:02:18 -0400
Cc: corbet@lwn.net, jengelh@computergmbh.de, hch@lst.de, stable@kernel.org,
       drepper@redhat.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, rdunlap@xenotime.net,
       vda.linux@googlemail.com, davidel@xmailserver.org
Content-Type: text/plain; charset="us-ascii"
Date: Mon, 17 Sep 2007 23:02:16 +0200
From: "Michael Kerrisk" <mtk-manpages@gmx.net>
In-Reply-To: <20070917134315.968c1902.akpm@linux-foundation.org>
Message-ID: <20070917210216.284780@gmx.net>
MIME-Version: 1.0
References: <46EEB252.30003@gmx.net>
 <20070917134315.968c1902.akpm@linux-foundation.org>
Subject: Re: [PATCH] remove timerd() syscall number
To: Andrew Morton <akpm@linux-foundation.org>
X-Authenticated: #24879014
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1+9dPxXFy29LKTeiJ8C/v2lzYkQGGw5PI8Ei6aufM
 D/7BVGXRMChCB4dYy6GTBfKgFUwl4uJ3JulA== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: OYeFLnc6TlI8Ss76DGlrQBhOU2poZRkc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > I hope I've done this right...  This patch, against 2.6.23-rc6,
> > removes the timerfd() syscall (which in any case had a bug
> > on its 2.6.22 release) from all architectures, so that we
> > can have some breathing space to think about the API design.
> > All of the existing timerfd() code is left intact.
> 
> I think a minimally-intrusive implementation would be
> 
> --- a/fs/timerfd.c~a
> +++ a/fs/timerfd.c
> @@ -159,6 +159,8 @@ asmlinkage long sys_timerfd(int ufd, int
>  	struct inode *inode;
>  	struct itimerspec ktmr;
>  
> +	return -ENOSYS;
> +
>  	if (copy_from_user(&ktmr, utmr, sizeof(ktmr)))
>  		return -EFAULT;
>  
> _
> 
> or, better,
> 
> --- a/init/Kconfig~a
> +++ a/init/Kconfig
> @@ -491,6 +491,7 @@ config SIGNALFD
>  
>  config TIMERFD
>  	bool "Enable timerfd() system call" if EMBEDDED
> +	depends on BROKEN
>  	select ANON_INODES
>  	default y
>  	help
> _

Cough!  Right then.  I take it you'll apply one of those then?
-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7 

Want to help with man page maintenance?  
Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages , 
read the HOWTOHELP file and grep the source 
files for 'FIXME'.

