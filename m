Return-Path: <linux-kernel-owner+w=401wt.eu-S1754204AbXGOEuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbXGOEuq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 00:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbXGOEuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 00:50:39 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36984 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751187AbXGOEui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 00:50:38 -0400
Date: Sat, 14 Jul 2007 21:50:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: cbou@mail.ru, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pda_power: clean up irq, timer, return usage
Message-Id: <20070714215026.22ee39da.akpm@linux-foundation.org>
In-Reply-To: <46996A53.6000807@garzik.org>
References: <20070714231204.GA23582@havoc.gtf.org>
	<20070715001515.GA3641@zarina>
	<46996A53.6000807@garzik.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Jul 2007 20:29:07 -0400 Jeff Garzik <jeff@garzik.org> wrote:

> Anton Vorontsov wrote:
> > On Sat, Jul 14, 2007 at 07:12:04PM -0400, Jeff Garzik wrote:
> >> Clean up pda_power interrupt handling:
> > 
> > Nice, thanks! Just few cosmetic comments.
> > 
> >> Prior to this patch, the driver would pass information it needed
> >> to the interrupt handler dev_id pointer, and then prompt forget it
> >> ever did so, recreating that same information after a couple passes
> >> through the timer-based state machine.
> >>
> >> This patch removes the redundant checks by passing the
> >> pda_power_supply[] pointer through the state machine.  The current
> >> code passed 'irq' through the state machine, as an index to recreate
> >> the pointer, when we could more simply pass around the pointer itself.
> >>
> >> Additionally, bogus "return;" statements were removed.
> > 
> > My preference is to use "return;" statements in functions returning
> > void, even if functions is very small. It's just sugar for my eyes,
> > to really see exit points. . Without returns I've feeling that
> > something is missing there. Yes, my oddity.
> > 
> > Plus, so far CodingStyle does not say anything about non obligatory
> > return statements.
> > 
> > These should be "fixed" too, though:
> > ~/linux-2.6$ grep -h "return;" -A1 -r drivers/ arch/ | grep "^}$" | \
> > wc -l
> > 1354
> > 
> > Obviously, drivers/ata is almost pure (3). ;-)
> > 
> > Either way, I prefer to leave alone these "return;"s, until CodingStyle
> > permits them.
> 
> CodingStyle is not the end-all of rulebooks.  See repeated messages by 
> Linus, me, and others on the subject.  CodingStyle intentionally does 
> not list a rule for every possible C code incarnation.

Yup, the `return' is a waste of space.

> > I'll send patch shortly.
> > 
> >> +	void *power_supply = (void *) power_supply_ptr;
> >                                      ^
> > I guess common practice is not to put space here.
> 
> incorrect.  a space goes there, as I put it.
> 

Nope, the space is a waste of space.
