Return-Path: <linux-kernel-owner+w=401wt.eu-S1751940AbZL1Owb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbZL1Owb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 09:52:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbZL1Owa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 09:52:30 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41305 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbZL1Ow3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 09:52:29 -0500
Subject: Re: [RFC 10/12][PATCH] SCHED_DEADLINE: group bandwidth management
 code
From: Peter Zijlstra <peterz@infradead.org>
To: Raistlin <raistlin@linux.it>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       michael trimarchi <michael@evidence.eu.com>,
       Fabio Checconi <fabio@gandalf.sssup.it>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Johan Eker <johan.eker@ericsson.com>, "p.faure" <p.faure@akatech.ch>,
       Chris Friesen <cfriesen@nortel.com>,
       Steven Rostedt <rostedt@goodmis.org>, Henrik Austad <henrik@austad.us>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Darren Hart <darren@dvhart.com>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Bjoern Brandenburg <bbb@cs.unc.edu>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>,
       "giuseppe.lipari" <giuseppe.lipari@sssup.it>,
       Juri Lelli <juri.lelli@gmail.com>
In-Reply-To: <1255708004.6228.466.camel@Palantir>
References: <1255707324.6228.448.camel@Palantir>
	 <1255708004.6228.466.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Dec 2009 15:51:12 +0100
Message-ID: <1262011872.7135.119.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-16 at 17:46 +0200, Raistlin wrote:
> CPU Container Groups support for SCHED_DEADLINE is introduced by this commit.
> 
> CGroups, if configured, have a SCHED_DEADLINE bandwidth, and it is enforced
> that the sum of the bandwidths of entities (tasks and groups) belonging to
> a group stays below its own bandwidth.

No real comment on the code here, but since we have a deadline bandwidth
reservation, should we not also couple to the existing rt (fifo)
bandwidth reservation?

We can't after all guarantee the FIFO time if there's deadline
reservations around for more.

