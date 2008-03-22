Return-Path: <linux-kernel-owner+w=401wt.eu-S1758052AbYCVWA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052AbYCVWA1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 18:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754135AbYCVWAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 18:00:17 -0400
Received: from www.tglx.de ([62.245.132.106]:39546 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194AbYCVWAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 18:00:15 -0400
Date: Sat, 22 Mar 2008 22:58:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Ingo Molnar <mingo@elte.hu>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Thomas Meyer <thomas@m3y3r.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: ohci1394 problem (MMIO broken) (was 2.6.25-rc6-git6: Reported
 regressions from 2.6.24)
In-Reply-To: <alpine.LFD.1.00.0803221423060.3020@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0803222256410.3781@apollo.tec.linutronix.de>
References: <200803220259.48534.rjw@sisk.pl> <47E5350D.101@s5r6.in-berlin.de> <47E540E7.7030108@m3y3r.de> <47E54FA6.3060809@s5r6.in-berlin.de> <47E557D5.9020604@s5r6.in-berlin.de> <alpine.LFD.1.00.0803221423060.3020@woody.linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Mar 2008, Linus Torvalds wrote:
> On Sat, 22 Mar 2008, Stefan Richter wrote:
> > 
> > Can an MMIO region reside above 0x1'0000'0000 on x86-32? ... Apparently yes,
> > if CONFIG_RESOURCES_64BIT=y.
> 
> Hmm. It would only work if PAE (HIGHMEM64G) is enabled too.
> 
> And obviously the hardware has to have working 64-bit BAR's.
> 
> AND no, I don't think our x86-32 ioremap() actually works for this case, 
> because while the resource data may have the full 64 bits, when the 
> ioremap() happens it gets truncated to 32 bits.
> 
> Ingo/Thomas - should ioremap*() perhaps take "resource_size_t" or a "u64" 
> for the address (and then "__ioremap()" should probably take a PFN, not a 
> physical address, and that one can remain just a "unsigned long"?)

Hmm. No idea. I look into that on monday (tomorrow is family
day). Right now I'm too tired to provide any useful input.
 
> Has anybody ever had a working 64-bit BAR on x86? Ivan? Maybe I'm missing 
> something..

Same here.

Thanks,

	tglx
