Return-Path: <linux-kernel-owner+w=401wt.eu-S1760256AbYHOPdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760256AbYHOPdd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 11:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbYHOPdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 11:33:23 -0400
Received: from postage-due.permabit.com ([204.246.225.5]:38822 "EHLO
	postage-due.permabit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933AbYHOPdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 11:33:22 -0400
X-Greylist: delayed 3665 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Aug 2008 11:33:22 EDT
From: Paul Lussier <pll@permabit.com>
To: linux-kernel@vger.kernel.org
Subject: Questions about (unstable) clocksources
Date: Fri, 15 Aug 2008 10:32:15 -0400
Message-ID: <6ed4kabb80.fsf@ambivalent-optimist.permabit.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Permabit-Spam: SKIPPED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,

I'm trying to understand the issues surrounding the recent (2.6.2[456])
troubles involving unstable clocksources.  Not being a kernel developer
I'm somewhat in the dark.  Also, if this isn't the correct forum to ask
these questions, please direct me to the proper place.  I have no wish
to clutter the channel with off-topic discussion.

My questions involve the characteristics and manifestations of the
problems as related to the clocksource when it becomes unstable (whether
it's tsc, hpet, acpi_pm, etc.)

I'm looking to understand these things:

 - When the clocksource goes unstable, what happens from a userspace
   perspective? i.e How will userspace processes percieve the problem?
   - Does time move at all?
   - If so, which way, forwards, backwards, either?
   - How can I detect this ?
     (size/magnitude of the delta reported in kern.log?)

 - If the TSC clocksource is registered unstable, and the another
   clocksource is chosen, can it too become unstable?
   - Based on the code in kernel/time/clocksource.c, it appears that
     clocksource_ratewd() will report the same basic message that any
     given clocksource is unstable.  Is that correct?

   - What causes hpet, acpi or jiffies to become unstable?
     (my understanding of the tsc issue is that it goes unstable in an
     SMP situation when it gets confused as to which CPU's ticks it's
     looking at.  What would cause the others to become unstable?

   - What happens if the next clocksource goes unstable?
     Does it just fallback to the next available clocksource?

And finally, what's the best way to avoid this problem (assuming a
default clocksource of tsc)?  Is it simply setting clocksource=hpet in
my grub config file?  Are there other kernel options I ought to
consider?  I've seen some mention of setting nohz=off, but no
explanation as to why that helps.

Thanks,
-- 
Paul
