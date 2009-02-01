Return-Path: <linux-kernel-owner+w=401wt.eu-S1755489AbZBABZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbZBABZN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 20:25:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbZBABY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 20:24:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55009 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbZBABY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 20:24:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: What should PCI core do during suspend-resume? (was: Re: 2.6.29-rc3: tg3 dead after resume)
Date: Sun, 1 Feb 2009 02:24:18 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: Parag Warudkar <parag.lkml@gmail.com>,
       Matt Carlson <mcarlson@broadcom.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
References: <alpine.DEB.2.00.0901281858380.5048@parag-desktop> <200902010136.55375.rjw@sisk.pl> <alpine.LFD.2.00.0901311652500.3067@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0901311652500.3067@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902010224.19755.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 01 February 2009, Linus Torvalds wrote:
> 
> On Sun, 1 Feb 2009, Rafael J. Wysocki wrote:
> > 
> > All this leads to the conclusion that we should put devices into low power
> > states with interrupts off and this seems to imply that we'll need to make the
> > AML interpreter allow us to run AML with interrupts off.
> 
> How many devices actually have the _PS3 method (or whatever it is that we 
> end up executing)? We might be able to simply flag it, and say "ok, if we 
> have a _PS3 method, we'll have to suspend early, otherwise we can leave it 
> for a late suspend".

That seems doable at first sight, although I think we should take D1 and D2
into account too (the ACPI rules may be that for S3, ie. suspend to RAM, given
device should be put into D2, for example).  We have a function for checking
if device is power-manageable by ACPI.

Still, in that case, should the rule be that if the device is power-manageable
by ACPI, the PCI core is supposed to put it into a low power state (using ACPI)
with interrupts on and if the device is not power-manageable by ACPI, the
PCI core is supposed to put it into a low power state using the native PM?

> Definitely not perfect, but perhaps a way to get the safe thing on 99% of 
> all cases, and have to live with the horrid ACPI rules on some things.

They are not that uncommon AFAICS.  On all of my boxes there are devices
power-manageable by ACPI.  Usually they are USB controllers and network
adapters, but sometimes it happens to sound cards too.

> I thought the _DSW thing is common for setting up wakeup, but _PSx is not. 
> But I have not looked at many ACPI tables in my life. I try to active 
> avoid it if I at all humanly can.

Usually, we need to use ACPI to set up wake-up and then use ACPI to put the
device into a low power state.  Otherwise, the wake-up may not work.

Thanks,
Rafael
