Return-Path: <linux-kernel-owner+w=401wt.eu-S1762068AbXLTWhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762068AbXLTWhA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 17:37:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbXLTWgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 17:36:52 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225AbXLTWgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 17:36:51 -0500
Message-ID: <476AEE7B.6050708@redhat.com>
Date: Thu, 20 Dec 2007 17:36:43 -0500
From: Tony Camuso <tcamuso@redhat.com>
Reply-To: tcamuso@redhat.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [Fwd: Re: [PATCH 0/5]PCI: x86 MMCONFIG]
References: <476A5FD0.4010804@redhat.com> <20071220172205.GB5636@suse.de> <476AB3B5.9080808@redhat.com> <20071220215719.GA8528@suse.de>
In-Reply-To: <20071220215719.GA8528@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Dec 20, 2007 at 01:25:57PM -0500, Tony Camuso wrote:
> Any reason why these changes were never submitted to the upstream kernel
> versions?  Or do you all just want to keep patching your newer releases
> with this information forever?  :)
> 

I really don't know why these changes were never submitted to the
upstream kernel versions".

I was brought on the scene about six months ago as HP's on-site engineer
at RH, and this was one of the things they wanted me to do.

We wanted a solution that was more generic and could manage this
problem preemptively, rather than using blacklists. Maintenance of
blacklists is a bother and almost always done after a new system
with this problem is discovered.

Furthermore, blacklisting whole platforms to use legacy pci config
penalizes any mmconfig-friendly buses in those platforms, particularly
the pci express buses, and causes such platforms to be non-compliant
with the pci expres spec.

 > Please send these kinds of changes upstream...
 >
As you wish.
:)

>> I have talked to intel about this, but they haven't gotten back to me.
> 
> Try poking them harder, they are usually very responsive to Linux kernel
> issues.
> 
> thanks,
> 
> greg k-h

Matthew Wilcox explained the problem to me. The hang that cannot be fixed
by my patch isn't the chipset's fault. The graphics device has a 64-bit
BAR asking for 256 MB of IO.

If I understand his explanation correctly, when the bus sizing code
writes the low dword of this BAR with 0xffffffff, the chip is then
programmed to claim every MMIO reference betweeen 0x00000000.f0000000 and
0x00000001.00000000

It just so happens that MMCONFIG space for the dc5700 (awa some others) is
mapped by its BIOS into that very region, so all MMCONFIG references are now
swallowed up by the graphics chip. At that point, no further boot progress can
be made.


