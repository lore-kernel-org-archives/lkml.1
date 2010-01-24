Return-Path: <linux-kernel-owner+w=401wt.eu-S1752077Ab0AXFwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab0AXFwJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 00:52:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526Ab0AXFwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 00:52:07 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:46792 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931Ab0AXFwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 00:52:05 -0500
Date: Sun, 24 Jan 2010 05:52:01 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
cc: hpa@zytor.com, ebiederm@xmission.com, yinghai@kernel.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] x86, irq: use 0x20 for the IRQ_MOVE_CLEANUP_VECTOR
 instead of 0x1f
In-Reply-To: <20100114002118.521826763@sbs-t61.sc.intel.com>
Message-ID: <alpine.LFD.2.00.1001240545180.13034@eddie.linux-mips.org>
References: <20100114002118.436172066@sbs-t61.sc.intel.com> <20100114002118.521826763@sbs-t61.sc.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jan 2010, Suresh Siddha wrote:

> After talking to some more folks inside intel (Peter Anvin, Asit Mallick),
> the safest option (for future compatibility etc) seen was to use vector 0x20
> for IRQ_MOVE_CLEANUP_VECTOR instead of using vector 0x1f (which is documented as
> reserved vector in the Intel IA32 manuals).
> 
> Also we don't need to reserve the entire privilege level (all 16 vectors in
> the priority bucket that IRQ_MOVE_CLEANUP_VECTOR falls into), as the
> x86 architecture (section 10.9.3 in SDM Vol3a) specifies that with in the
> priority level, the higher the vector number the higher the priority.
> And hence we don't need to reserve the complete priority level 0x20-0x2f for
> the IRQ migration cleanup logic.
> 
> So change the IRQ_MOVE_CLEANUP_VECTOR to 0x20 and  allow 0x21-0x2f to be used
> for device interrupts. 0x30-0x3f will be used for ISA interrupts (these
> also can be migrated in the context of IOAPIC and hence need to be at a higher
> priority level than IRQ_MOVE_CLEANUP_VECTOR).

 I have troubles understanding what exactly this change is needed for 
(i.e. what's the difference between using vectors 0x20-0x2f and 0x30-0x3f 
as ExtINT interrupts, what's the gain from relocating them? -- they are 
transparent to the APIC, so the exact priority level used does not matter 
at all), but since I've been cc-ed, I have one question -- have you 
verified that with the new arrangement the mixed interrupt mode (where 
some interrupts come via the APIC and some via the 8259A PICs) still 
works?

  Maciej
