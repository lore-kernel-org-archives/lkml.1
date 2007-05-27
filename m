Return-Path: <linux-kernel-owner+w=401wt.eu-S1760784AbXE0Vvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760784AbXE0Vvl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 17:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757446AbXE0Vvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 17:51:31 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:33414 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756506AbXE0Vva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 17:51:30 -0400
Date: Sun, 27 May 2007 22:51:23 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Message-ID: <20070527215123.GA22687@srcf.ucam.org>
References: <20070521132711.GA7540@srcf.ucam.org> <20070521132948.GD8332@elf.ucw.cz> <20070521133608.GB7540@srcf.ucam.org> <20070521134046.GE8332@elf.ucw.cz> <20070521134553.GA7911@srcf.ucam.org> <20070521224200.GF10714@elf.ucw.cz> <20070522003153.GA18162@srcf.ucam.org> <1180016213.16396.74.camel@queen.suse.de> <20070524143644.GA27364@srcf.ucam.org> <20070525063815.GA3989@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525063815.GA3989@ucw.cz>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: 2.6.22-rc1-mm1 Implementing fan/thermal control in userspace - Was: [cannot change thermal trip points]
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2007 at 06:38:15AM +0000, Pavel Machek wrote:
> Hi!
> > Because, as Len has pointed out, you end up with two different ideas 
> > about what the trip points are - the kernel's and the hardware's. That 
> > works fine until some event in the firmware either forcibly 
> > resynchronises the two or makes assumptions about the spec-compliance of 
> > the interpreter.
> 
> ...and suggested workaround is to drive fans directly from userspace,
> which not only violates the specs and has all the problems with
> desynchronized state, but ALSO FAILS TO WORK IN PRACTICE.

I don't think that's obviously true. 11.3.2 of the 3.0 spec states:

"A package consisting of references to all active cooling devices that 
should be engaged when the associated active cooling threshold (_ACx) is 
exceeded." 

(referring to _ALx objects).

> > The interface would need to be more complicated than that if you wanted 
> > to be able to implement hysteresis, and there's the potential for 
> > hardware damage if paramaters are set inappropriately. Even then, 
> > there's no easy way of programatically determining whether it would work 
> > on any given hardware.
> 
> Not sure why you try to scare people with 'hardware damage'. HP XE3
> bios already _was_ damaging hardware (it cooked the hard drive using
> cpu as a heater), and no acpi magic can damage correctly working
> machine.

Given that this presumably didn't occur under Windows, I think it would 
be significantly better to figure out why and then fix that. 
Alternatively, if the firmware tables are actually genuinely broken in a 
way that's impossible to repair, you can replace the table. That has the 
advantage that there's no risk of the platform and the OS becoming 
confused.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
