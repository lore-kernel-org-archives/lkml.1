Return-Path: <linux-kernel-owner+w=401wt.eu-S932234AbYEGS5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234AbYEGS5G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 14:57:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759469AbYEGS4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 14:56:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34029 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756165AbYEGS4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 14:56:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: WARNING: at drivers/base/sys.c:183 sysdev_driver_register+0x7a
Date: Wed, 7 May 2008 20:56:43 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
       linux-kernel@vger.kernel.org
References: <20080422075357.GA15651@elte.hu> <200805070039.20120.rjw@sisk.pl> <1210140983.5376.2.camel@marge.simson.net>
In-Reply-To: <1210140983.5376.2.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805072056.44222.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 7 of May 2008, Mike Galbraith wrote:
> 
> On Wed, 2008-05-07 at 00:39 +0200, Rafael J. Wysocki wrote:
> > On Tuesday, 22 of April 2008, Mike Galbraith wrote:
> > > 
> > > On Tue, 2008-04-22 at 09:53 +0200, Ingo Molnar wrote:
> > > > hi Len,
> > > > 
> > > > randconfig boot testing found this new debug warning message in the 
> > > > syslog:
> > > 
> > > Ditto with Q6600 and v2.6.25-3410-g8075014.
> > 
> > Does it still happen with the current -git?
> 
> No, it was fixed by:

OK, thanks.

> commit db176c6ed8974fae94328ad5ac9e70b094ff22fd
> Author: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> Date:   Wed May 7 04:02:53 2008 +0900
> 
>     Fix bogus warning in sysdev_driver_register()
>     
>             if ((drv->entry.next != drv->entry.prev) ||
>                 (drv->entry.next != NULL)) {
>     
>     warns list_empty(&drv->entry).
>     
>     Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>     Cc: Greg KH <gregkh@suse.de>
>     Cc: Len Brown <lenb@kernel.org>
>     [ Version 2 totally redone based on suggestions from Linus & Greg ]
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> diff --git a/drivers/base/sys.c b/drivers/base/sys.c
> index 4fbb56b..358bb0b 100644
> --- a/drivers/base/sys.c
> +++ b/drivers/base/sys.c
> @@ -175,8 +175,7 @@ int sysdev_driver_register(struct sysdev_class *cls, struct sysdev_driver *drv)
>  	}
>  
>  	/* Check whether this driver has already been added to a class. */
> -	if ((drv->entry.next != drv->entry.prev) ||
> -	    (drv->entry.next != NULL)) {
> +	if (drv->entry.next && !list_empty(&drv->entry)) {
>  		printk(KERN_WARNING "sysdev: class %s: driver (%p) has already"
>  			" been registered to a class, something is wrong, but "
>  			"will forge on!\n", cls->name, drv);
> 
> 
> 
> 
> 
> 



-- 
"Premature optimization is the root of all evil." - Donald Knuth
