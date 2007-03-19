Return-Path: <linux-kernel-owner+w=401wt.eu-S932280AbXCSPHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280AbXCSPHF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 11:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932322AbXCSPHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 11:07:05 -0400
Received: from zcars04f.nortel.com ([47.129.242.57]:55984 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932280AbXCSPHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 11:07:03 -0400
Message-ID: <45FEA6FC.6020503@nortel.com>
Date: Mon, 19 Mar 2007 09:06:36 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Mark Hahn <hahn@mcmaster.ca>
CC: Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
Subject: Re: RSDL v0.31
References: <200703042335.26785.a1426z@gawab.com> <20070317074506.GA13685@elte.hu> <87fy84i7nn.fsf@depni.sinp.msu.ru> <200703172048.46267.kernel@kolivas.org> <Pine.LNX.4.64.0703171105270.16125@coffee.psychology.mcmaster.ca>
In-Reply-To: <Pine.LNX.4.64.0703171105270.16125@coffee.psychology.mcmaster.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Mar 2007 15:06:40.0406 (UTC) FILETIME=[32A9F360:01C76A38]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Just so you know the context, I'm coming at this from the point of view 
of an embedded call server designer.

Mark Hahn wrote:
> why do you think fairness is good, especially always good?

Fairness is good because it promotes predictability.  See the 
"deterministic" section below.

> even starvation is sometimes a good thing - there's a place for processes
> that only use the CPU if it is otherwise idle.  that is, they are
> deliberately starved all the rest of the time.

If you have nice 19 be sufficiently low priority, then the difference 
between "using cpu if otherwise idle" and "gets a little bit of cpu even 
if not totally idle" is unimportant.

Starvation is a very *bad* thing when you don't want it.


>> Much lower and bound latencies

> in an average sense?  also, under what circumstances does this actually
> matter?  (please don't offer something like RT audio on an overloaded 
> machine- that's operator error, not something to design for.)

In my environment, latency *matters*.  If a packet doesn't get processed 
in time, you drop it.  With mainline it can be quite tricky to tune the 
latency, especially when you don't want to resort to soft realtime 
because you don't entirely trust the code thats running (because it came 
from a third party vendor).


>> Deterministic

> not a bad thing, but how does this make itself apparent and of value to 
> the user?  I think everyone is extremely comfortable with non-determinism
> (stemming from networks, caches, interleaved workloads, etc)

Determinism is really important.  It almost doesn't matter what the 
behaviour is, as long as we can predict it.  We model the system to 
determine how to tweak the system (niceness, sched policy, etc.), as 
well as what performance numbers we can advertise.  If the system is 
non-deterministic, it makes this modelling extremely difficult--you end 
up having to give up significant performance due to worst-case spikes.

If the system is deterministic, it makes it much easier to predict its 
actions.

Chris
