Return-Path: <linux-kernel-owner+w=401wt.eu-S936753AbXGSPF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936753AbXGSPF4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 11:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763252AbXGSPF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 11:05:26 -0400
Received: from gw.goop.org ([64.81.55.164]:53309 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965083AbXGSPFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 11:05:21 -0400
Message-ID: <469F7D7A.204@goop.org>
Date: Thu, 19 Jul 2007 08:04:26 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org,
       Greg KH <greg@kroah.com>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [patch] fix the softlockup watchdog to actually work
References: <20070717114453.GA8212@elte.hu> <469CCF8F.4010107@goop.org> <20070717154934.GA24231@elte.hu> <20070719002231.069ebbdd.akpm@linux-foundation.org> <20070719075152.GB12760@elte.hu> <469F75AF.5080000@goop.org> <20070719143528.GA8278@elte.hu> <469F793E.6030006@goop.org> <20070719145058.GA11971@elte.hu>
In-Reply-To: <20070719145058.GA11971@elte.hu>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> no, the return value after idling can be completely random on some 
> boxes, on a 64-bit scale - triggering the softlockup watchdog randomly. 
> (some boxes return random TSC values, etc.) Again, it's fine for the 
> scheduler's purpose, that's why i named it sched_clock().
>
> the proper clocksource use within the kernel is ktime_get() [or 
> ktime_get_ts()]. Do not abuse sched_clock() for such things.

Well, my observation is that both softlockup and the scheduler really
want to measure unstolen time, so it seemed to me that sched_clock was a
nice common place to implement that, rather than implementing a whole
new time interface.  At the time that seemed OK, and nobody had any
objections.

But it's a bit beside the point unless it does turn out to be making
Andrew's Vaio sad.

    J
