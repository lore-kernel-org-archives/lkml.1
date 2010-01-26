Return-Path: <linux-kernel-owner+w=401wt.eu-S1754842Ab0AZSf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab0AZSf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 13:35:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731Ab0AZSf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 13:35:26 -0500
Received: from outbound-mail-111.bluehost.com ([69.89.18.7]:56715 "HELO
	outbound-mail-111.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754577Ab0AZSfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 13:35:25 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=NPOFfoNpVXI/8BWaHNKep3CPrExJKw4thmiRzv6esMmmJOBRBH4r93kF/PSf0o+DTtzJsVBIySioSOxaFJeI6J0WmgXFmrqgf4zzHhk8H78btrc5dezQzRjB2J8HCgdk;
Date: Tue, 26 Jan 2010 10:35:11 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jeff Garrett <jeff@jgarrett.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Myron Stowe <myron.stowe@hp.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #15124] PCI host bridge windows ignored (works with
 pci=use_crs)
Message-ID: <20100126103511.16781111@jbarnes-piketon>
In-Reply-To: <4B5F32A9.7090105@kernel.org>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera>
	<20100126071912.GA7543@jgarrett.org>
	<201001261348.59508.rjw@sisk.pl>
	<201001261032.37053.bjorn.helgaas@hp.com>
	<alpine.LFD.2.00.1001260955060.3574@localhost.localdomain>
	<4B5F32A9.7090105@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jan 2010 10:21:29 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> On 01/26/2010 10:16 AM, Linus Torvalds wrote:
> > 
> > 
> > On Tue, 26 Jan 2010, Bjorn Helgaas wrote:
> >>
> >> which IS big enough, and we know the bridge is in fact forwarding the
> >> [mem 0xd0000000-0xdfffffff 64bit pref] region, because the Radeon works
> >> when Jeff boots with "pci=use_crs".
> > 
> > I bet it's a subtractive decode thing. Sure, it could be just another 
> > undocumented range register (does anybody have the datasheet for that 
> > thing?) but Intel tends to often have subtractive decode.
> > 
> > That system in question has three PCI express root ports, but two of them 
> > have IO and memory disabled according to the lspci info. So maybe it's as 
> > simple as that "I/O Hub PCI Express Root Port 7" just catching anything 
> > that nobody else does, and the single IOH host chip doing the same?
> > 
> >> I think we should remove intel_bus.c before .33.  It's breaking boxes
> >> and we don't know how to fix it.  Even if we do find out how to fix it,
> >> I think we should move toward using _CRS instead, because that's what
> >> Windows uses and it's an easy way for the firmware to tell us about
> >> platform quirks.
> > 
> > I suspect that for 33 it is indeed best to just revert. But somebody is 
> > bound to have information on how the actual hardware works. Yinghai?
> 
> I have asked intel if there is any bit that could be enabled the routing.
> there is no info about for their documentations.

I could probably dig something up in our confidential database, but this
is the main problem with intel_bus.c.  It'll always be behind with _CRS
provides.  Sure _CRS may be wrong sometimes, but it'll always work well
enough to bring Windows up, so we ought not to ignore it.

The underlying problems with our _CRS support still aren't fixed
though, so switching that on for 2.6.33 isn't an option.

-- 
Jesse Barnes, Intel Open Source Technology Center
