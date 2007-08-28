Return-Path: <linux-kernel-owner+w=401wt.eu-S1755412AbXH1R6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbXH1R6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 13:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751129AbXH1R6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 13:58:39 -0400
Received: from ozlabs.org ([203.10.76.45]:48145 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbXH1R6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 13:58:39 -0400
Subject: Re: [PATCH] fix maxcpus=N parsing
From: Rusty Russell <rusty@rustcorp.com.au>
To: Hugh Dickins <hugh@veritas.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <len.brown@intel.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0708271554570.21853@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0708271554570.21853@blonde.wat.veritas.com>
Content-Type: text/plain
Date: Wed, 29 Aug 2007 03:58:16 +1000
Message-Id: <1188323896.5531.63.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-27 at 16:02 +0100, Hugh Dickins wrote:
> Fix 61ec7567db103d537329b0db9a887db570431ff4: maxcpus=N is now having no
> effect on x86_64, and freezing bootup on i386 (because of inconsistency
> with the separate maxcpus parsing down in arch/i386, I guess).  That's
> because early_param parsing is a little different from __setup parsing,
> and needs the "=" omitted: then it seems to work as the original commit
> intended (no mention of IO-APIC in /proc/interrupts when maxcpus=0).
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> ---
> Sorry, I noticed this back in -mm, but got diverted by deeper mysteries.
> Cc'ed Rusty: I presume there's a good reason why early_param parsing is
> confusingly different, but he may know better and want to change it.

Yeah, early_param is modelled on module_param which does more than the
naive substring match of __setup.  There's a warning in the header IIRC.

The original intention wass that everything would move to
module_param-style parameters.  However __setup is still useful for
trivial core stuff.

> It's odd that i386 treats maxcpus=N differently from other architectures:
> on i386 it limits cpu_possible_map, on others it just limits what boots
> (then powersaved is liable to bring up the others on x86_64 - hmmm).

Indeed, it'd be nice to see this made uniform.

But this patch is fine.

Cheers,
Rusty.

