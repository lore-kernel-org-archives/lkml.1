Return-Path: <linux-kernel-owner+w=401wt.eu-S1764003AbXFGQAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764003AbXFGQAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 12:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764059AbXFGP7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 11:59:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51582 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763975AbXFGP7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 11:59:47 -0400
Date: Thu, 7 Jun 2007 08:43:42 -0700
From: Greg KH <gregkh@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Jones <pjones@redhat.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1
Message-ID: <20070607154342.GA16911@suse.de>
References: <20070606020737.4663d686.akpm@linux-foundation.org> <4667018D.7020407@googlemail.com> <1181168095.3612.4.camel@lov.localdomain> <4667C47C.2010207@googlemail.com> <1181206091.3625.9.camel@lov.localdomain> <4667D2DF.30207@googlemail.com> <1181228660.3625.23.camel@lov.localdomain> <46682385.1060802@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46682385.1060802@redhat.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 11:25:57AM -0400, Peter Jones wrote:
>  Kay Sievers wrote:
> > On Thu, 2007-06-07 at 11:41 +0200, Michal Piotrowski wrote:
> >> Kay Sievers pisze:
> >>> On Thu, 2007-06-07 at 10:40 +0200, Michal Piotrowski wrote:
> >>>> Kay Sievers pisze:
> >>>>> On Wed, 2007-06-06 at 20:48 +0200, Michal Piotrowski wrote:
> >>>>>> Andrew Morton pisze:
> >>>>>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm1/
> >>>>>>>
> >>>>>> Kay, your patch gregkh-driver-block-device.patch breaks Fedora 7 
> >>>>>> initrd
> >>>>>> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-rc4-mm1/initrd.jpg
> >>>>>>
> >>>>>> Please fix it ASAP, I can't test kernel...
> >>>>> Do you have CONFIG_SYSFS_DEPRECATED set or unset?
> >>>>>
> >>>>> Kay
> >>>>>
> >>>>>
> >>>> cat ../linux-mm-bo/.config | grep CONFIG_SYSFS_DEPRECATED
> >>>> # CONFIG_SYSFS_DEPRECATED is not set
> >>> Oh, could you possibly try (with the block patch included) setting it to
> >>> yes and see if it works? That would help to find what's going wrong.
> >> I enabled CONFIG_SYSFS_DEPRECATED and 2.6.22-rc4-mm2 boots fine.
> > Michal, thanks a lot for the testing.
> > Peter, looking at your mkinitrd code, it works only with
> > CONFIG_SYSFS_DEPRECATED enabled when block devices are converted to
> > class devices.
> > Any chance to replace lstat() with stat() while looking for devices in
> > sysfs? Remember, _anything_ in sysfs can be symlink or a directory, you
> > can't assume one or the other. When things change internally in the
> > kernel, we can often provide symlinks for backwards compatibility, but
> > lstat() obviously can't works here.
> 
>  Fixed in mkinitrd-6.0.9-6 , which I'll build now and push to 
>  updates-testing.  Thanks for getting my attention here.

Great, Andrew, can you please reenable the block-device patch that is in
my tree now that the problem has been solved?

thanks,

greg k-h
