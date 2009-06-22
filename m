Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058AbZFVLy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbZFVLy2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 07:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbZFVLyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 07:54:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43436 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbZFVLyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 07:54:19 -0400
Date: Mon, 22 Jun 2009 13:54:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: eranian@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: I.7 - Group validity checking
Message-ID: <20090622115400.GH24366@elte.hu>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0016]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 7/ Group validity checking
>
> At the user level, an application is only concerned with events
> and grouping of those events. The assignment logic is performed by
> the kernel.
>
> For a group to be scheduled, all its events must be compatible
> with each other, otherwise the group will never be scheduled. It
> is not clear to me when that sanity check will be performed if I
> create the group such that it is stopped.

The hardware implementation should verify that the group fits on the
PMU for every new group member.

Like said before, we think this and I.2/ are in conflict.

> If the group goes all the way to scheduling, it will never be
> scheduled. Counts will be zero and the users will have no idea
> why. If the group is put in error state, read will not be
> possible. But again, how will the user know why?

It should not be possible to create such a situation. Can you see it 
being possible?
