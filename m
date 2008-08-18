Return-Path: <linux-kernel-owner+w=401wt.eu-S1754057AbYHRM7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbYHRM7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 08:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752545AbYHRM7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 08:59:13 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:41391 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbYHRM7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 08:59:12 -0400
Date: Mon, 18 Aug 2008 07:58:03 -0500
From: David Fries <david@fries.net>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] Fix i486 suspend to disk CR4 oops
Message-ID: <20080818125803.GC17528@spacedout.fries.net>
References: <20080818040340.GB17528@spacedout.fries.net> <Pine.LNX.4.55.0808180510480.26857@cliff.in.clinika.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080818064120.GA28941@elte.hu>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Mon, 18 Aug 2008 07:58:10 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 05:14:50AM +0100, Maciej W. Rozycki wrote:
> On Sun, 17 Aug 2008, David Fries wrote:
> > +	/* cr4 was introduced in the Pentium CPU */
> 
>  NACK.  Later i486 chips do have CR4 -- for PSE, VME, etc. (the set of
> features varies across the line).  Use a fixup as elsewhere or something.
> 
>   Maciej

That's what I get for reading the Intel instruction set reference,
"The CR4 register was added to the Intel Architecture beginning with
the Pentium processor."

Ingo Molnar, thanks, I'll try the read_cr4_safe() version tonight (the
computer is in the trunk of my car and I'm about ready to head to
work).

In light of the above, how about updating the comments
-       /* cr4 was introduced in the Pentium CPU */
-       jecxz   1f      # cr4 Pentium and higher, skip if zero
+       /* cr4 not in i386 only some i486, skip if zero */
+       jecxz   1f      # cr4 not in i386 only some i486, skip if zero

I'm not being bit by arch/x86/kernel/relocate_kernel_32.S, but it is
using cr4.  Should that be fixed up as well?

-- 
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)
