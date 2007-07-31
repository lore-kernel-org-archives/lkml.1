Return-Path: <linux-kernel-owner+w=401wt.eu-S1759505AbXGaMxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759505AbXGaMxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 08:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbXGaMxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 08:53:16 -0400
Received: from mcclure-nat.wal.novell.com ([130.57.22.22]:18685 "EHLO
	mcclure.wal.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750978AbXGaMxP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 08:53:15 -0400
Message-Id: <46AEF8760200005A00028671@mcclure.wal.novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 31 Jul 2007 08:53:10 -0400
From: "Gregory Haskins" <ghaskins@novell.com>
To: <linux.kernel@free.fr>
Cc: <macro@linux-mips.org>, <linux-kernel@vger.kernel.org>,
       <linux-rt-users@vger.kernel.org>
Subject: Re: BIOS implementors disabling the LAPIC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-31 at 14:32 +0200, John Sigler wrote:

> The motherboard manufacturer (well, their level 1 support, anyway) told 
> me I could "safely enable the LAPIC". If it is safe to enable the LAPIC, 
> then why are they disabling it in the BIOS?

I would guess that because they don't have an IOAPIC, they figured they
don't need the APIC and didn't bother to write support for it.  In
reality, other features of the APIC are useful other than IOAPIC routing
(e.g. LVTT) so as you have discovered, you end up with reduced
functionality for probably no good reason. 




> Is this a "either works or doesn't" situation where hell should break 
> loose if I try to enable the LAPIC and it's not supported by the 
> motherboard, or is this a "you will silently lose data at the worst 
> possible time" situation?

You will most likely be fine.


> 
> >> (And what does it mean to "disable" the LAPIC?)
> > 
> > The LINT0 and LINT1 inputs of the APIC are routed straight to the INT and
> > NMI inputs of the CPU respectively and the rest of the APIC logic becomes
> > inactive (tri-stated, etc.).
> 
> If that were the case, then I could not enable the LAPIC and have NMIs 
> work, right?

No, again you should be fine.  All this means is that LINT0/1 go to
defaults of "EXTINT" and "NMI" when the APIC is disabled.  When they are
enabled, the programming of the LVT for LINT0/1 defines what they are.
When you enable it, linux will start programming the LVT and should
continue to use NMI in whatever way it sees fit.

The one way you will get screwed is if there is some routing information
that *should* be in the ACPI tables that is missing due to the lack of
support.  I don't think you will have an issue, but I figured it should
mention its not guaranteed you wont either.  So don't sue me... ;)

Regards,
-Greg

