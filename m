Return-Path: <linux-kernel-owner+w=401wt.eu-S933292AbXGYPkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933292AbXGYPkX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 11:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762477AbXGYPkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 11:40:09 -0400
Received: from ns.suse.de ([195.135.220.2]:37922 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760614AbXGYPkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 11:40:07 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org,
       Greg KH <greg@kroah.com>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [patch] fix the softlockup watchdog to actually work
References: <20070717114453.GA8212@elte.hu> <469CCF8F.4010107@goop.org>
	<20070717154934.GA24231@elte.hu>
	<20070725014912.35c7e325.akpm@linux-foundation.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 25 Jul 2007 18:34:54 +0200
In-Reply-To: <20070725014912.35c7e325.akpm@linux-foundation.org>
Message-ID: <p73ejiwsaq9.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:
> 
> One possibility is that sched_clock() is bollixed and (say) it's returning
> a 32-bit value.  That'll cause the softlockup logic to get a bit sick when
> time wraps.

FYI, The current ff x86 sched_clock() [which you likely have, it's not
mainline] tends to warp backwards by 80-90ms during cpu freq changes
on AMD on one of my test systems. I haven't tracked down why it does
that yet. Intel or systems with no cpufreq or cpufreq not changing
frequencies regularly are not affected

-Andi
