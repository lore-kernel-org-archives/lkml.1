Return-Path: <linux-kernel-owner+w=401wt.eu-S1755554AbZETQkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbZETQkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 12:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408AbZETQj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 12:39:56 -0400
Received: from claw.goop.org ([74.207.240.146]:56231 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbZETQj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 12:39:56 -0400
Message-ID: <4A143251.90208@goop.org>
Date: Wed, 20 May 2009 09:39:45 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] xen /proc/mtrr implementation
References: <1242170864-13560-1-git-send-email-jeremy@goop.org>	<20090513133021.GA7277@elte.hu> <4A0ADBA2.2020300@goop.org>	<20090515182757.GA19256@elte.hu> <4A0DCC11.10307@goop.org>	<m1my9ex818.fsf@fess.ebiederm.org> <4A0DFF78.6000501@goop.org>	<20090515202250.0f1218ef@jbarnes-g45>	<m1iqk1k708.fsf@fess.ebiederm.org> <4A10EAC4.9070701@goop.org>	<20090518085902.GE10687@elte.hu> <4A11A3F8.1010202@goop.org> <87tz3gnq91.fsf@basil.nowhere.org>
In-Reply-To: <87tz3gnq91.fsf@basil.nowhere.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Jeremy Fitzhardinge <jeremy@goop.org> writes:
>
>   
>> arch/x86 already defines an mtrr_ops, which defines how to manipulate
>> the MTRR registers.  There are currently several implementations of
>> that interface.  In Xen the MTRR registers belong to the hypervisor,
>> but it allows a privileged kernel to modify them via hypercalls. 
>>     
>
> One part that's unclear to me in this discussion. Could you perhaps
> clarify Jeremy?:
>
> Even Dom0 is not continuous in physical memory, but mapped page by page
> except for swiotlb mappings. But MTRRs are fundamentally a way 
> to change attributes for large physically continous mappings. How do these
> two meet?
>
> After all when you change a MTRR for a given range of memory
> linux sees as continuous it isn't necessarily in Xen.
>
> Is this new interface only defined for swiotlb or MMIO mappings?
> If yes did you check the drivers only actually set it on
> swiotlb or MMIO (that seems dubious to me)?

Really?   Do we ever set unusual memory types on normal system memory?  
 From what I've seen, MTRRs are only ever applied to device mapped 
memory (framebuffers, etc).  I guess it could possibly make sense on 
system memory which is being prepped for DMA (swiotlb, alloc_coherent, 
etc), but dom0 would have a pseudo-phys to machine mapping for that 
memory too (it would be obviously problematic if something tried to 
program MTRR with pseudo-physical addresses, but Xen would/should 
probably disallow it anyway).

    J
