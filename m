Return-Path: <linux-kernel-owner+w=401wt.eu-S1755358AbYCLWVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbYCLWVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 18:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbYCLWVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 18:21:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53888 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751624AbYCLWVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 18:21:32 -0400
Date: Wed, 12 Mar 2008 15:20:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <greg@kroah.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Garzik <jeff@garzik.org>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <len.brown@intel.com>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: pcibios_scanned needs to be set in ACPI?  (was Re: 2.6.25-rc5:
 Reported regressions from 2.6.24)
In-Reply-To: <20080312212704.GA16836@kroah.com>
Message-ID: <alpine.LFD.1.00.0803121502450.3557@woody.linux-foundation.org>
References: <200803110014.52985.rjw@sisk.pl> <alpine.LFD.1.00.0803101913340.5896@woody.linux-foundation.org> <47D6D61F.4050805@garzik.org> <200803112341.42517.rjw@sisk.pl> <alpine.LFD.1.00.0803121300160.3557@woody.linux-foundation.org> <20080312203205.GB17187@kroah.com>
 <20080312212704.GA16836@kroah.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 12 Mar 2008, Greg KH wrote:
> 
> Ok, I think I got it.  And it looks like an ACPI bug, but one that we
> might have been ignoring for a long time...

I still think that the fact that it regressed in that PCI patch means that 
there is simply something wrong with the patch. At the very least that 
patch changed behaviour, which was *not* what it was claiming it was 
doing.

I do think it's triggered by the "acpi=noirq" setting: that means that 
ACPI *won't* disable the legacy scan. Now, admittedly that's a really odd 
thing to do, and I think it's really strange how pci_acpi_init() does that

	pcibios_scanned++;

in a place where it is not actually scanning the bus, so I do agree that 
ACPI is doing something really odd here, but the fact is, this code all 
used to work.

Can we please just fix the regression caused by that offending patch?  In 
other words: why did that patch change behaviour AT ALL?

Quite frankly, we're too late in the game to say "this exposed some other 
long-time bug". That *particular* patch needs to be fixed, or reverted. We 
can look at changing ACPI in 2.6.26, not in -rc6.

				Linus
