Return-Path: <linux-kernel-owner+w=401wt.eu-S1751389AbXEXOhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389AbXEXOhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 10:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750801AbXEXOg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 10:36:57 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:48459 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbXEXOg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 10:36:56 -0400
Date: Thu, 24 May 2007 15:36:45 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Thomas Renninger <trenn@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Message-ID: <20070524143644.GA27364@srcf.ucam.org>
References: <200705202350.45145.lenb@kernel.org> <20070521121048.GA8332@elf.ucw.cz> <20070521132711.GA7540@srcf.ucam.org> <20070521132948.GD8332@elf.ucw.cz> <20070521133608.GB7540@srcf.ucam.org> <20070521134046.GE8332@elf.ucw.cz> <20070521134553.GA7911@srcf.ucam.org> <20070521224200.GF10714@elf.ucw.cz> <20070522003153.GA18162@srcf.ucam.org> <1180016213.16396.74.camel@queen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1180016213.16396.74.camel@queen.suse.de>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: 2.6.22-rc1-mm1 Implementing fan/thermal control in userspace - Was: [cannot change thermal trip points]
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 04:16:53PM +0200, Thomas Renninger wrote:

> I doubt it is impossible, would you mind sharing your knowledge why you
> think it is impossible or point to some related discussion, pls.

Because, as Len has pointed out, you end up with two different ideas 
about what the trip points are - the kernel's and the hardware's. That 
works fine until some event in the firmware either forcibly 
resynchronises the two or makes assumptions about the spec-compliance of 
the interpreter.

> Yes, trip points are overridden by BIOS on HPs and what is the problem?
> The workaround won't work for them, but it still does on others
> (mainly on ThinkPads which have passive tp at about 89 C and critical on
> 91 C).

You don't know whether the workaround will work or not until you've 
performed a full audit of the platform firmware, which is going to 
potentially change between BIOS versions. It's entirely legal for the 
firmware to behave in this way, and even beneficial under various 
circumstances.

> I could imagine an implementation for this, that e.g. critical...active9
> get module parameters. BIOS updates for trip points get ignored as soon
> as one is set and you can only decrease a value. Nothing bad can happen
> and it will make some people happy (yes it's hacky, violates the specs
> and so on..., but some more people have a working machine). Will this
> (or similar) get accepted?

The interface would need to be more complicated than that if you wanted 
to be able to implement hysteresis, and there's the potential for 
hardware damage if paramaters are set inappropriately. Even then, 
there's no easy way of programatically determining whether it would work 
on any given hardware.

> It's even more impossible to get ACPI working correctly for all machines
> and all subsystems, these little workarounds can help some people to at
> least use their machine or get some parts working better.

It's fairly clearly not impossible, given that there exists at least one 
OS that these machines work with.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
