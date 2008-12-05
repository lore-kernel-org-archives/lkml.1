Return-Path: <linux-kernel-owner+w=401wt.eu-S1755789AbYLEBJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbYLEBJ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 20:09:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbYLEBJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 20:09:18 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53724 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbYLEBJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 20:09:18 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken on Toshiba R500 (bisected)
Date: Fri, 5 Dec 2008 02:08:33 +0100
User-Agent: KMail/1.9.9
Cc: Frans Pop <elendil@planet.nl>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <alpine.LFD.2.00.0812041545130.3543@nehalem.linux-foundation.org> <alpine.LFD.2.00.0812041645290.3543@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0812041645290.3543@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812050208.33827.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 5 of December 2008, Linus Torvalds wrote:
> 
> On Thu, 4 Dec 2008, Linus Torvalds wrote:
> > 
> > On Fri, 5 Dec 2008, Rafael J. Wysocki wrote:
> > > 
> > > There's a difference, though.  It doesn't cause the resources flags to be
> > > cleared for the cardbus bridge and the cardbus bridge gets the correct sizes
> > > of both prefetchable and non-prefetchable windows (64 MB).
> > 
> > Yes, true. In that sense, it minimizes the differences between the 
> > "working" and "nonworking" case. 
> 
> Hmm. 
> 
> One other issue: we've been looking mostly at MMIO, but another thing that 
> differs here is the PIO part.
> 
> Your patch only changes pbus_size_mem(), so what happens is that it avoids 
> allocating the prefetch window. But it still allocates the PIO window, 
> because pbus_size_io() is still run.
> 
> Maybe the PIO window matters? Any magic suspend registers are usually in 
> PIO space, not in MMIO space. Did /proc/ioports change, and if so, how? 

|18,20c18,19
|< 1000-1fff : PCI Bus 0000:03
|<   1000-10ff : PCI CardBus 0000:04
|<   1400-14ff : PCI CardBus 0000:04
|---
|> 1000-10ff : PCI CardBus 0000:04
|> 1400-14ff : PCI CardBus 0000:04

where the first one is with my patch and the second one is with the "no sizing
for transparent bridges" patch.  No difference to my eyes, if the "transparent"
bridge is really transparent. :-)

Thanks,
Rafael
