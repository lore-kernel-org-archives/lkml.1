Return-Path: <linux-kernel-owner+w=401wt.eu-S1763424AbYDNRuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763424AbYDNRuX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 13:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755602AbYDNRuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 13:50:04 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:48150 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbYDNRuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 13:50:03 -0400
Date: Mon, 14 Apr 2008 11:50:02 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Roland Dreier <rdreier@cisco.com>,
       Ingo Molnar <mingo@elte.hu>, Ingo Oeser <ioe-lkml@rameria.de>,
       Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] Replace completions with semaphores
Message-ID: <20080414175001.GZ11962@parisc-linux.org>
References: <1208003081.7427.7.camel@twins> <20080412172606.GL11962@parisc-linux.org> <adaskxqrgsl.fsf@cisco.com> <20080412204748.GN11962@parisc-linux.org> <20080413070833.GC19773@elte.hu> <20080413125758.GQ11962@parisc-linux.org> <20080414153928.GA22259@elte.hu> <adafxtoqvgh.fsf@cisco.com> <1208190749.7375.10.camel@twins> <20080414095638.64943a98@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414095638.64943a98@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 09:56:38AM -0700, Arjan van de Ven wrote:
> On Mon, 14 Apr 2008 18:32:28 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> > Yeah, I would open code it.  But this is indeed a sane usage of the
> > counting semaphore because there is no priority inversion.
> 
> Maybe we need a "counter" primitive instead?
> From a conceptual point of view that even makes sense
> 
> (the implementation can be pretty much the current semaphore one of course)

I'm only too happy to rename semaphore.c to atomic_counter.c and do
appropriate renames.  Or maybe 'kcounter' would be more in vogue for a
name ;-)  I'd like a name that implies sleeping, but I'm not able to
think of one right now.

Then semaphores and completions each become wrappers around counters
and everybody's happy.  Right?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
