Return-Path: <linux-kernel-owner+w=401wt.eu-S1759360AbZAMJpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759360AbZAMJpM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 04:45:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755243AbZAMJo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 04:44:56 -0500
Received: from rankki.sonarnerd.net ([83.145.240.118]:6910 "EHLO
	mail.sonarnerd.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926AbZAMJoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 04:44:54 -0500
Message-ID: <496C6294.2040707@sonarnerd.net>
Date: Tue, 13 Jan 2009 11:44:52 +0200
From: Jussi Laako <jussi@sonarnerd.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH] Multimedia scheduling class
References: <4959198A.3020209@sonarnerd.net>	 <1230622925.16718.26.camel@twins>  <4959DE51.2020605@sonarnerd.net> <1231756114.19771.6.camel@laptop>
In-Reply-To: <1231756114.19771.6.camel@laptop>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> 
> Well, that's not my problem is it ;-), just batter them with a
> clue-stick, no need to fudge the kernel for that.

Sure, been doing that already... :)
There's just sort of a huge gap between rt-schedulers and the normal
scheduler.

> Right, which is where deadline scheduling would be nice. Once you start
> running into the budget throttle you know you've got to start dropping
> frames in order to keep up.
> 
> The proposal is for it to start sending SIGXCPU once it starts
> throttling tasks in order to notify them of missed deadlines etc.

For sure this is nice for certain tasks. I'm not entirely convinced if
the average media player or Flash-plugin would or should start using these.

I believe both approaches could co-exist to address different needs.
SCHED_MM is for the average software and is in a sense similar to
SCHED_BATCH and SCHED_IDLE, just targeting different use cases.
Modification is reasonably small and shouldn't have any impact when not
used. Deadline scheduler would probably belong to the
SCHED_RR/SCHED_FIFO family?

> Like said, deadline schedulers can help here. You can even dynamically
> adjust the parameters -- eg. fall back to half frame rate but double
> budget or something.

Managing the budget in an average system will be painful. In a
completely embedded environment this is of course rather straightforward.
