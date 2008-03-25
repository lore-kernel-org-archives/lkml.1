Return-Path: <linux-kernel-owner+w=401wt.eu-S1761517AbYCYVtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761517AbYCYVtq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 17:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757424AbYCYVth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 17:49:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53551 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753692AbYCYVth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 17:49:37 -0400
Date: Tue, 25 Mar 2008 14:47:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Meyer <thomas@m3y3r.de>
cc: Ingo Molnar <mingo@elte.hu>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: ohci1394 problem (MMIO broken) (was 2.6.25-rc6-git6: Reported
 regressions from 2.6.24)
In-Reply-To: <47E969E1.6080608@m3y3r.de>
Message-ID: <alpine.LFD.1.00.0803251445500.2775@woody.linux-foundation.org>
References: <47E54FA6.3060809@s5r6.in-berlin.de> <47E557D5.9020604@s5r6.in-berlin.de> <alpine.LFD.1.00.0803221423060.3020@woody.linux-foundation.org> <alpine.LFD.1.00.0803221558450.3020@woody.linux-foundation.org> <47E807EE.2030902@m3y3r.de>
 <47E8217C.9080400@s5r6.in-berlin.de> <20080325073117.GA8469@elte.hu> <20080325165007.GA7775@elte.hu> <47E94557.4030001@m3y3r.de> <20080325201125.GD15330@elte.hu> <20080325202954.GA22007@elte.hu> <47E969E1.6080608@m3y3r.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 25 Mar 2008, Thomas Meyer wrote:
> 
> and compare lspci -vv from 2.6.25 and 2.6.24:
> 
> 2.6.25:
>
>    Region 0: [virtual] Memory at 100000000 (32-bit, non-prefetchable) [size=4K]
> 
> 2.6.24:
>
>    Region 0: Memory at 8c000000 (32-bit, non-prefetchable) [size=4K]

Ok, so it didn't use to be at the 4GB mark.

This seems to be a PCI and resource alloc issue. It would be really 
interesting to see where the 4GB allocation started. Ie ignore anything 
else (warnings, driver loadings etc), and _just_ look at lspci -vv output 
for where the memory got allocated.

Did you already bisect that and I just missed it?

		Linus
