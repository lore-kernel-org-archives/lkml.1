Return-Path: <linux-kernel-owner+w=401wt.eu-S1422823AbXCWLsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422823AbXCWLsu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 07:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422827AbXCWLsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 07:48:50 -0400
Received: from www.osadl.org ([213.239.205.134]:42737 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422823AbXCWLst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 07:48:49 -0400
Subject: Re: [1/6] 2.6.21-rc4: known regressions
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Mingming Cao <cmm@us.ibm.com>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Oliver Pinter <oliver.pntr@gmail.com>,
       Sid Boyce <g3vbv@blueyonder.co.uk>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Thomas Renninger <trenn@suse.de>,
       Len Brown <len.brown@intel.com>
In-Reply-To: <20070323114223.GA23483@elte.hu>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <20070318184908.GU752@stusta.de>
	 <Pine.LNX.4.64.0703212023550.6730@woody.linux-foundation.org>
	 <46020385.50301@yahoo.com.au>
	 <Pine.LNX.4.64.0703220813340.6730@woody.linux-foundation.org>
	 <1174612132.16068.114.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0703221830470.6730@woody.linux-foundation.org>
	 <20070323114223.GA23483@elte.hu>
Content-Type: text/plain
Date: Fri, 23 Mar 2007 12:56:08 +0100
Message-Id: <1174650969.10840.274.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-23 at 12:42 +0100, Ingo Molnar wrote:
> there's a new post-rc4 regression: my T60 hangs during early bootup. I 
> bisected the hang down to this recent commit:
> 
> | commit 25496caec111481161e7f06bbfa12a533c43cc6f
> | Author: Thomas Renninger <trenn@suse.de>
> | Date:   Tue Feb 27 12:13:00 2007 -0500
> |
> |    ACPI: Only use IPI on known broken machines (AMD, Dothan/BaniasPentium M)
> 
> undoing this change fixes my T60 so it correctly boots again.
> 
> the commit has this confidence-raising comment:
> 
> |   However, I am not sure about the naming of the parameter and how it 
> |   could/should get integrated into the dyntick part 
> |   (CONFIG_GENERIC_CLOCKEVENTS). There, a more fine grained check (TSC 
> |   still running?, ..) is needed?
> 
> could we please revert this commit until it's done correctly?
> 
> and did this end up being a 'fix'? The change weakens the scope of a 
> hardware workaround, which IMO has no place so late in the cycle. At a 
> minimum the clockevents maintainer (Thomas) should have been Cc:-ed on 
> it.

Ingo, 

I had seen it before, and I had no objections under the premise, that it
does not break things and especially survives on Andrews VAIO. I
expected that to come in via -mm so it gets enough testing.

We should revert that patch and add a "trust_lapic_timer_in_c2"
commandline option instead. So we are on the safe side.

	tglx


