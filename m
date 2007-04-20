Return-Path: <linux-kernel-owner+w=401wt.eu-S1030924AbXDTQce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030924AbXDTQce (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 12:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030929AbXDTQce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 12:32:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:7536 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030924AbXDTQcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 12:32:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,433,1170662400"; 
   d="scan'208"; a="216737923:sNHT18985484"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: PCI bridge range sizing bug
Date: Fri, 20 Apr 2007 09:32:51 -0700
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Adam Jackson <ajackson@redhat.com>, linux-kernel@vger.kernel.org
References: <1175812632.17147.12.camel@localhost.localdomain> <alpine.LFD.0.98.0704191702200.9964@woody.linux-foundation.org> <20070420132352.A19232@jurassic.park.msu.ru>
In-Reply-To: <20070420132352.A19232@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704200932.52181.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 20, 2007 2:23 am Ivan Kokshaysky wrote:
> On Thu, Apr 19, 2007 at 05:19:20PM -0700, Linus Torvalds wrote:
> > I think we used to *never* assign PCI bus resources on x86, but
> > that thing got fixed some time ago. Now I think we only re-assign
> > them if they were unassigned *or* if the assignment wasn't working
> > before. But I'm not 100% sure about that second part... It's been
> > working so well that I don't think we've had a lot of problems with
> > resource assignment lately, and I've paged it all out of my brain.
> >
> > Ivan, can you remind my tired old brain?
>
> No :-)  You are absolutely right - we re-assign only unassigned OR
> conflicting resources. And yes, x86 kernel does accept any enabled
> bridge ranges without looking at what is on the other side of the
> bridge.
>
> I think what we need is some very minimalistic validity check for
> BIOS bridge setup: calculate sums of resource ranges of each type
> (or just MEM and PREFETCH, should we care about IO these days?)
> for devices that are behind the bridge, even without taking alignment
> requirements into account. Then, if some window is too small, we just
> let the pci_assign_unassigned_resources to take care of that.

Sounds good, hopefully reassigning the bridge resources won't cause too 
much trouble.  Do you have time to hack this up?  If not, I could give 
it a try, as long as ajax is willing to test...

Thanks,
Jesse
