Return-Path: <linux-kernel-owner+w=401wt.eu-S1754162AbZASQaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbZASQaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 11:30:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbZASQah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 11:30:37 -0500
Received: from are.twiddle.net ([75.149.56.221]:53156 "EHLO are.twiddle.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbZASQaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 11:30:35 -0500
Message-ID: <4974AAA9.2000406@twiddle.net>
Date: Mon, 19 Jan 2009 08:30:33 -0800
From: Richard Henderson <rth@twiddle.net>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       andi@firstfloor.org, ak@linux.intel.com, sfr@canb.auug.org.au,
       travis@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/8] compiler-gcc.h: add more comments to RELOC_HIDE
References: <200901100040.n0A0eruc013680@imap1.linux-foundation.org> <20090110122945.GA28033@elte.hu> <Pine.LNX.4.64.0901121128470.30369@quilx.com> <200901151227.27935.rusty@rustcorp.com.au> <Pine.LNX.4.64.0901151428020.28153@quilx.com> <496FC375.90408@twiddle.net> <Pine.LNX.4.64.0901161433410.27177@quilx.com>
In-Reply-To: <Pine.LNX.4.64.0901161433410.27177@quilx.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Thu, 15 Jan 2009, Richard Henderson wrote:
> 
>> I didn't explore the space of possible solutions, merely gave Rusty a solution
>> that I knew would work, and would never fail because the compiler would never
>> look through the asm.
>>
>> I wouldn't be surprised if the compiler thought "(long)&foo - large_constant"
>> could be put back together into a small-data relocation, simply because at the
>> level at which that optimization is performed, we've thrown away type data
>> like long and void*; we only have modes.
> 
> We are talking about
> 
> (long)&foo + long_variable
> 
> Are you saying that the compiler will be ignoring the high bits in
> variable because of the size of foo?

No, I'm saying that all those high bits will be passed along and won't
fit in the 16-bit relocation that'll come out of the assembler, leading
to a hard linker error.

> It looks like its useless and more an indication of either a broken
> compiler or wrong assumptions about the compiler. Removing RELOC_HIDE
> should allow the compiler to freely optimize the per cpu address
> calculations.

Something I'm pretty sure we don't want the compiler to be able to do.


r~
