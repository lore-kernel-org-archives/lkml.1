Return-Path: <linux-kernel-owner+w=401wt.eu-S933766AbXCQJKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933766AbXCQJKU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 05:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933767AbXCQJKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 05:10:20 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:42720 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933766AbXCQJKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 05:10:19 -0400
Message-ID: <45FBB07A.2000701@vmware.com>
Date: Sat, 17 Mar 2007 01:10:18 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [patch 13/26] Xen-paravirt_ops: Consistently wrap paravirt ops
 callsites to make them patchable
References: <20070301232443.195603797@goop.org> <20070301232527.956565107@goop.org> <20070316092445.GM23174@elte.hu> <45FAD592.9010105@goop.org> <45FB283F.6080000@vmware.com> <45FB38F7.5010306@goop.org>
In-Reply-To: <45FB38F7.5010306@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> I think the suggestion is much simpler.  If you convince gcc/binutils to
> leave the .reloc section in vmlinux, and make that available to the
> kernel itself, then you can scan all the kernel's relocs to find ones
> which refer to paravirt_ops, and use those to determine which are
> callsites that can be patched.
>   

Yes, that is pretty nice.

> The main upside is that all the callsites are just normal C calls;
> there's no special syntax or strange macros, and we get the full benefit
> of typechecking, etc.
>
> But I can see a few downsides compared the current scheme:
>
>    1. Identifying the callsites is a somewhat hackish process of looking
>       at a reloc and doing a bit of dissassembly to see what is using
>       the reloc, to identify calls and jumps
>    2. There's nothing explicit to tell us how much space there is to
>       patch into; we just have to assume sizeof(indirect call/jmp)
>    3. There's no information about the register environment at the
>       callsite, so we just have to adopt normal C ABI rules.  For the
>       patch sites in hand-written asm, this could be tricky.
>    4. gcc could do strange things which prevent detection of patch
>       sites.  For example, it might CSE the value of, say,
>       paravirt_ops.irq_enable, which would be a reasonable optimisation,
>       but prevent any of the resulting indirect calls from being
>       patched.  In general it relies on gcc to generate identifiable
>       callsites, which is a bit unpredictable.
>    5. There's still a moderate amount of binutils hackery to get the
>       relocs into the right form, and there's plenty of scope for it to
>       screw up.
>   

And yes, those are nasty points.  I think I'd be interested in seeing 
more discussion on it, perhaps those issues could be worked out.

>> [ Roswell technology deleted ]
>>     

Nack.  Everyone needs Roswell technology.

Actually, that was not a serious proposal.  I think the effort and 
complexity would likely not justify the gain.  But I still had to throw 
it out, since it is what we use on Betelgeuse.

Z
