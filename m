Return-Path: <linux-kernel-owner+w=401wt.eu-S1763014AbZAOXPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763014AbZAOXPc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 18:15:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759114AbZAOXPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 18:15:05 -0500
Received: from are.twiddle.net ([75.149.56.221]:39103 "EHLO are.twiddle.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754698AbZAOXPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 18:15:03 -0500
Message-ID: <496FC375.90408@twiddle.net>
Date: Thu, 15 Jan 2009 15:15:01 -0800
From: Richard Henderson <rth@twiddle.net>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       andi@firstfloor.org, ak@linux.intel.com, sfr@canb.auug.org.au,
       travis@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/8] compiler-gcc.h: add more comments to RELOC_HIDE
References: <200901100040.n0A0eruc013680@imap1.linux-foundation.org> <20090110122945.GA28033@elte.hu> <Pine.LNX.4.64.0901121128470.30369@quilx.com> <200901151227.27935.rusty@rustcorp.com.au> <Pine.LNX.4.64.0901151428020.28153@quilx.com>
In-Reply-To: <Pine.LNX.4.64.0901151428020.28153@quilx.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Thu, 15 Jan 2009, Rusty Russell wrote:
> 
>>> The cast should cause the C compiler to drop all assumptions about size.
>> No, and that's the point.  Sorry, at this point you need to talk to a gcc expert.  As I have said, I did and I believe what he told me.
> 
> The gcc expert that created this measss is cced on this thread and so
> far he not spoken up. Richard?

It has been a long time, and I don't recall all of the assumptions 
involved from the time.

It was probably a combination of object size assumptions, as well as 
problems with relocations.  Stuff like "int foo" is known to be 
allocated within the small data structure, and thus various types of 
small-data-section relocations are valid for it.  Then we do stuff like 
"(void *)&foo - large_constant" which don't work with those sorts of 
relocations.

I didn't explore the space of possible solutions, merely gave Rusty a 
solution that I knew would work, and would never fail because the 
compiler would never look through the asm.

I wouldn't be surprised if the compiler thought "(long)&foo - 
large_constant" could be put back together into a small-data relocation, 
simply because at the level at which that optimization is performed, 
we've thrown away type data like long and void*; we only have modes.

Why are you wanting to change this at all?  It works as it is.


r~
