Return-Path: <linux-kernel-owner+w=401wt.eu-S1756611AbYLEAqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbYLEAqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 19:46:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbYLEAq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 19:46:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43859 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752127AbYLEAq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 19:46:27 -0500
Date: Thu, 4 Dec 2008 16:45:47 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Frans Pop <elendil@planet.nl>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken
 on Toshiba R500 (bisected)
In-Reply-To: <alpine.LFD.2.00.0812041545130.3543@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0812041645290.3543@nehalem.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812042309.11540.rjw@sisk.pl> <alpine.LFD.2.00.0812041415020.3543@nehalem.linux-foundation.org> <200812050031.27287.rjw@sisk.pl> <alpine.LFD.2.00.0812041545130.3543@nehalem.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 4 Dec 2008, Linus Torvalds wrote:
> 
> On Fri, 5 Dec 2008, Rafael J. Wysocki wrote:
> > 
> > There's a difference, though.  It doesn't cause the resources flags to be
> > cleared for the cardbus bridge and the cardbus bridge gets the correct sizes
> > of both prefetchable and non-prefetchable windows (64 MB).
> 
> Yes, true. In that sense, it minimizes the differences between the 
> "working" and "nonworking" case. 

Hmm. 

One other issue: we've been looking mostly at MMIO, but another thing that 
differs here is the PIO part.

Your patch only changes pbus_size_mem(), so what happens is that it avoids 
allocating the prefetch window. But it still allocates the PIO window, 
because pbus_size_io() is still run.

Maybe the PIO window matters? Any magic suspend registers are usually in 
PIO space, not in MMIO space. Did /proc/ioports change, and if so, how? 

		Linus
