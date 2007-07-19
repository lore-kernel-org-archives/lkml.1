Return-Path: <linux-kernel-owner+w=401wt.eu-S938385AbXGSOf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938385AbXGSOf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 10:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756807AbXGSOfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 10:35:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46463 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753029AbXGSOfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 10:35:45 -0400
Date: Thu, 19 Jul 2007 16:35:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org,
       Greg KH <greg@kroah.com>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [patch] fix the softlockup watchdog to actually work
Message-ID: <20070719143528.GA8278@elte.hu>
References: <20070717114453.GA8212@elte.hu> <469CCF8F.4010107@goop.org> <20070717154934.GA24231@elte.hu> <20070719002231.069ebbdd.akpm@linux-foundation.org> <20070719075152.GB12760@elte.hu> <469F75AF.5080000@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469F75AF.5080000@goop.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> How reliable does it need to be?  All we need is to measure "about 10 
> seconds"; if we can't get that out of it, how can it be good for 
> anything else?

sched_clock(), as its name suggests it, is meant for the scheduler's 
use. The scheduler generally only needs to measure time when the CPU is 
busy - not across idle periods. So sched_clock() can (and will) break 
across certain types of ACPI idle methods.

	Ingo
