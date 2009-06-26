Return-Path: <linux-kernel-owner+w=401wt.eu-S1754911AbZFZKOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbZFZKOy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 06:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbZFZKOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 06:14:45 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48071 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751074AbZFZKOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 06:14:44 -0400
Date: Fri, 26 Jun 2009 11:16:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 3/9] x86/moorestown: add moorestown platform flags
Message-ID: <20090626111603.758ec7fb@lxorguk.ukuu.org.uk>
In-Reply-To: <20090626093859.GA12571@elte.hu>
References: <43F901BD926A4E43B106BF17856F07556412B7E2@orsmsx508.amr.corp.intel.com>
	<20090626071955.GG14078@elte.hu>
	<20090626101310.4110a290@lxorguk.ukuu.org.uk>
	<20090626093859.GA12571@elte.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It's an entirely legitimate question, given that many other current 
> modern subarchitectures detect themselves based on PCI config space 
> early accesses or (sometimes) BIOS data structures - and that both 
> of those methods are better than using boot flags.

The flags are passed by the boot loader which is the one thing that knows
what the platform is only deeply embedded hardware. See the ARM and PPC
ports.

> > - Embedded x86 like devices are going to regularly occur without 
> > any PCI
> 
> This proposed Intel subarchitecture comes with PCI support, 
> obviously.

And this is relevant to the fact there will be systems without PCI how ?

> > - You need to know the platform in order to know how to access any
> >   PCI bus that may or may not hypothetically exist.
> 
> Uhm, not really.

Uhm yes really

> Have a look at arch/x86/kernel/early-quirks.c. All you generally 
> need to know is a PCI ID that sits on the root bus.

How will you probe the root bus without knowing what the PCI
configuration mechanism is for your platform

> Early PCI ID checks are typical and robust way to identify 'weird' 
> subarchitectures. Sometimes we do it via BIOS data structures. Only 
> as a last option do we want to use boot loader mechanisms - it's the 
> most inflexible one really.

SFI doesn't indicate MRST
> 
> Furtherore, Moorestown comes with SFI and there sure can be a BIOS 
> table that describes the platform properly. We can read such tables 
> very early during bootup, well before platform devices are set up.

But they don't tell you what the platform is. Again see every platform we
currently support which has deeply embedded forms. There is a reason they
went that way and it includes fifteen years of finding out which ways
don't work for all cases. For example if you don't have standard PC like
firmware and you go looking for SFI or ACPI will your box stay up ?

It's also kind of irrelevant to the flags anyway - you need the boot
flags whether the platform comes from the bootloader or divine
intervention somewhere early in probing.

There is a more general question which is whether the flags are better
than the PPC style approach of having a machine vector and putting them
in that so you just do

	platform_ops = platform_ops_table[our_platform]

and use
	platform_ops->

for the various methods such as EBDA and which timer methods to use



