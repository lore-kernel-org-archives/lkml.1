Return-Path: <linux-kernel-owner+w=401wt.eu-S1422821AbXCWLno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422821AbXCWLno (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 07:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422791AbXCWLno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 07:43:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34346 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422817AbXCWLnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 07:43:43 -0400
Date: Fri, 23 Mar 2007 12:42:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Mingming Cao <cmm@us.ibm.com>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Oliver Pinter <oliver.pntr@gmail.com>,
       Sid Boyce <g3vbv@blueyonder.co.uk>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Thomas Renninger <trenn@suse.de>,
       Len Brown <len.brown@intel.com>
Subject: Re: [1/6] 2.6.21-rc4: known regressions
Message-ID: <20070323114223.GA23483@elte.hu>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <20070318184908.GU752@stusta.de> <Pine.LNX.4.64.0703212023550.6730@woody.linux-foundation.org> <46020385.50301@yahoo.com.au> <Pine.LNX.4.64.0703220813340.6730@woody.linux-foundation.org> <1174612132.16068.114.camel@localhost.localdomain> <Pine.LNX.4.64.0703221830470.6730@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703221830470.6730@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


there's a new post-rc4 regression: my T60 hangs during early bootup. I 
bisected the hang down to this recent commit:

| commit 25496caec111481161e7f06bbfa12a533c43cc6f
| Author: Thomas Renninger <trenn@suse.de>
| Date:   Tue Feb 27 12:13:00 2007 -0500
|
|    ACPI: Only use IPI on known broken machines (AMD, Dothan/BaniasPentium M)

undoing this change fixes my T60 so it correctly boots again.

the commit has this confidence-raising comment:

|   However, I am not sure about the naming of the parameter and how it 
|   could/should get integrated into the dyntick part 
|   (CONFIG_GENERIC_CLOCKEVENTS). There, a more fine grained check (TSC 
|   still running?, ..) is needed?

could we please revert this commit until it's done correctly?

and did this end up being a 'fix'? The change weakens the scope of a 
hardware workaround, which IMO has no place so late in the cycle. At a 
minimum the clockevents maintainer (Thomas) should have been Cc:-ed on 
it.

	Ingo
