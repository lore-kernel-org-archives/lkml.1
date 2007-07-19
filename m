Return-Path: <linux-kernel-owner+w=401wt.eu-S938366AbXGSOva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938366AbXGSOva (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 10:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760158AbXGSOvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 10:51:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44311 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759287AbXGSOvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 10:51:20 -0400
Date: Thu, 19 Jul 2007 16:50:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org,
       Greg KH <greg@kroah.com>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [patch] fix the softlockup watchdog to actually work
Message-ID: <20070719145058.GA11971@elte.hu>
References: <20070717114453.GA8212@elte.hu> <469CCF8F.4010107@goop.org> <20070717154934.GA24231@elte.hu> <20070719002231.069ebbdd.akpm@linux-foundation.org> <20070719075152.GB12760@elte.hu> <469F75AF.5080000@goop.org> <20070719143528.GA8278@elte.hu> <469F793E.6030006@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469F793E.6030006@goop.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Hm, or more specifically, why would that be a problem for softlockup? 
> Do you mean it doesn't measure time during ACPI idle?  That would just 
> make it trigger later than it would otherwise.

no, the return value after idling can be completely random on some 
boxes, on a 64-bit scale - triggering the softlockup watchdog randomly. 
(some boxes return random TSC values, etc.) Again, it's fine for the 
scheduler's purpose, that's why i named it sched_clock().

the proper clocksource use within the kernel is ktime_get() [or 
ktime_get_ts()]. Do not abuse sched_clock() for such things.

	Ingo
