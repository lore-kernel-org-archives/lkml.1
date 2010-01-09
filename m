Return-Path: <linux-kernel-owner+w=401wt.eu-S1754079Ab0AIDfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab0AIDfZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 22:35:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366Ab0AIDfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 22:35:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41347 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab0AIDfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 22:35:23 -0500
Message-ID: <4B47F6C4.9000608@zytor.com>
Date: Fri, 08 Jan 2010 19:23:48 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>,
       Yinghai Lu <yinghai@kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86, apic: use 0x20 for the IRQ_MOVE_CLEANUP_VECTOR instead
 of 0x1f
References: <1263002989.2879.664.camel@sbs-t61.sc.intel.com>
In-Reply-To: <1263002989.2879.664.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2010 06:09 PM, Suresh Siddha wrote:
> From: Suresh Siddha <suresh.b.siddha@intel.com>
> Subject: x86, apic: use 0x20 for the IRQ_MOVE_CLEANUP_VECTOR instead of 0x1f
> 
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
> 

I guess another thing is whether or not we can allocate 0x20 as a normal
vector if we don't need IRQ_MOVE_CLEANUP_VECTORS, and rely on the
used_vectors for that one as well.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

