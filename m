Return-Path: <linux-kernel-owner+w=401wt.eu-S1757731AbYGPAW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757731AbYGPAW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 20:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753890AbYGPAWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 20:22:20 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:8513 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbYGPAWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 20:22:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=IVrOdGQungZIfeivkAAWJL6b9A/6Vud5r3GsDgTVIhMN7+8RIjBzMbepoL+ODAIp74
         rHhsZz+A9bUyOksKhBJo8uPC0sx5b5uu3DFX2d00g/oGee0ur153sgLpQuoaDHp1qRNf
         gjWhO1445BVrKDQ2v87Mh3aICuSof9pezePsw=
Date: Wed, 16 Jul 2008 02:21:59 +0200
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH 00/13] kmemcheck (review)
Message-ID: <20080716002158.GA12564@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am sending out the current version of kmemcheck for review.

Let me first of all note that, yes, the SMP support is completely and utterly BROKEN, owing to, amongst other things, the fact that I forgot to use any memory barriers at all with the atomic ops. My only defence is that I've never worked with those before, and the reason the code is still there is that I'm hoping we might find a way to solve the problem. (This is all disregarding the fact that halting all CPUs in a system while processing any page fault is really an absolutely disgusting idea; still, it allows kmemcheck to be booted with SMP and let the user control the bad effects using CPU hotplug.)

(In other words: Comments, suggestions on how to fix this, and patches too, are all received in gratitude.)

Our changes since last full LKML posting:
 - use set_memory_4k() where possible instead of disabling PSE at boot time
 - SLAB support (courtesy of Pekka)
 - better error reports:
    - discard irrelevant stack frames using save_stack_trace_bp()
    - reports using tasklet instead of timer
    - include a dump of a small portion of the shadow map
 - reorganized source code by splitting and moving to arch/x86/mm/kmemcheck/
 - CodingStyle/checkpatch fix-ups
 - a few other minor changes and fixes
 - (SMP support, but BROKEN; see above.)

I believe there are many things which could be better, especially things like comments explaining how it works, but which are easy to forget when I'm working with it and have all the details in my head. So please ask, and I will try to adjust it accordingly.

Also, a small disclaimer; if you see anything that looks completely ridiculous, it's probably because I didn't know any better. I'll be very happy for any corrections. Review can only make the code better, right?

Oh, and before I forget: These patches are against v2.6.26 and are slightly different from what Ingo has in -tip. I've squashed bugfixes, et.c. as to make the series as easy as possible to review, whereas the branch in tip has these as separate commits. I've also removed some Signed-off-by lines that I felt were not up to date as I might have edited the patch later and thus invalidated the SOBs. I have not modified patches where the author was not me, and all authorship tags should therefore be preserved as well.


Vegard
