Return-Path: <linux-kernel-owner+w=401wt.eu-S1762240AbXFGPGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762240AbXFGPGI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 11:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757364AbXFGPF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 11:05:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57860 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbXFGPFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 11:05:55 -0400
Subject: Re: 2.6.22-rc4-mm1
From: Kay Sievers <kay.sievers@vrfy.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Peter Jones <pjones@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <4667D2DF.30207@googlemail.com>
References: <20070606020737.4663d686.akpm@linux-foundation.org>
	 <4667018D.7020407@googlemail.com> <1181168095.3612.4.camel@lov.localdomain>
	 <4667C47C.2010207@googlemail.com> <1181206091.3625.9.camel@lov.localdomain>
	  <4667D2DF.30207@googlemail.com>
Content-Type: text/plain
Date: Thu, 07 Jun 2007 17:04:20 +0200
Message-Id: <1181228660.3625.23.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+eHj3AwAoc26N7GMsGqk0A9k9tWF1aJmh7esd
 sWiU1XPQ4uDTSLTRHi+bInch1x2BrMiEkmOXxR7roNp7PkIwj/
 a9vi7KZqPFY+ujHCm6gdCeIX1uC/bmE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-07 at 11:41 +0200, Michal Piotrowski wrote:
> Kay Sievers pisze:
> > On Thu, 2007-06-07 at 10:40 +0200, Michal Piotrowski wrote:
> >> Kay Sievers pisze:
> >>> On Wed, 2007-06-06 at 20:48 +0200, Michal Piotrowski wrote:
> >>>> Andrew Morton pisze:
> >>>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm1/
> >>>>>
> >>>> Kay, your patch gregkh-driver-block-device.patch breaks Fedora 7 initrd
> >>>> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-rc4-mm1/initrd.jpg
> >>>>
> >>>> Please fix it ASAP, I can't test kernel...
> >>> Do you have CONFIG_SYSFS_DEPRECATED set or unset?
> >>>
> >>> Kay
> >>>
> >>>
> >> cat ../linux-mm-bo/.config | grep CONFIG_SYSFS_DEPRECATED
> >> # CONFIG_SYSFS_DEPRECATED is not set
> > 
> > Oh, could you possibly try (with the block patch included) setting it to
> > yes and see if it works? That would help to find what's going wrong.
> 
> I enabled CONFIG_SYSFS_DEPRECATED and 2.6.22-rc4-mm2 boots fine.

Michal, thanks a lot for the testing.

Peter, looking at your mkinitrd code, it works only with
CONFIG_SYSFS_DEPRECATED enabled when block devices are converted to
class devices.
Any chance to replace lstat() with stat() while looking for devices in
sysfs? Remember, _anything_ in sysfs can be symlink or a directory, you
can't assume one or the other. When things change internally in the
kernel, we can often provide symlinks for backwards compatibility, but
lstat() obviously can't works here.

Thanks,
Kay

