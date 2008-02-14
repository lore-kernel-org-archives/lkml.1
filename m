Return-Path: <linux-kernel-owner+w=401wt.eu-S1758649AbYBNFIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649AbYBNFIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 00:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbYBNFIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 00:08:09 -0500
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:46009 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbYBNFII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 00:08:08 -0500
X-IronPort-AV: E=Sophos;i="4.25,349,1199685600"; 
   d="scan'208";a="539877376"
Date: Wed, 13 Feb 2008 23:07:53 -0600
From: Matt Domsch <Matt_Domsch@dell.com>
To: Greg KH <greg@kroah.com>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] PCI: remove initial bios sort of PCI devices on x86
Message-ID: <20080214050753.GA28584@auslistsprd01.us.dell.com>
References: <20080213234029.GA5119@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213234029.GA5119@kroah.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 03:40:29PM -0800, Greg KH wrote:
> We currently keep 2 lists of PCI devices in the system, one in the
> driver core, and one all on its own.  This second list is sorted at boot
> time, in "BIOS" order, to try to remain compatible with older kernels
> (2.2 and earlier days).  There was also a "nosort" option to turn this
> sorting off, to remain compatible with even older kernel versions, but
> that just ends up being what we have been doing from 2.5 days...
> 
> Unfortunately, the second list of devices is not really ever used to
> determine the probing order of PCI devices or drivers[1].  That is done
> using the driver core list instead.  This change happened back in the
> early 2.5 days.
> 
> Relying on BIOS ording for the binding of drivers to specific device
> names is problematic for many reasons, and userspace tools like udev
> exist to properly name devices in a persistant manner if that is needed,
> no reliance on the BIOS is needed.
>
> Matt Domsch and others at Dell noticed this back in 2006, and added a
> boot option to sort the PCI device lists (both of them) in a
> breadth-first manner to help remain compatible with the 2.4 order, if
> needed for any reason.  This option is not going away, as some systems
> rely on them.
> 
> This patch removes the sorting of the internal PCI device list in "BIOS"
> mode, as it's not needed at all anymore, and hasn't for many years.
> I've also removed the PCI flags for this from some other arches that for
> some reason defined them, but never used them.
> 
> This should not change the ordering of any drivers or device probing.


Good plan.  I'll be glad when the vestigal internal PCI device list is
gone too.

Thanks,
Matt

-- 
Matt Domsch
Linux Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux
