Return-Path: <linux-kernel-owner+w=401wt.eu-S1756614AbZAUOCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614AbZAUOCF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 09:02:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753443AbZAUOBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 09:01:53 -0500
Received: from smtp.ultrahosting.com ([74.213.174.254]:49693 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbZAUOBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 09:01:52 -0500
X-Greylist: delayed 494 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Jan 2009 09:01:52 EST
Date: Wed, 21 Jan 2009 08:50:25 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Richard Henderson <rth@twiddle.net>
cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       andi@firstfloor.org, ak@linux.intel.com, sfr@canb.auug.org.au,
       travis@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/8] compiler-gcc.h: add more comments to RELOC_HIDE
In-Reply-To: <4974AAA9.2000406@twiddle.net>
Message-ID: <alpine.DEB.1.10.0901210848080.7422@qirst.com>
References: <200901100040.n0A0eruc013680@imap1.linux-foundation.org> <20090110122945.GA28033@elte.hu> <Pine.LNX.4.64.0901121128470.30369@quilx.com> <200901151227.27935.rusty@rustcorp.com.au> <Pine.LNX.4.64.0901151428020.28153@quilx.com> <496FC375.90408@twiddle.net>
 <Pine.LNX.4.64.0901161433410.27177@quilx.com> <4974AAA9.2000406@twiddle.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jan 2009, Richard Henderson wrote:

> > We are talking about
> >
> > (long)&foo + long_variable
> >
> > Are you saying that the compiler will be ignoring the high bits in
> > variable because of the size of foo?
>
> No, I'm saying that all those high bits will be passed along and won't
> fit in the 16-bit relocation that'll come out of the assembler, leading
> to a hard linker error.

Why would a 16 bit relocation be generated if the compiler knows that a 32
bit/64 bit entity is added to the address of a variable?

> > It looks like its useless and more an indication of either a broken
> > compiler or wrong assumptions about the compiler. Removing RELOC_HIDE
> > should allow the compiler to freely optimize the per cpu address
> > calculations.
>
> Something I'm pretty sure we don't want the compiler to be able to do.

Other compilers (like icc) seem to have no problem with it. Why not?
