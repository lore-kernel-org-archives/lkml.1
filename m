Return-Path: <linux-kernel-owner+w=401wt.eu-S1757584AbZAODer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584AbZAODer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 22:34:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbZAODei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 22:34:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52529 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753571AbZAODeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 22:34:37 -0500
Date: Wed, 14 Jan 2009 19:33:32 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Christoph Lameter <cl@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, andi@firstfloor.org, ak@linux.intel.com,
       rth@twiddle.net, sfr@canb.auug.org.au, travis@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/8] compiler-gcc.h: add more comments to RELOC_HIDE
In-Reply-To: <200901151227.27935.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.2.00.0901141932290.6528@localhost.localdomain>
References: <200901100040.n0A0eruc013680@imap1.linux-foundation.org> <20090110122945.GA28033@elte.hu> <Pine.LNX.4.64.0901121128470.30369@quilx.com> <200901151227.27935.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 Jan 2009, Rusty Russell wrote:

> On Tuesday 13 January 2009 04:03:49 Christoph Lameter wrote:
> > But that is not what is occurring. We do not do &var + LARGE_OFFSET.
> > Instead one does
> > 
> > 	((void *)&var) + LARGE_OFFSET
> > 
> > or
> > 	((unsigned long)&var) + LARGE_OFFSET
> > 
> > The cast should cause the C compiler to drop all assumptions about size.
> 
> No, and that's the point.  Sorry, at this point you need to talk to a gcc expert.  As I have said, I did and I believe what he told me.

Yeah, I personally believe in the "should cause the C compiler" part, but 
gcc doesn't work that way. It will remember where the value came from, 
even when the pointer has been cast to something else.

			Linus
