Return-Path: <linux-kernel-owner+w=401wt.eu-S1755190AbZFWUB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbZFWUB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 16:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757089AbZFWUBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 16:01:22 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:61353 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757022AbZFWUBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 16:01:19 -0400
Date: Tue, 23 Jun 2009 16:00:55 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 2.6.32] Simple Firmware Interface (SFI): initial support
In-reply-to: <20090623185120.GA13824@srcf.ucam.org>
Message-id: <alpine.LFD.2.00.0906231541400.23079@localhost.localdomain>
References: <1245741246-6503-1-git-send-email-lenb@kernel.org>
 <20090623183153.GB12814@srcf.ucam.org>
 <alpine.LFD.2.00.0906231438190.23079@localhost.localdomain>
 <20090623185120.GA13824@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009, Matthew Garrett wrote:

> On Tue, Jun 23, 2009 at 02:41:28PM -0400, Len Brown wrote:
> > On Tue, 23 Jun 2009, Matthew Garrett wrote:
> > 
> > > There seems to be a huge amount of overlap between SFI and ACPI.
> > > Couldn't this have simply taken the form of some additional ACPI tables 
> > > and a decoupling of ACPI enumeration from runtime AML interpretation? 
> > > How final is this spec?
> > 
> > > I realise that we're pretty much constrained to implementing this if 
> > > hardware actually ships with it, but it seems to be an additional 
> > > firmware interface with no real benefit - as far as I can tell it's not 
> > > possible for a platform to meaningfully implement both ACPI and SFI 
> > > without duplicating information?
> > 
> > Please let me know if your questions are not thoroughly answered here:
> > http://simplefirmware.org/faq
> 
> Yeah, I read that and it didn't really seem to clear things up. There's 
> no especially meaningful reason for a specialised platform to include 
> any AML code - the closest equivalent case I'm thinking of is "acpi=ht" 
> where we parse some static ACPI tables but don't do any runtime 
> interpretation. In this universe, SFI would simply have been some 
> specced additional tables and a build option to include table parsing 
> but not the interpreter.
> 
> I appreciate that if this is what's going to be on the hardware then 
> we're stuck with it, but I'm hugely unconvinced that this couldn't have 
> taken the form of "embedded ACPI" rather than an entire new firmware 
> interface.

Fundamentally, Moorestown is an x86 processor
married to a cell-phone chipset.

It does not have x86 legacy PC compatibility,
and it does not have any ACPI registers.
It does not support SMM, and thus can't emulate the above.

One can argue the merits of the architecture..
The software person will always argue for compatibility (and be right)
and the hardware product person will have their own reasons (and be 
right).

But given that the hardware is fixed (it was fixed over a year ago),
the question becomes what does ACPI mean on such a platform?
It turns out that if you look at the ACPI spec and delete all the
things that could not possibly apply to MRST, then you are left
with very little.

Yes, the ACPI OS code could have been sliced up for the benefit
of MRST.  But doing so would have had an extremely small benefit
to MRST, and would have inflicted serious damage to CONFIG_ACPI
on the rest of the industry.  So I decided it was a better idea
to make a clean break for the benefit of both platforms.

Note that while it makes sense for a single kernel to support
both ACPI and SFI to be able to run on both platforms, it does
not make any sense for a platform to export both.  If that were
to occur (say in a prototype), the platform's SFI suport would
simply be ignored by the OS.

thanks,
-Len Brown, Intel Open Source Technolgy Center


