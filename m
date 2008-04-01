Return-Path: <linux-kernel-owner+w=401wt.eu-S1757274AbYDAIkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274AbYDAIkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 04:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753565AbYDAIk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 04:40:28 -0400
Received: from smtp.nokia.com ([192.100.122.230]:59172 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204AbYDAIk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 04:40:27 -0400
Message-ID: <47F1F39E.3080609@nokia.com>
Date: Tue, 01 Apr 2008 11:34:38 +0300
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: ext Pekka Enberg <penberg@cs.helsinki.fi>
CC: Artem Bityutskiy <dedekind@yandex.ru>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 25/26] UBIFS: add debugging stuff
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com>       <1206629746-4298-26-git-send-email-Artem.Bityutskiy@nokia.com> <84144f020803311400s1f34420dx153d197f4752c65e@mail.gmail.com> <47F1D44A.8010908@yandex.ru> <47F1E534.7050803@cs.helsinki.fi>
In-Reply-To: <47F1E534.7050803@cs.helsinki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Apr 2008 08:39:53.0356 (UTC) FILETIME=[F4BE64C0:01C893D3]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> Hi Artem,
> 
> Artem Bityutskiy wrote:
>> Well, I do not see a big reason not to get rid of this harmless stuff.
>> Many kernel subsystems have their debugging, why not? Using BUG_ON() is
>> OK in few most important places. But we want to have more assertions
>> which are compiled-out by default, why can't we?. Similar is for prints.
> 
> Why would you want to have assertions that are compiled out by default? 

For debugging.  It would be unreasonably inefficient on embedded systems
to have them compiled in.

> Either you handle the error or don't (and have an assertion).

It depends whether you consider error handling and debugging to be the same
thing.  Failing an assert is not an error - it is a bug.  It is very
difficult, and sometimes impossible, to contrive a useful response to
a bug.  It is also not really worth the effort.

BUG_ON is a poor solution for embedded systems.  When developing and debugging
you don't want your system to panic just because you are on the track of a bug.
And then when the system is in production, you don't want it to panic period.
We have had lots of situations where BUG_ON has been used incorrectly to handle
errors, and we have had to replace it with proper error-handling.

> The reason 
> some subsystems have had their own asserts is because they go overboard 
> with defensive checks as they haven't bothered to think through a 
> reasonable error handling strategy. The downside? It clutters the code 
> and causes the (compiled out) assertions to bit-rot.

Anyone developing or doing serious testing would have debugging turned on.
Anyone doing debugging, would have debugging turned on.  It seems pretty
unlikely that the assertions would bit-rot.

> Note that they're also a total pain in the ass to enable for anyone not 
> intimately familiar with your code.

Selecting a config option doesn't seem that hard.

> Not to mention you're now making the 
> lives of those crazy embedded folks that disable CONFIG_BUG for smaller 
> kernel size harder as well.

How?

> Do you know why we don't have compiled out asserts in the core kernel? 
> That's because it simply can't just roll-over and die if something 
> unexpected happens and your filesystem shouldn't probably do that 
> either. Sure, if you have some debugging checks that are way too 
> expensive for production use, you might want to have a 
> CONFIG_UBIFS_DEBUG but that shouldn't happen at assertion level but 
> rather at much higher level.

Our asserts don't roll over and die.  They print a message and dump the
stack and keep going.

> And btw, for optional printks, we have a lot of tracing infrastructure 
> in the kernel already (kprobes, relayfs, ftrace probably soon), so if 
> you want to have tracing for UBIFS (you probably don't), don't invent 
> your mechanism. But for most printks, they're either useful or they're 
> not. Again, I do see the potential need for CONFIG_UBIFS_DEBUG here, but 
> doing that at printk-level is also too low-level.

And lots of file systems (e.g. EXT2, JFFS2) have optional prints as well,
just like UBIFS.

