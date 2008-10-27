Return-Path: <linux-kernel-owner+w=401wt.eu-S1752969AbYJ0QNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbYJ0QNo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 12:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750876AbYJ0QNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 12:13:35 -0400
Received: from waste.org ([66.93.16.53]:45511 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795AbYJ0QNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 12:13:34 -0400
Subject: Re: Bloatwatch 2.6.28-rc1: last_sysfs_file
From: Matt Mackall <mpm@selenic.com>
To: Chris Snook <csnook@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm <akpm@linuxfoundation.org>
In-Reply-To: <4902F710.3020100@redhat.com>
References: <1224881514.3248.46.camel@calx> <1224882923.3248.51.camel@calx>
	 <4902F710.3020100@redhat.com>
Content-Type: text/plain
Date: Mon, 27 Oct 2008 11:11:38 -0500
Message-Id: <1225123898.3199.20.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-10-25 at 06:38 -0400, Chris Snook wrote: 
> Matt Mackall wrote:
> > On Fri, 2008-10-24 at 15:52 -0500, Matt Mackall wrote:
> >> 2.6.28-rc1 adds 4k for last_sysfs_file debug tracking. That's one hell
> >> of a long sysfs path.
> >>
> >> http://www.selenic.com/bloatwatch/?cmd=compare;v1=2.6.27;v2=2.6.28-rc1;part=/built-in/fs/sysfs
> > 
> > ..especially given that printk is limited to 1k at a time.
> > 
> > 
> > sysfs: shrink last_sysfs_file to a reasonable size
> > 
> > sysfs was reserving 4k to store filenames for debug despite printk being
> > limited to 1k. Shrink this to something more reasonable.
> > 
> > Signed-off-by: Matt Mackall <mpm@selenic.com>
> > 
> > diff -r ac8c82ff3be7 fs/sysfs/file.c
> > --- a/fs/sysfs/file.c	Fri Oct 24 13:13:04 2008 -0500
> > +++ b/fs/sysfs/file.c	Fri Oct 24 16:11:53 2008 -0500
> > @@ -25,7 +25,7 @@
> >  #include "sysfs.h"
> >  
> >  /* used in crash dumps to help with debugging */
> > -static char last_sysfs_file[PATH_MAX];
> > +static char last_sysfs_file[200]; /* allow for disgustingly long paths */
> >  void sysfs_printk_last_file(void)
> >  {
> >  	printk(KERN_EMERG "last sysfs file: %s\n", last_sysfs_file);
> > 
> > 
> 
> Please don't use magic numbers.  Use a symbolic constant, and modify printk.c to 
> use the same.

I'm explicitly not using a magic number because the relevant magic
number is absurdly large. It is in fact 4 times larger than printk can
print. And its 40 times larger than any path we are liable to encounter.
Inventing a new use-once #define meaning "good enough for debugging
99.99% of sysfs bugs" one line up is not an improvement here.

And why on earth would I modify anything in printk?

-- 
Mathematics is the supreme nostalgia of our time.

