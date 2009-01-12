Return-Path: <linux-kernel-owner+w=401wt.eu-S1754397AbZALK2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397AbZALK2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 05:28:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbZALK2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 05:28:40 -0500
Received: from casper.infradead.org ([85.118.1.10]:58850 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbZALK2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 05:28:39 -0500
Subject: Re: [RFC][PATCH] Multimedia scheduling class
From: Peter Zijlstra <peterz@infradead.org>
To: Jussi Laako <jussi@sonarnerd.net>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4959DE51.2020605@sonarnerd.net>
References: <4959198A.3020209@sonarnerd.net>
	 <1230622925.16718.26.camel@twins>  <4959DE51.2020605@sonarnerd.net>
Content-Type: text/plain
Date: Mon, 12 Jan 2009 11:28:34 +0100
Message-Id: <1231756114.19771.6.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right, so I totally lost this thread in my inbox -- sorry for that.

On Tue, 2008-12-30 at 10:39 +0200, Jussi Laako wrote:

> > Eventually we'd hope to provide an sporadic task EDF based scheduler
> > with hard and soft realtime capabilities, but until that time, FIFO and
> > RR are the classes to use for anything realtime.
> 
> Yes, this is also what I thought first and I still believe this would
> also be a good addition. After a bit more thinking I concluded that it
> might be a bit too hard-realtime'ish for many of the tasks. It would
> become rather close to running FIFO with flat priority?

Not quite so, you can avoid starvation with deadline schedulers, just
limit their budget.

> ....and these tasks are not sporadic, but strictly periodic...
> 
> > I'm not sure why you think SCHED_FIFO isn't good enough for your
> > applications, could you elaborate on that?
> 
> Actually the biggest problem is that many of the developers are not
> comfortable with using SCHED_FIFO for the purpose... :)

Well, that's not my problem is it ;-), just batter them with a
clue-stick, no need to fudge the kernel for that.

> FIFO is unsuitable for video codecs, RR would be better there, but still
> it would starve rest of the system too much in some cases (it can lose
> some frames to keep rest of the system responsive).

Right, which is where deadline scheduling would be nice. Once you start
running into the budget throttle you know you've got to start dropping
frames in order to keep up.

The proposal is for it to start sending SIGXCPU once it starts
throttling tasks in order to notify them of missed deadlines etc.

> Some multimedia software is just not implemented in a way that it would
> be safe to run these at RT-priority (having various too
> nondeterministic code paths).

Like said, deadline schedulers can help here. You can even dynamically
adjust the parameters -- eg. fall back to half frame rate but double
budget or something.

