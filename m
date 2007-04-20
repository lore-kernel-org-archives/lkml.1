Return-Path: <linux-kernel-owner+w=401wt.eu-S2992705AbXDTJXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992705AbXDTJXx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 05:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992727AbXDTJXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 05:23:52 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:1659 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992705AbXDTJXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 05:23:52 -0400
Date: Fri, 20 Apr 2007 13:23:52 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>, Jesse Barnes <jesse.barnes@intel.com>,
       Adam Jackson <ajackson@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: PCI bridge range sizing bug
Message-ID: <20070420132352.A19232@jurassic.park.msu.ru>
References: <1175812632.17147.12.camel@localhost.localdomain> <200704191611.52125.jesse.barnes@intel.com> <20070419234014.GB3215@suse.de> <alpine.LFD.0.98.0704191702200.9964@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
In-Reply-To: <alpine.LFD.0.98.0704191702200.9964@woody.linux-foundation.org>; from torvalds@linux-foundation.org on Thu, Apr 19, 2007 at 05:19:20PM -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2007 at 05:19:20PM -0700, Linus Torvalds wrote:
> I think we used to *never* assign PCI bus resources on x86, but that thing 
> got fixed some time ago. Now I think we only re-assign them if they were 
> unassigned *or* if the assignment wasn't working before. But I'm not 100% 
> sure about that second part... It's been working so well that I don't 
> think we've had a lot of problems with resource assignment lately, and 
> I've paged it all out of my brain.
> 
> Ivan, can you remind my tired old brain?

No :-)  You are absolutely right - we re-assign only unassigned OR
conflicting resources. And yes, x86 kernel does accept any enabled
bridge ranges without looking at what is on the other side of the
bridge.

I think what we need is some very minimalistic validity check for
BIOS bridge setup: calculate sums of resource ranges of each type
(or just MEM and PREFETCH, should we care about IO these days?)
for devices that are behind the bridge, even without taking alignment
requirements into account. Then, if some window is too small, we just
let the pci_assign_unassigned_resources to take care of that.

Ivan.
