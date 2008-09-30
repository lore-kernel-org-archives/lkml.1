Return-Path: <linux-kernel-owner+w=401wt.eu-S1754191AbYI3Tq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbYI3Tq5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 15:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbYI3Tqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 15:46:48 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:43678 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbYI3Tqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 15:46:47 -0400
Message-ID: <48E28329.7040305@keyaccess.nl>
Date: Tue, 30 Sep 2008 21:51:05 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       Frans Pop <elendil@planet.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-acpi@vger.kernel.org, Adam Belay <abelay@mit.edu>,
       Avuton Olrich <avuton@gmail.com>,
       Karl Bellve <karl.bellve@umassmed.edu>, Willem Riede <wriede@riede.org>,
       Matthew Hall <mhall@mhcomputing.net>
Subject: Re: [patch 2/2] PNP: don't check disabled PCI BARs for conflicts
 in quirk_system_pci_resources()
References: <200809290953.56565.bjorn.helgaas@hp.com> <200809290957.59813.bjorn.helgaas@hp.com> <alpine.LFD.1.10.0809290912060.3265@nehalem.linux-foundation.org> <48E11EFA.8010402@keyaccess.nl> <alpine.LFD.2.00.0809291211330.3389@nehalem.linux-foundation.org> <48E1EF0E.8030006@keyaccess.nl> <alpine.LFD.2.00.0809300741320.3389@nehalem.linux-foundation.org> <48E24C6F.3030903@keyaccess.nl> <alpine.LFD.2.00.0809300904530.3389@nehalem.linux-foundation.org> <alpine.LFD.2.00.0809301052200.3436@nehalem.linux-foundation.org> <alpine.LFD.2.00.0809301107500.3262@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0809301107500.3262@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30-09-08 20:13, Linus Torvalds wrote:
> 
> On Tue, 30 Sep 2008, Linus Torvalds wrote:
>> Hmm?  Bjorn? Everything that is true about "pnp_system_init" should be 
>> equally true abote pnpacpi_init and pnpbios_init, no?
> 
> Side note: unlike the more radical "move all arch driver initcalls 
> earlier", this one actually works for me. But it does cause 
> pnp_system_init() to actually run before pnpacpi_init and pnpbios_init, 
> due to the link order within PnP. That seems ok, since the system/acpi/pnp 
> drivers should all be just different versions of PnP drivers, but I 
> thought I'd mention it. Maybe there is some PnP internal reason why 
> pnp_system_init should run after the pnp_acpi/bios_init functions.
> 
> (And if so, then just changing the order in drivers/pnp/Makefile would fix 
> it up again).
> 
> Bjorn, is there any reason why this isn't the right thign to do?
> 
> Rene - I have this suspicion that just doing this part should already fix 
> your issues with _no_ other patch, since now anything PnP does is after 
> all the PCI setup code anyway. So does your sound card (or whatever it 
> was) work by just doing the subsys_initcall -> fs_initcall change in PnP?

I'll have to wait for the message to arrive here or in a web-archive to 
answer that (...) but please note that I am already fine with the 
original code; it is the fix for my own issue that's IN mainline (ie, 
not only check for MEM resource overlaps but also IO) that now made 
Frans Pop yell due to his machine now spitting out lots of I/O overlap 
warnings -- which turned out to not be real overlaps, but due to a 
uninialized BAR.

You might want Frans to test this though then...

Rene.
