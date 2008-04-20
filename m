Return-Path: <linux-kernel-owner+w=401wt.eu-S1761290AbYDTMlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761290AbYDTMlU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 08:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755553AbYDTMlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 08:41:11 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:43676 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533AbYDTMlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 08:41:08 -0400
To: "Woodruff, Richard" <r-woodruff2@ti.com>
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       <linux-kernel@vger.kernel.org>, <linux-pm@lists.linux-foundation.org>,
       lenb@kernel.org
Subject: Re: Higer latency with dynamic tick (need for an io-ondemand govenor?)
From: Andi Kleen <andi@firstfloor.org>
References: <3B6D69C3A9EBCA4BA5DA60D913027429010253CD@dlee13.ent.ti.com>
	<1179396659.3764.40.camel@chaos>
	<3B6D69C3A9EBCA4BA5DA60D913027429010258E8@dlee13.ent.ti.com>
	<1179434296.12981.14.camel@chaos>
	<3B6D69C3A9EBCA4BA5DA60D913027429010259ED@dlee13.ent.ti.com>
	<1179474567.12981.53.camel@chaos>
	<3B6D69C3A9EBCA4BA5DA60D91302742904131BED@dlee13.ent.ti.com>
Date: Sun, 20 Apr 2008 14:41:05 +0200
In-Reply-To: <3B6D69C3A9EBCA4BA5DA60D91302742904131BED@dlee13.ent.ti.com> (Richard Woodruff's message of "Fri, 18 Apr 2008 10:43:32 -0500")
Message-ID: <87ej90aece.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 20 Apr 2008 12:34:17.0456 (UTC) FILETIME=[D972FF00:01C8A2E2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Woodruff, Richard" <r-woodruff2@ti.com> writes:

> When capturing some traces with dynamic tick we were noticing the
> interrupt latency seems to go up a good amount. If you look at the trace
> the gpio IRQ is now offset a good amount.  Good news I guess is its
> pretty predictable.
>
> * If we couple this with progressively higher latency C-States we see
> that IO speed can fall by a good amount, especially for PIO mixes.  Now
> if QOS is maintained you may or may-not care.
>
> I was wondering what thoughts of optimizing this might be.
>
> One thought was if an io-ondemand of some sort was used.  It could track
> interrupt statistics and be feed back into cpu-idle.  When there is a
> high interrupt load period it could shrink the acceptable latency and
> thus help choose a good a C-State which favors throughput.  Some moving
> average window could be used to track it.
>
> Perhaps a new interrupt attribute could be attached at irq request time
> to allow the tracking of bandwidth important devices.
>
> The attached is captured on a .22 kernel.  The same should be available
> in a bit on a .24 kernel.

Are you talking about x86? 

On older x86 this effect should have been handled by the C state
algorithm taking the bus master activity register into account (which
should also trigger for interrupts)

But I think the register has been nop'ed on newer platforms 
so indeed we'll need some way to handle this.

-Andi
