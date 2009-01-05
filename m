Return-Path: <linux-kernel-owner+w=401wt.eu-S1754750AbZAEVwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbZAEVwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 16:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbZAEVwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 16:52:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49341 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbZAEVwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 16:52:06 -0500
Date: Mon, 5 Jan 2009 16:52:02 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Sam Ravnborg <sam@ravnborg.org>
cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <srostedt@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
       sparclinux <sparclinux@vger.kernel.org>
Subject: Re: ftrace breaks sparc64 build
In-Reply-To: <20090105213107.GA27293@uranus.ravnborg.org>
Message-ID: <alpine.DEB.1.10.0901051649240.25066@gandalf.stny.rr.com>
References: <20090105181922.GA25622@uranus.ravnborg.org> <alpine.DEB.1.10.0901051428370.27085@gandalf.stny.rr.com> <20090105195415.GA6204@uranus.ravnborg.org> <alpine.DEB.1.10.0901051458460.25066@gandalf.stny.rr.com>
 <20090105213107.GA27293@uranus.ravnborg.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 5 Jan 2009, Sam Ravnborg wrote:

> > 
> > Probably the same issue. The problem is that the first use of a variable 
> > is in the OR section of an if statement that does a return.
> > 
> > 	if (x || !(y = init_me())
> > 		return;
> > 
> > 	use_me(y);
> > 
> 
> More warnings:
> fs/partitions/check.c: In function `rescan_partitions':
> fs/partitions/check.c:511: warning: 'state' might be used uninitialized in this function
> 
> => follow same pattern
> 
> fs/compat_ioctl.c: In function `ppp_sock_fprog_ioctl_trans':
> fs/compat_ioctl.c:859: warning: 'fptr32' might be used uninitialized in this function
> fs/compat_ioctl.c: In function `do_fontx_ioctl':
> fs/compat_ioctl.c:1082: warning: 'data' might be used uninitialized in this function
> fs/compat_ioctl.c: In function `do_atmif_sioc':
> fs/compat_ioctl.c:1302: warning: 'data' might be used uninitialized in this function
> fs/compat_ioctl.c: In function `do_atm_ioctl':
> fs/compat_ioctl.c:1272: warning: 'data' might be used uninitialized in this function
> fs/compat_ioctl.c: In function `mtd_rw_oob':
> fs/compat_ioctl.c:1421: warning: 'data' might be used uninitialized in this function
> fs/compat_ioctl.c: In function `do_usbdevfs_discsignal':
> fs/compat_ioctl.c:1650: warning: 'uctx' might be used uninitialized in this function
> 
> This is:
>         if (get_user(flen, &u_fprog32->len) ||
>             get_user(fptr32, &u_fprog32->filter))
>                 return -EFAULT;

Is this all sparc cross compiler?  I'm trying to reproduce it on x86 with 
no avail :-(

I would like to test other ways to change the macro, but to do so, I need 
to get a compiler that will produce the warnings that you see. What 
version of gcc are you using?

Thanks,

-- Steve


