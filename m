Return-Path: <linux-kernel-owner+w=401wt.eu-S1756018AbYGBT5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbYGBT5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 15:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753190AbYGBT50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 15:57:26 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44458 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbYGBT5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 15:57:25 -0400
Message-ID: <486BDDA0.4070306@firstfloor.org>
Date: Wed, 02 Jul 2008 21:57:20 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Michael Kerrisk <mtk.manpages@googlemail.com>
CC: lkml <linux-kernel@vger.kernel.org>, linux-man@vger.kernel.org
Subject: Re: getcpu(2) man page
References: <486BD19B.7040302@gmail.com>
In-Reply-To: <486BD19B.7040302@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk wrote:

> .\" FIXME(ak) If the following formulation is correct, I think it would
> .\" be better to substitute it instead of the next sentence:
> .\"     The information placed in \fIcpu\fP is only guaranteed to be
> .\"     current at the time of the call: ...

At least sched_setaffinity should be still mentioned.
Feel free to rephrase it if you think it's better in some other way.

> .\" FIXME(ak) In the following, what precisely do you mean by "advisory"?
> .\" It is not really clear to me whether you mean the information
> .\" may not be "true", or whether you are just reiterating the point that
> .\" the CPU/node might already have changed by the time the call returns.

It's reiterating the point, but in general the caller has to consider
it advisory as a hint only because it cannot rely on it 100% (unless it set the affinity)

> .\" FIXME(ak) what does the phrase "but might query the current state
> .\" only during a short implementation specific interval" mean?
> it will be faster, but might query the current state only during
> a short implementation specific interval.

Originally the cache had a time stamp and then would only get the CPU
information once each jiffie. That works well because the CPU affinity
is typically hold long enough.

Unfortunately someone who didn't understand the design and didn't think
it through took that out  so currently applications have to reimplement that
mechanism in a usually inferior and slower way (querying timers is much slower in
general user space) or do "endless caches" which are also bad


-Andi
