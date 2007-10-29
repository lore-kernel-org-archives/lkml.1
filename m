Return-Path: <linux-kernel-owner+w=401wt.eu-S1754986AbXJ2UVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986AbXJ2UVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 16:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbXJ2UVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 16:21:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37015 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752944AbXJ2UVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 16:21:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [BUG] [linux-pm] Commit "Hibernation: Enter platform hibernation state in a consistent way)" makes my system to resume instantly from S4
Date: Mon, 29 Oct 2007 21:37:37 +0100
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200710271405.32908.maximlevitsky@gmail.com> <200710282123.15653.rjw@sisk.pl> <200710290845.11016.maximlevitsky@gmail.com>
In-Reply-To: <200710290845.11016.maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710292137.37997.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 29 October 2007 07:45, Maxim Levitsky wrote:
> On Sunday 28 October 2007 22:23:15 Rafael J. Wysocki wrote:
> > On Sunday, 28 October 2007 21:00, Maxim Levitsky wrote:
> > > On Saturday 27 October 2007 23:46:45 Rafael J. Wysocki wrote:
> > > > On Saturday, 27 October 2007 14:05, Maxim Levitsky wrote:
> > > > > Hi,
> > > > > 
> > > > > Recently I noticed that my system resumes just after suspend to disk.
> > > > > 
> > > > > I traced this to commit 9cd9a0058dd35268b24fa16795a92c800f4086d4.
> > > > > 
> > > > > Note:
> > > > > 
> > > > > This happens only if I enable WOL using /proc/acpi/wakeup
> > > > > (echo "ILAN" > /proc/acpi/wakeup)
> > > > 
> > > > What happens after a suspend to RAM?
> > > I do more testing tomorrow, but what I remember is that,
> > > I had no issues with suspend-to-ram.
> > > (And take into account the fact that _all_ wakeup devices were enabled always,
> > > the rc.local does that for me, and still I did quite a lot of suspends, but I
> > > got the immediate resume, only and always after suspend to disk.
> > 
> > Hm, can you please retest with the above commit applied, but with
> > device_suspend() in hibernation_platform_enter() replaced by device_shutdown()?
> Bingo! doing the above fixes this problem.
> And... strange, since I did test the system with e1000 unloaded, but still got same bug,
> back when I chased that bug, thus it is probably not related to e1000 and WOL.
> 
> the ACPI wake-up source (I have read the DSDT, and ICH datasheets, thus I know that this is a set of bits in southbridge)
> of e1000 is shared with EHCI and HDA sound codec.
> (But usb on my system only able to wake from S3, and the soundchip which can theoretically wake up from S3 too, doesn't have this ability)
> 
> (But disabling this wakeup source, fixes this bug too)

OK

Please get back to device_suspend() in hibernation_platform_enter() and try
to unload ehci_hcd before hibernation with the wakeup source enabled.

Greetings,
Rafael
