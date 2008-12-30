Return-Path: <linux-kernel-owner+w=401wt.eu-S1753464AbYL3Ijz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbYL3Ijz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 03:39:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbYL3Ijr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 03:39:47 -0500
Received: from rankki.sonarnerd.net ([83.145.240.118]:31496 "EHLO
	mail.sonarnerd.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbYL3Ijr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 03:39:47 -0500
Message-ID: <4959DE51.2020605@sonarnerd.net>
Date: Tue, 30 Dec 2008 10:39:45 +0200
From: Jussi Laako <jussi@sonarnerd.net>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH] Multimedia scheduling class
References: <4959198A.3020209@sonarnerd.net> <1230622925.16718.26.camel@twins>
In-Reply-To: <1230622925.16718.26.camel@twins>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> This is typically the domain of soft-realtime, and as such would need a
> realtime scheduling class -- using a proportional class like you did
> just doesn't make sense for these tasks.

Yes, this is for a soft-realtime usage. Some of the tasks are
CPU-intensive while being realtime'ish, like video codecs and some audio
processing tasks. These audio processing tasks can have some amount of
buffering. The idea behind this patch is to make these tasks overlap
with the normal tasks while giving a slightly more responsive scheduling
behavior and to favor these multimedia tasks over others.

Another option would be to create another scheduler which could overlap
with the normal one, in a way FIFO/RR overlap. After inspecting current
scheduler code I thought that this kind of modification and use of the
same task tree would be feasible, instead of having it's own run queue.

> Eventually we'd hope to provide an sporadic task EDF based scheduler
> with hard and soft realtime capabilities, but until that time, FIFO and
> RR are the classes to use for anything realtime.

Yes, this is also what I thought first and I still believe this would
also be a good addition. After a bit more thinking I concluded that it
might be a bit too hard-realtime'ish for many of the tasks. It would
become rather close to running FIFO with flat priority?

...and these tasks are not sporadic, but strictly periodic...

> I'm not sure why you think SCHED_FIFO isn't good enough for your
> applications, could you elaborate on that?

Actually the biggest problem is that many of the developers are not
comfortable with using SCHED_FIFO for the purpose... :)
FIFO is unsuitable for video codecs, RR would be better there, but still
it would starve rest of the system too much in some cases (it can lose
some frames to keep rest of the system responsive).
Some multimedia software is just not implemented in a way that it would
be safe to run these at RT-priority (having various too
nondeterministic code paths).


	- Jussi
