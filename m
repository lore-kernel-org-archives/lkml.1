Return-Path: <linux-kernel-owner+w=401wt.eu-S965103AbXCFQWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965103AbXCFQWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 11:22:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965036AbXCFQWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 11:22:54 -0500
Received: from aa014msr.fastwebnet.it ([85.18.95.74]:39132 "EHLO
	aa014msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965103AbXCFQWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 11:22:53 -0500
Date: Tue, 6 Mar 2007 17:20:22 +0100
From: Mattia Dongili <malattia@linux.it>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [GIT PATCH] ACPI patches for 2.6.21 - part II (resend)
Message-ID: <20070306162021.GJ2919@inferi.kami.home>
Mail-Followup-To: Matthew Garrett <mjg59@srcf.ucam.org>,
	Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <200702162223.59837.lenb@kernel.org> <20020101045751.GD4106@ucw.cz> <20070306122213.GF2919@inferi.kami.home> <20070306131753.GA15187@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070306131753.GA15187@srcf.ucam.org>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.21-rc2-mm1-1 i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2007 at 01:17:53PM +0000, Matthew Garrett wrote:
> On Tue, Mar 06, 2007 at 01:22:13PM +0100, Mattia Dongili wrote:
> 
> > the audiopower is basically a _PS3/_PS0 switch for the device, while the
> > lanpower plays with the embedded controller to powerdown/powerup.
> >
> > Now, unfortunately those methods are attached to a fake device in the
> > DSDT and afaict there's no way to tell which real device they are
> > playing with (except by inspecting the method implementations).
> > Well of course iff there's only _one_ sound card and _one_ nic you can
> > easily guess it :)
> > 
> > Is there some way to hook into drivers for such kind of runtime power
> > management?
> 
> Before worrying, I think it would make more sense to instrument the 
> benefit gained against doing more "traditional" runtime management - 
> that is, simply shutting down the ethernet chipset or doing ac97 power 
> management. It's trivial to add those to the existing drivers, and if 

Can't tell about chipset specific management, but as far as ACPI is
concerned, this Sony specific stuff is a nice way of hiding features
behind an undocumented device. Eg: the sound card _PS3 is empty and only
available through that AZPW method.[1] So I guess that the
platform_pci_set_power_state for ACPI D3 is basically a no-op there.

> the additional benefit of using the Sony-specific methods is small then 
> it's probably not really worth working out how to add it in.

Yep, will try to get some measurement (by means of the acpi battery
status, no better way currently available here) but given the above I
suspect there's some benefit.

> Plus, implementing the generic support benefits more people :)

Yes, of course.

[1]: if you want to make a an idea, one such DSDT is available
here: http://oioio.altervista.org/linux/DSDT.sz72b.dsl
sony-laptop basically exposes the Device(SNC) and AZPW/GAZP for the
audio (an hda) and LNPW/GLNP for the nic (a sky2). Now see the
audio device Device(HDEF) and its _PS0 and _PS3.

PS: did I disappear from the Cc list? ;)
-- 
mattia
:wq!
