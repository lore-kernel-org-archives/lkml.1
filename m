Return-Path: <linux-kernel-owner+w=401wt.eu-S933699AbXGWBkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933699AbXGWBkh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 21:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755263AbXGWBka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 21:40:30 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:50081 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746AbXGWBk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 21:40:29 -0400
Date: Mon, 23 Jul 2007 10:40:04 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: Re: Linus 2.6.23-rc1
Message-ID: <20070723014004.GA17301@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Gabriel C <nix.or.die@googlemail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Greg KH <greg@kroah.com>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <20070723012317.GA17181@linux-sh.org> <46A403F9.6020101@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A403F9.6020101@googlemail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 03:27:21AM +0200, Gabriel C wrote:
> Paul Mundt wrote:
> > On Sun, Jul 22, 2007 at 02:04:24PM -0700, Linus Torvalds wrote:
> >> Lots of architecture updates (for just about all of them - x86[-64], arm, 
> >> alpha, mips, ia64, powerpc, s390, sh, sparc, um..), lots of driver updates 
> >> (again, all over - usb, net, dvb, ide, sata, scsi, isdn, infiniband, 
> >> firewire, i2c, you name it).
> >>
> > Some of the driver model changes that went in result in a link error:
> > 
> >   CC      init/version.o
> >   LD      init/built-in.o
> >   LD      .tmp_vmlinux1
> > drivers/built-in.o: In function `store_uevent':
> > : undefined reference to `kobject_actions'
> > make: *** [.tmp_vmlinux1] Error 1
> > 
> > Haven't bisected it yet, but I suppose it's pretty obvious to whoever made the
> > changes. ;-)
> 
> CONFIG_HOTPLUG=n :)
> 
> Try this patch :
> http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/driver/kobject-fix-link-error-when-config_hotplug-is-disabled.patch
> 
Yup, that fixes it. I'll just enable it across the defconfigs for now, thanks.
