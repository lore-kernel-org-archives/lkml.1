Return-Path: <linux-kernel-owner+w=401wt.eu-S1765452AbZAOTUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765452AbZAOTUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 14:20:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765518AbZAOTT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 14:19:56 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:60278 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758408AbZAOTTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 14:19:55 -0500
Date: Thu, 15 Jan 2009 13:19:13 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, andi@firstfloor.org, ak@linux.intel.com,
       rth@twiddle.net, sfr@canb.auug.org.au, travis@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/8] compiler-gcc.h: add more comments to RELOC_HIDE
In-Reply-To: <alpine.LFD.2.00.0901141932290.6528@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0901151300150.26467@quilx.com>
References: <200901100040.n0A0eruc013680@imap1.linux-foundation.org>
 <20090110122945.GA28033@elte.hu> <Pine.LNX.4.64.0901121128470.30369@quilx.com>
 <200901151227.27935.rusty@rustcorp.com.au> <alpine.LFD.2.00.0901141932290.6528@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009, Linus Torvalds wrote:

> > > The cast should cause the C compiler to drop all assumptions about size.
> >
> > No, and that's the point.  Sorry, at this point you need to talk to a gcc expert.  As I have said, I did and I believe what he told me.
>
> Yeah, I personally believe in the "should cause the C compiler" part, but
> gcc doesn't work that way. It will remember where the value came from,
> even when the pointer has been cast to something else.

If so then the compiler is crap. Casting a pointer to long needs to
get a scalar without assumptions about the size of the structure that the
pointer was going to remaining a factor.

All of this originated in some discussion in the 2.5.X days. Could we make
sure that this is indeed the case?I have never seen any ill effect from
the casts to long nor do the failure scenarios given here make too much
sense (like adding a pointer to the address of a constant string passed as
the source argument to strcpy????).

>From the include/compiler*.h files it looks as if we are supporting 3
classes of compilers. Of those only gcc has this sickness.


