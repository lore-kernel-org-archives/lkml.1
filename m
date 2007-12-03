Return-Path: <linux-kernel-owner+w=401wt.eu-S1752605AbXLCWGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbXLCWGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 17:06:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbXLCWGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 17:06:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58922 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbXLCWGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 17:06:23 -0500
Date: Mon, 3 Dec 2007 23:05:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mark Lord <lkml@rtr.ca>
Cc: Chris Friesen <cfriesen@nortel.com>, davids@webmaster.com,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched_yield: delete sysctl_sched_compat_yield
Message-ID: <20071203220559.GA11906@elte.hu>
References: <MDEHLPKNGKAHNMBLJOLKEEHJIJAC.davids@webmaster.com> <47545F88.6070609@nortel.com> <4754777F.7020302@rtr.ca> <20071203214803.GA8989@elte.hu> <47547BB6.3040402@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47547BB6.3040402@rtr.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mark Lord <lkml@rtr.ca> wrote:

> Ack.  And what of the suggestion to try to ensure that a yielding task 
> simply not end up as the very next one chosen to run?  Maybe by 
> swapping it with another (adjacent?) task in the tree if it comes out 
> on top again?

we did that too for quite some time in CFS - it was found to be "not 
agressive enough" by some folks and "too agressive" by others. Then when 
people started bickering over this we added these two simple corner 
cases - switchable via a flag. (minimum agression and maximum agression)

> (I really don't know the proper terminology to use here, but hopefully 
> Ingo can translate that).

the terminology you used is perfectly fine.

> Thanks Ingo -- I *really* like this scheduler!

heh, thanks :) For which workload does it make the biggest difference 
for you? (and compared to what other scheduler you used before? 2.6.22?)

	Ingo
