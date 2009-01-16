Return-Path: <linux-kernel-owner+w=401wt.eu-S936959AbZAPUid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936959AbZAPUid (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 15:38:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167AbZAPUiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 15:38:23 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:58460 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbZAPUiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 15:38:22 -0500
Date: Fri, 16 Jan 2009 14:37:32 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Richard Henderson <rth@twiddle.net>
cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       andi@firstfloor.org, ak@linux.intel.com, sfr@canb.auug.org.au,
       travis@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/8] compiler-gcc.h: add more comments to RELOC_HIDE
In-Reply-To: <496FC375.90408@twiddle.net>
Message-ID: <Pine.LNX.4.64.0901161433410.27177@quilx.com>
References: <200901100040.n0A0eruc013680@imap1.linux-foundation.org>
 <20090110122945.GA28033@elte.hu> <Pine.LNX.4.64.0901121128470.30369@quilx.com>
 <200901151227.27935.rusty@rustcorp.com.au> <Pine.LNX.4.64.0901151428020.28153@quilx.com>
 <496FC375.90408@twiddle.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2009, Richard Henderson wrote:

> I didn't explore the space of possible solutions, merely gave Rusty a solution
> that I knew would work, and would never fail because the compiler would never
> look through the asm.
>
> I wouldn't be surprised if the compiler thought "(long)&foo - large_constant"
> could be put back together into a small-data relocation, simply because at the
> level at which that optimization is performed, we've thrown away type data
> like long and void*; we only have modes.

We are talking about

(long)&foo + long_variable

Are you saying that the compiler will be ignoring the high bits in
variable because of the size of foo?

> Why are you wanting to change this at all?  It works as it is.

It looks like its useless and more an indication of either a broken
compiler or wrong assumptions about the compiler. Removing RELOC_HIDE
should allow the compiler to freely optimize the per cpu address
calculations.
