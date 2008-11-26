Return-Path: <linux-kernel-owner+w=401wt.eu-S1753460AbYKZLWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbYKZLWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 06:22:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbYKZLWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 06:22:03 -0500
Received: from mail.windriver.com ([147.11.1.11]:51231 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858AbYKZLWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 06:22:01 -0500
From: Andrew McDermott <andrew.mcdermott@windriver.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       ltt-dev@lists.casi.polymtl.ca,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>
Subject: Re: [ltt-dev] [PATCH] Poll : introduce poll_wait_exclusive() new	function
In-Reply-To: <20081126111511.GE14826@Krystal> (Mathieu Desnoyers's message of
	"Wed, 26 Nov 2008 06:15:11 -0500")
References: <20081124205512.26C1.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20081124121659.GA18987@Krystal>
	<20081125194700.26EB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<alpine.DEB.1.10.0811251316590.32523@alien.or.mcafeemobile.com>
	<20081126111511.GE14826@Krystal>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
Date: Wed, 26 Nov 2008 11:20:24 +0000
Message-ID: <v4skpeent3.fsf@swi-aim.swindon.wrsec.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 26 Nov 2008 11:20:27.0822 (UTC) FILETIME=[FC0F7CE0:01C94FB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Mathieu Desnoyers <compudj@krystal.dyndns.org> writes:

[...]

>> > Mathieu Desnoyers explained it cause following problem to LTTng.
>> > 
>> >    In LTTng, all lttd readers are polling all the available debugfs files
>> >    for data. This is principally because the number of reader threads is
>> >    user-defined and there are typical workloads where a single CPU is
>> >    producing most of the tracing data and all other CPUs are idle,
>> >    available to consume data. It therefore makes sense not to tie those
>> >    threads to specific buffers. However, when the number of threads grows,
>> >    we face a "thundering herd" problem where many threads can be woken up
>> >    and put back to sleep, leaving only a single thread doing useful work.
>> 
>> Why do you need to have so many threads banging a single device/file?
>> Have one (or any other very little number) puller thread(s), that 
>> activates with chucks of pulled data the other processing threads. That 
>> way there's no need for a new wakeup abstraction.
>> 
>> 
>> 
>> - Davide
>
> One of the key design rule of LTTng is to do not depend on such
> system-wide data structures, or entity (e.g. single manager thread).
> Everything is per-cpu, and it does scale very well.
>
> I wonder how badly the approach you propose can scale on large NUMA
> systems, where having to synchronize everything through a single thread
> might become an important point of contention, just due to the cacheline
> bouncing and extra scheduler activity involved.

But at the end of the day these threads end up writing to the (possibly)
single spindle.  Isn't that the biggest bottlneck here?

-- 
andy
