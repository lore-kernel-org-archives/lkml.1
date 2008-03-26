Return-Path: <linux-kernel-owner+w=401wt.eu-S1761580AbYCZSH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761580AbYCZSH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 14:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757956AbYCZSHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 14:07:10 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60416 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757033AbYCZSHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 14:07:08 -0400
Date: Wed, 26 Mar 2008 11:07:01 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Meyer <thomas@m3y3r.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Gary Hade <garyhade@us.ibm.com>, pm@debian.org
Subject: Re: [patch] pci: revert "PCI: remove transparent bridge sizing"
Message-ID: <20080326180701.GA6249@us.ibm.com>
References: <47E8217C.9080400@s5r6.in-berlin.de> <20080325073117.GA8469@elte.hu> <20080325165007.GA7775@elte.hu> <47E94557.4030001@m3y3r.de> <20080325201125.GD15330@elte.hu> <20080325202954.GA22007@elte.hu> <47E969E1.6080608@m3y3r.de> <alpine.LFD.1.00.0803251445500.2775@woody.linux-foundation.org> <20080326101450.GA9060@jurassic.park.msu.ru> <20080326135458.GA27621@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080326135458.GA27621@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 02:54:58PM +0100, Ingo Molnar wrote:
> 
> * Ivan Kokshaysky <ink@jurassic.park.msu.ru> wrote:
> 
> > Thomas, can you put CONFIG_RESOURCES_64BIT=y back and either revert 
> > commit 8fa5913d54f3b1e09948e6a0db34da887e05ff1f, or just comment out 
> > these two lines in drivers/pci/setup-bus.c:
> > 
> > 		if (bus->self->transparent)
> > 			break;
> > 
> > and check if it helps?
> 
> alternatively, try x86.git/latest which has the revert below included.

As the author of the "PCI: remove transparent bridge sizing" change,
I apologize for the trouble it seems to have caused.  The same change
had also exposed an issue reported by Paul Martin that has been causing
an Oops while hotplugging ThinkPads to a ThinkPad Dock II.
 re: http://lkml.org/lkml/2008/2/19/405
     http://bugzilla.kernel.org/show_bug.cgi?id=9961
I have a fix for the ThinkPad docking Oops but if the issue being
discussed here is caused by the transparent bridge sizing removal
change I totally agree that it should be reverted.  

The transparent bridge sizing removal change was motivated by
insufficient PCI memory resource for a transparent bridge window
that was being created as a result of expansion ROM(s) being included
in the transparent bridge sizing calculations.  A later
"PCI: Remove default PCI expansion ROM memory allocation" change
( re: http://lkml.org/lkml/2007/12/11/361 ) removes the expansion
ROM(s) from the transparent bridge sizing calculations which actually
resolves the original issue in a different manner.  So, even if the
"PCI: remove transparent bridge sizing" is not problematic it is
no longer needed anyway.

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

