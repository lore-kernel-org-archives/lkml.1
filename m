Return-Path: <linux-kernel-owner+w=401wt.eu-S938652AbXGSOsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938652AbXGSOsE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 10:48:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765301AbXGSOrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 10:47:18 -0400
Received: from gw.goop.org ([64.81.55.164]:50026 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757701AbXGSOrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 10:47:17 -0400
Message-ID: <469F793E.6030006@goop.org>
Date: Thu, 19 Jul 2007 07:46:22 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org,
       Greg KH <greg@kroah.com>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [patch] fix the softlockup watchdog to actually work
References: <20070717114453.GA8212@elte.hu> <469CCF8F.4010107@goop.org> <20070717154934.GA24231@elte.hu> <20070719002231.069ebbdd.akpm@linux-foundation.org> <20070719075152.GB12760@elte.hu> <469F75AF.5080000@goop.org> <20070719143528.GA8278@elte.hu>
In-Reply-To: <20070719143528.GA8278@elte.hu>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> sched_clock(), as its name suggests it, is meant for the scheduler's 
> use. The scheduler generally only needs to measure time when the CPU is 
> busy - not across idle periods. So sched_clock() can (and will) break 
> across certain types of ACPI idle methods.
>   

Hm, or more specifically, why would that be a problem for softlockup? 
Do you mean it doesn't measure time during ACPI idle?   That would just
make it trigger later than it would otherwise.

Andrew is reporting that it is triggering very early, and making the
machine feel jerky.  How can that be related to sched_clock's quality,
unless its too broken to be useful to anyone for anything?

    J
