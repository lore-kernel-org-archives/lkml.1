Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab0CCSW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 13:22:27 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:28415 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300Ab0CCSW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 13:22:26 -0500
X-IronPort-AV: E=Sophos;i="4.49,574,1262563200"; 
   d="scan'208";a="9767123"
Date: Wed, 3 Mar 2010 18:26:12 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Bastian Blank <waldi@debian.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 4 of 4] Linux pvops: xen pci platform device
 driver
In-Reply-To: <20100303161428.GB26656@wavehammer.waldi.eu.org>
Message-ID: <alpine.DEB.2.00.1003031808310.4648@kaball-desktop>
References: <alpine.DEB.2.00.1003021748250.22259@kaball-desktop> <20100303121726.GA26656@wavehammer.waldi.eu.org> <alpine.DEB.2.00.1003031520320.4648@kaball-desktop> <20100303161428.GB26656@wavehammer.waldi.eu.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Mar 2010, Bastian Blank wrote:
> > During the initialization of the xen pci device driver, we write to a
> > magic ioport that causes qemu to unplug some emulated devices, disc and
> > network in particular.
> > This parameter is meant to present the user a choice about what emulated
> > devices to unplug.
> 
> Somehow I don't think this belongs here. It looks like a workaround, you
> can always ask qemu to not bind them at the beginning and the guest
> system to not provide drivers.
> 

Most of the time you just want to unplug all or nothing, so removing the
option is generally not a problem.
However it can still be useful for debugging: let's say that blkfront
doesn't work properly, if the xen pci platform driver unplugs the IDE
disk at init time the guest won't be able to boot.
This fact just made me realize that the xen pci platform driver should
depend on netfront and blkfront too if we make "unplug all" the default.


> > > > +#define XEN_IOPORT_BASE 0x10
> > > 
> > > Why are this constants defined in the driver themself? They only make
> > > sense if there are two components making use of them.
> > Yep, the other one is qemu.
> 
> Well, if it is a published interface move it into a header file.
> 

Good idea

