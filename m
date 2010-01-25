Return-Path: <linux-kernel-owner+w=401wt.eu-S1754032Ab0AYQeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab0AYQeg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 11:34:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753679Ab0AYQef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 11:34:35 -0500
Received: from cantor.suse.de ([195.135.220.2]:59046 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699Ab0AYQef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 11:34:35 -0500
Date: Mon, 25 Jan 2010 17:34:33 +0100
From: Vojtech Pavlik <vojtech@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Robert Hancock <hancockrwd@gmail.com>, Bastien Nocera <hadess@hadess.net>,
       linux-kernel <linux-kernel@vger.kernel.org>, pjones@redhat.com
Subject: Re: [PATCH] Disable i8042 checks on Intel Apple Macs
Message-ID: <20100125163433.GB31957@suse.cz>
References: <1264011793.1735.3683.camel@localhost.localdomain> <4B57A2D4.9030204@gmail.com> <20100121185544.GB11996@core.coreip.homeip.net> <51f3faa71001211339t4652700ct34659c37479cd67e@mail.gmail.com> <20100121221701.GA15293@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100121221701.GA15293@core.coreip.homeip.net>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 21, 2010 at 02:17:01PM -0800, Dmitry Torokhov wrote:
> This is from the changelog when this was introduced:
> 
> -------------------------------------------------------------------------
> 2005/02/25 21:21:03+01:00 vojtech
> input: After testing on real world hardware, it's obvious we can't trust
>        ACPIPnP nor PnPBIOS to properly report the existence of a keyboard
>        and mouse port in all cases. Some BIOSes hide the ports if no mouse
>        or keyboard is connected, causing trouble with eg. KVM switches.
> 
>        The i8042 driver now does read-only probing first, which should
>        not cause any problems even if an i8042 controller really is not
>        present.
> 
>        However, on IA64 we still need to trust ACPI, since legacy-free
>        hardware is common there and invalid port accesses cause exceptions.
> 
>  Signed-off-by: Vojtech Pavlik <vojtech@suse.cz>
> 
> >> Input: Add ACPI-based i8042 keyboard and aux controller enumeration;
> > > can be disabled by passing i8042.noacpi as a boot parameter.
> > 
> > On a whim I decided to turn on ACPI, only to discover that my keyboard
> > no longer worked. Passing i8042.noacpi=1 makes it work again.
> > Attached please find boot messages with and without the boot
> > parameter. Inlined below is a diff of the two.
> 
> --------------------------------------------------------------------------
> 
> I'm adding Vojtech in case he manages to recall what other failures he
> has seen.

I don't think I can really recall what other problems we've had back
then, but I do remember it was quite an avalanche of mails that I've
started receiving after enabling the PnPBIOS/ACPIPnP probing and
trusting it fully.

Now, from the hardware point of view it doesn't make much sense for the
BIOS to hide/disable the i8042 controller, as both the keyboard IRQ and
the 0x60-0x6f address space are reserved for it (since the IBM PC/AT
times) and no other hardware can make use of those on an x86
architecture.

And this means that even on a Mac there should be no hardware present on
these addresses if there is no i8042 and Apple is claiming x86
compatibility.

Thus I believe that the right fix here is to figure out why the accesses
to the ports 0x60/0x64 take a long time or forever on a Mac. Is it just
that the kernel is timing out waiting for the i8042? Or is it something
more sinister?

-- 
Vojtech Pavlik
Director SuSE Labs
