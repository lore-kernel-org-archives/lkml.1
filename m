Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbYCUAgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbYCUAgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 20:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbYCUAgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 20:36:11 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:45491 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750870AbYCUAgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 20:36:10 -0400
X-Sasl-enc: OXzslyjLqTNS628f5/VnD7B/V+Ycfa9lK6cRCAGg0Voy 1206059768
Date: Thu, 20 Mar 2008 21:36:04 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Brownell <david-b@pacbell.net>, Richard Purdie <rpurdie@rpsys.net>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: use of preempt_count instead of in_atomic() at leds-gpio.c
Message-ID: <20080321003604.GC20788@khazad-dum.debian.net>
References: <20080316184349.GA28543@khazad-dum.debian.net> <200803161246.23909.david-b@pacbell.net> <20080318001429.896acf51.akpm@linux-foundation.org> <20080320225612.GB20788@khazad-dum.debian.net> <20080320164741.734e838c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080320164741.734e838c.akpm@linux-foundation.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Mar 2008, Andrew Morton wrote:
> On Thu, 20 Mar 2008 19:56:12 -0300 Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
> > Can we add "in_scheduleable()", or maybe "can_schedule()", that returns
> > in_atomic() if CONFIG_PREEMT, or 0 if there is no way to know?   To my
> > limited knowledge of how that part of the kernel works, it would do the
> > right thing.
> 
> If we did that, then people would use it.  And that would be bad.  It'll
> lead to code which behaves differently on non-preemptible kernels, to code
> which works less well on non-preemptible kernels and it will lead to less
> well-thought-out code in general.
> 
> Really, this all points at an ill-designed part of the leds interface.  The
> consistent pattern we use in the kernel is that callers keep track of
> whether they are running in a schedulable context and, if necessary, they
> will inform callees about that.  Callees don't work it out for themselves.

ACK.  Richard?  I have changed the thinkpad-acpi LED support to always defer
to a workqueue right now, but this *really* wants a LED class API fixup.
I'm for adding an specific hook for atomic access, but a flag would be good
enough too.

Well, so far so good for LEDs, but what about the other users of in_atomic
that apparently should not be doing it either?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
