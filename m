Return-Path: <linux-kernel-owner+w=401wt.eu-S1754106AbYBDGzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbYBDGzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 01:55:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbYBDGzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 01:55:06 -0500
Received: from numenor.qualcomm.com ([129.46.51.58]:53997 "EHLO
	numenor.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbYBDGzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 01:55:05 -0500
Message-ID: <47A6B666.4050208@qualcomm.com>
Date: Sun, 03 Feb 2008 22:53:26 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Daniel Walker <dwalker@mvista.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <srostedt@redhat.com>,
       Gregory Haskins <ghaskins@novell.com>, Paul Jackson <pj@sgi.com>
Subject: Re: [CPUISOL] CPU isolation extensions
References: <1201493382-29804-1-git-send-email-maxk@qualcomm.com>	 <1201511305.6149.30.camel@lappy>  <479E1FD4.5040606@qualcomm.com>	 <1201563706.2826.34.camel@imap.mvista.com>  <479E6F71.4040906@qualcomm.com> <1201570413.2826.73.camel@imap.mvista.com>
In-Reply-To: <1201570413.2826.73.camel@imap.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

Sorry for not replying right away.

Daniel Walker wrote:
> On Mon, 2008-01-28 at 16:12 -0800, Max Krasnyanskiy wrote:
> 
>> Not accurate enough and way too much overhead for what I need. I know at this point it probably 
>> sounds like I'm talking BS :). I wish I've released the engine and examples by now. Anyway let 
>> me just say that SW MAC has crazy tight deadlines with lots of small tasks. Using nanosleep() & 
>> gettimeofday() is simply not practical. So it's all TSC based with clever time sync logic between
>> HW and SW.
> 
> I don't know if it's BS or not, you clearly fixed your own problem which
> is good .. Although when you say "RT patches cannot achieve what I
> needed. Even RTAI/Xenomai can't do that." , and HRT is "Not accurate
> enough and way too much overhead" .. Given the hardware your using,
> that's all difficult to believe.. You also said this code has been
> running on production systems for two year, which means it's at least
> two years old .. There's been some good sized leaps in real time linux
> in the past two years ..

I've been actually tracking RT patches fairly closely. I can't say I tried all of them but I do try
them from time to time. I just got latest 2.6.24-rt1 running on HP xw9300. Looks like it does not handle
CPU hotplug very well, I manged to kill it by bringing cpu 1 off-line. So I cannot run any tests right 
now will run some tomorrow.
 
For now let me mention that I have a simple tests that sleeps for a millisecond, then does some bitbanging 
for 200 usec. It measures jitter caused by the periodic scheduler tick, IPIs and other kernel activities.
With high-res timers disabled on most of the machines I mentioned before it shows around 1-1.2usec worst case. 
With high-res timers enabled it shows 5-6usec. This is with 2.6.24 running on an isolated CPU. Forget about
using a user-space timer (nanosleep(), etc). Even scheduler tick itself is fairly heavy.
gettimeofday() call on that machine takes on average 2-3usec (not a vsyscall) and SW MAC is all about precise 
timing. That's why I said that it's not practical to use that stuff for me. I do not see anything in -rt kernel 
that would improve this.

This is btw not to say that -rt kernel is not useful for my app in general. We have a bunch of soft-RT threads
that talk to the MAC thread. Those would definitely benefit. I think cpu isolation + -rt would work beautifully
for wireless basestations.

Max 
