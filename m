Return-Path: <linux-kernel-owner+w=401wt.eu-S1752324Ab0AaHUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324Ab0AaHUB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 02:20:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038Ab0AaHUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Jan 2010 02:20:01 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:39369 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab0AaHUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 02:20:00 -0500
Date: Sun, 31 Jan 2010 07:19:59 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Suresh Siddha <suresh.b.siddha@intel.com>, ebiederm@xmission.com,
       yinghai@kernel.org, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] x86, irq: use 0x20 for the IRQ_MOVE_CLEANUP_VECTOR
 instead of 0x1f
In-Reply-To: <4B5C00EB.3000208@zytor.com>
Message-ID: <alpine.LFD.2.00.1001310705280.31764@eddie.linux-mips.org>
References: <20100114002118.436172066@sbs-t61.sc.intel.com> <20100114002118.521826763@sbs-t61.sc.intel.com> <alpine.LFD.2.00.1001240545180.13034@eddie.linux-mips.org> <4B5C00EB.3000208@zytor.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jan 2010, H. Peter Anvin wrote:

> > > So change the IRQ_MOVE_CLEANUP_VECTOR to 0x20 and  allow 0x21-0x2f to be
> > > used
> > > for device interrupts. 0x30-0x3f will be used for ISA interrupts (these
> > > also can be migrated in the context of IOAPIC and hence need to be at a
> > > higher
> > > priority level than IRQ_MOVE_CLEANUP_VECTOR).
> > 
> >   I have troubles understanding what exactly this change is needed for
> > (i.e. what's the difference between using vectors 0x20-0x2f and 0x30-0x3f
> > as ExtINT interrupts, what's the gain from relocating them? -- they are
> > transparent to the APIC, so the exact priority level used does not matter
> > at all), but since I've been cc-ed, I have one question -- have you
> > verified that with the new arrangement the mixed interrupt mode (where
> > some interrupts come via the APIC and some via the 8259A PICs) still
> > works?
> > 
> 
> The difference is relevant when they are *not* invoked as ExtInt interrupts,
> but when used as IOAPIC interrupts it matters.

 Hmm, I/O APIC interrupts coming from ISA devices used not to differ from 
ones from PCI devices and their vectors were evenly distributed across the 
whole device range (one reason for this was the (in)famous Pentium APIC 
limitation WRT multiple outstanding requests at the same priority level).  
Now what you've written suggests this has changed and now ISA devices only 
get vectors within a single priority level -- am I getting this right?

 If so, then to push my original question further: how are these vectors 
allocated -- are they identity mapped with the corresponding i8259A 
vectors?  And how does it play with the Pentium APIC limitation (that may 
actually apply to all the local APIC cores that use serial bus delivery; 
I'm not sure) I mentioned above?

  Maciej
