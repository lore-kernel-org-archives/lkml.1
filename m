Return-Path: <linux-kernel-owner+w=401wt.eu-S1767172AbXDTS3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767172AbXDTS3K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 14:29:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767174AbXDTS3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 14:29:10 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48785 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767172AbXDTS3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 14:29:08 -0400
Date: Fri, 20 Apr 2007 11:28:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jesse Barnes <jesse.barnes@intel.com>
cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       Adam Jackson <ajackson@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: PCI bridge range sizing bug
In-Reply-To: <200704200932.52181.jesse.barnes@intel.com>
Message-ID: <alpine.LFD.0.98.0704201102000.9964@woody.linux-foundation.org>
References: <1175812632.17147.12.camel@localhost.localdomain>
 <alpine.LFD.0.98.0704191702200.9964@woody.linux-foundation.org>
 <20070420132352.A19232@jurassic.park.msu.ru>
 <200704200932.52181.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 20 Apr 2007, Jesse Barnes wrote:
> 
> Sounds good, hopefully reassigning the bridge resources won't cause too 
> much trouble.  Do you have time to hack this up?  If not, I could give 
> it a try, as long as ajax is willing to test...

Actually, I would suggest we not do it automatically (because the need for 
it is just so low, and the downsides are potentially huge - there are just 
too many resources that are "hidden" from us through ACPI tricks and 
having hardware that doesn't actually expose their PCI resources fully 
through the normal PCI resource setup).

So I'd suggest that at least initially, we could/should just make it a 
decision based on a command line flag like the "pci=assign-busses" thing 
is now (which forces bus *numbers* to be re-assigned regardless of how 
they were assigned by the firmware, not the actual resources).

Because realistically, I don't think we'll see any common PC platform that 
actually needs it. Simply because I seriously doubt Windows reassignes bus 
resources either.

Ivan, want to add some way to force that allocation (something like 
"pci=assign-bus-resources")

		Linus
