Return-Path: <linux-kernel-owner+w=401wt.eu-S1765915AbXGWRqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765915AbXGWRqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 13:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759594AbXGWRql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 13:46:41 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33601 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764787AbXGWRqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 13:46:40 -0400
Date: Mon, 23 Jul 2007 10:46:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/8] i386: bitops: Rectify bogus "+m" constraints
In-Reply-To: <20070723160543.22137.9416.sendpatchset@cselinux1.cse.iitk.ac.in>
Message-ID: <alpine.LFD.0.999.0707231043540.3607@woody.linux-foundation.org>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
 <20070723160543.22137.9416.sendpatchset@cselinux1.cse.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 23 Jul 2007, Satyam Sharma wrote:
> 
> [3/8] i386: bitops: Rectify bogus "+m" constraints
> 
> From the gcc manual:
> 
>   Extended asm supports input-output or read-write operands. Use the
>   constraint character `+' to indicate such an operand and list it with
>   the output operands. You should only use read-write operands when the
>   constraints for the operand (or the operand in which only some of the
>   bits are to be changed) allow a register.
> 
> So, using the "+" constraint modifier for memory, like "+m" is bogus.
> We must simply specify "=m" which handles the case correctly.

No. This is wrong.

"=m" means that the new value of the memory location is *set*.

Which means that gcc will potentially optimize away any previous stores to 
that memory location.

And yes, it happens, and yes, we've seen it.

The gcc docs are secondary. They're not updated, they aren't correct, they 
don't reflect reality, and they don't matter. The only correct thing to 
use is "+m" for things like this, or alternatively to just use the 
"memory" specifier at the end and make gcc generate really crappy code.

			Linus
