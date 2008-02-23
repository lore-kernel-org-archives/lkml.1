Return-Path: <linux-kernel-owner+w=401wt.eu-S1758981AbYBWTat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758981AbYBWTat (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 14:30:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbYBWTak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 14:30:40 -0500
Received: from fonzie.hosting9000.com ([85.214.50.12]:38584 "EHLO
	fonzie.hosting9000.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbYBWTak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 14:30:40 -0500
Message-ID: <47C07457.1060606@frugalware.org>
Date: Sat, 23 Feb 2008 20:30:31 +0100
From: Gabriel C <crazy@frugalware.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071204)
MIME-Version: 1.0
To: Dave Jones <davej@codemonkey.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Gabriel C <nix.or.die@googlemail.com>, Dave Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Gabriel C <crazy@frugalware.org>,
       Doug Thompson <dougthompson@xmission.com>, Greg KH <greg@kroah.com>
Subject: Re: modular intel-agp does not work on my box
References: <47BE222B.2080500@googlemail.com> <alpine.DEB.0.82.0802220205410.3412@skynet.skynet.ie> <47BE32C7.5060008@googlemail.com> <47BE4125.3080503@googlemail.com> <20080222041921.GD21061@codemonkey.org.uk> <20080223000355.42219a89.akpm@linux-foundation.org> <20080223181414.GA24313@codemonkey.org.uk>
In-Reply-To: <20080223181414.GA24313@codemonkey.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Sat, Feb 23, 2008 at 12:03:55AM -0800, Andrew Morton wrote:
>  
>  > >  > You are right without EDAC built , agp modular does work fine. I'm on 2.6.25-rc2-00477-g1a4c6be right now.
>  > >  > So it is an EDAC bug ?
>  > >  
>  > > No, it's a failing of the pci driver model. It currently doesn't
>  > > allow more than one driver to be bound to a single PCI device.
>  > > For multi-function devices like bridges, this means we see problems
>  > > like the one you mention.
>  > 
>  > Well that sounds pretty bad.  What will distros do about this?
> 
> either
> *  ship both modular, and let the user decide which one he wants.

If you do so you have to blacklist one by default because udev will magically load both.

> *  build just one of them (typically agp)
> *  build them both, and let the above bug happen

Well the bug was not with both build into the kernel. 
CONFIG_EDAC=Y CONFIG_EDAC_<something>=m, CONFIG_AGP=m CONFIG_AGP_INTEL=m breaks agp already.

> *  build agp into the kernel, and edac modular, breaking edac
>    for a minority.

What does happen if one builds both into the kernel ? ( eg: all the *_AGP* Y , and all the *_EDAC* y ) 

Guessing no one of them will work ?

>  
>  > Is there something short-term-and-sleazy we can do to "fix" it?
> 
> not that I'm aware of.  I think Greg has been working on a long-term fix.
> 
> 	Dave
> 

Gabriel
