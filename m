Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934283Ab0CLSH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 13:07:28 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:42161 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933846Ab0CLSH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 13:07:27 -0500
X-IronPort-AV: E=Sophos;i="4.49,627,1262563200"; 
   d="scan'208";a="9922174"
Date: Fri, 12 Mar 2010 18:11:40 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 5 of 5] xen pci platform device driver
In-Reply-To: <4B996130.3030709@goop.org>
Message-ID: <alpine.DEB.2.00.1003121755580.27222@kaball-desktop>
References: <alpine.DEB.2.00.1003101504480.28412@kaball-desktop> <4B996130.3030709@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Mar 2010, Jeremy Fitzhardinge wrote:
> On 03/10/2010 07:47 AM, Stefano Stabellini wrote:
> > Hi all,
> > this patch adds the xen pci platform device driver that is responsible
> > for initializing the grant table and xenbus in PV on HVM mode.
> > Few changes to xenbus and grant table are necessary to allow the delayed
> > initialization in HVM mode.
> > Finally grant table needs few additional modifications to work in HVM
> > mode.
> >
> 
> Will you add the ability to event channels via this device's interrupt
> for back-compat?
> 

I just made it work, but I am not sending another version of my patch
series with the backward compatibile callback mechanism to the list
right now because I would like to solve the issue with Sheng first: I
hope my next series is going to be based on top of his.


> > +
> > +#define XEN_IOPORT_MAGIC_VAL 0x49d2
> > +#define XEN_IOPORT_LINUX_PRODNUM 0xffff
> > +#define XEN_IOPORT_LINUX_DRVVER  ((LINUX_VERSION_CODE<<  8) + 0x0)
> >
> 
> Surely there's a better header to put this stuff?
> 

I'll move them to include/xen/platform_pci.h


> 
> Is there any way of getting these devices back?

no


> How does the unplug appear to the kernel?  Does it depend on this
> happening before the normal disk/net/etc drivers come up?

basically the devices suddenly disapper for the pci bus, so it would be
better if it happens before the disk and net drivers come up.


> Shouldn't the unplug happen as each PV device comes up, rather than
> having to pre-specify it here?
> 

this is not how current Windows PV drivers work AFAIK, but it is a good
idea. I'll try to do this in the next version.

