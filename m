Return-Path: <linux-kernel-owner+w=401wt.eu-S965668AbXC1S4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965668AbXC1S4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 14:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965671AbXC1S4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 14:56:41 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:57692 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965668AbXC1S4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 14:56:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=qY9n31eFc0y7g+VXLUGRSvv2gQFN/FP6ThCOoH3VYzSrBC2roiMDYFymc9CrWV7TelIUKEa4L+Po56g4v0jEg5yCsEqfqGtywpuVvnOA0XF1ETSfbBcVRIYMgTMNpE+UG2ep4pX5TvDv3ehOE77Ha8ifwKWqyHvPDvDt3bYMiwc=
Date: Wed, 28 Mar 2007 22:56:32 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andreas Mohr <andi@rhlx01.fht-esslingen.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: tty OOPS (Re: 2.6.21-rc5-mm2)
Message-ID: <20070328185632.GB5306@martell.zuzino.mipt.ru>
References: <20070326211627.c681af3b.akpm@linux-foundation.org> <20070328170214.GA13044@rhlx01.hs-esslingen.de> <20070328173310.GA4682@rhlx01.hs-esslingen.de> <20070328174524.GA25709@rhlx01.hs-esslingen.de> <20070328180446.GA7528@rhlx01.hs-esslingen.de> <20070328183814.GA5306@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070328183814.GA5306@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2007 at 10:38:14PM +0400, Alexey Dobriyan wrote:
> On Wed, Mar 28, 2007 at 08:04:46PM +0200, Andreas Mohr wrote:
> > [unrelated maintainers removed, Alexey added]
> >
> > On Wed, Mar 28, 2007 at 07:45:24PM +0200, Andreas Mohr wrote:
> > > Hi,
> > >
> > > just wanted to add that when analyzing the backtrace I found the comment
> > > at drivers/char/vt.c/con_close() to be VERY suspicious...
> > > (need to take tty_mutex to prevent concurrent thread tty access).
> > > This might just be what happened here despite trying to protect against it.
> >
> > OK, can we assume that one of
> >
> > +protect-tty-drivers-list-with-tty_mutex.patch
> > +tty-minor-merge-correction.patch
> > +tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up-fix.patch
> >
> > is responsible / not implemented fully?
>
> #2 is just comment removal.
>
> I may state the obvious, but __iget() in sysfs_drop_dentry() gets NULL
> inode and you aren't failing on spin_lock one line above because of UP
> without spinlock debugging.

The only suspicious new patch in -rc5-mm1 to me is
fix-sysfs-reclaim-crash.patch which removes "sd->s_dentry = NULL;". Note
that whole sysfs_drop_dentry() is NOP if ->s_dentry is NULL.

Could you try to revert it?

	Alexey, who knows very little about sysfs internals

