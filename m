Return-Path: <linux-kernel-owner+w=401wt.eu-S1758401AbZBBVdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758401AbZBBVdY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 16:33:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754005AbZBBVdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 16:33:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35196 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893AbZBBVdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 16:33:14 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: PCI PM: Restore standard config registers of all devices early
Date: Mon, 2 Feb 2009 22:32:33 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <alpine.LFD.2.00.0902021236040.3247@localhost.localdomain> <1233608437.18767.106.camel@pasglop>
In-Reply-To: <1233608437.18767.106.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902022232.33680.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 February 2009, Benjamin Herrenschmidt wrote:
> On Mon, 2009-02-02 at 12:41 -0800, Linus Torvalds wrote:
> > 
> > On Tue, 3 Feb 2009, Benjamin Herrenschmidt wrote:
> > > 
> > > I'd rather hook it up inside pci_set_power_state()...
> > 
> > Umm. But you already _have_ that. Look at platform_pci_set_power_state(). 
> > It gets called before turning the device on (pci_raw_set_power_state(D0)) 
> > and after turning the device off (pci_raw_set_power_state(D1+))
> > 
> > Maybe you missed it? It's how ACPI does things.
> 
> I may well have, it didn't exist when my stuff was written.
> 
> > However, the issue you see is that pci_restore_standard_config() doesn't 
> > call it, because at least with ACPI, the ACPI code simply isn't ready to 
> > be called with interrupts off. So it looks like you may be looking at the 
> > wrong thing, hmm?
> 
> Well.. yes and no... I still don't see how it can be sane to whack config
> space back before the device has been turned back on. I wouldn't be surprised
> if some devices don't grok well their BARs being written while not in D0.
> 
> I suppose I can always add another hook inside pci_restore_blah for my specific
> case but I can also very easily see that can of worms hitting even more badly
> in tight embedded environments such as handhelds, who use things like fine clock
> control a lot more extensively.
> 
> In fact, even on x86, I'm not sure it's kosher to restore the config space
> before you called ACPI...

It need not be in theory, but I haven't seen any real life example of that.

I think devices without the PM capability are suspicious, so to speak.

Thanks,
Rafael
