Return-Path: <linux-kernel-owner+w=401wt.eu-S1755544AbYDAHeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbYDAHeq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 03:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbYDAHeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 03:34:37 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:58877 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbYDAHeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 03:34:36 -0400
Message-ID: <47F1E534.7050803@cs.helsinki.fi>
Date: Tue, 01 Apr 2008 10:33:08 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Artem Bityutskiy <dedekind@yandex.ru>
CC: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
Subject: Re: [RFC PATCH 25/26] UBIFS: add debugging stuff
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com>       <1206629746-4298-26-git-send-email-Artem.Bityutskiy@nokia.com> <84144f020803311400s1f34420dx153d197f4752c65e@mail.gmail.com> <47F1D44A.8010908@yandex.ru>
In-Reply-To: <47F1D44A.8010908@yandex.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Artem,

Artem Bityutskiy wrote:
> Well, I do not see a big reason not to get rid of this harmless stuff.
> Many kernel subsystems have their debugging, why not? Using BUG_ON() is
> OK in few most important places. But we want to have more assertions
> which are compiled-out by default, why can't we?. Similar is for prints.

Why would you want to have assertions that are compiled out by default? 
Either you handle the error or don't (and have an assertion). The reason 
some subsystems have had their own asserts is because they go overboard 
with defensive checks as they haven't bothered to think through a 
reasonable error handling strategy. The downside? It clutters the code 
and causes the (compiled out) assertions to bit-rot.

Note that they're also a total pain in the ass to enable for anyone not 
intimately familiar with your code. Not to mention you're now making the 
lives of those crazy embedded folks that disable CONFIG_BUG for smaller 
kernel size harder as well.

Do you know why we don't have compiled out asserts in the core kernel? 
That's because it simply can't just roll-over and die if something 
unexpected happens and your filesystem shouldn't probably do that 
either. Sure, if you have some debugging checks that are way too 
expensive for production use, you might want to have a 
CONFIG_UBIFS_DEBUG but that shouldn't happen at assertion level but 
rather at much higher level.

And btw, for optional printks, we have a lot of tracing infrastructure 
in the kernel already (kprobes, relayfs, ftrace probably soon), so if 
you want to have tracing for UBIFS (you probably don't), don't invent 
your mechanism. But for most printks, they're either useful or they're 
not. Again, I do see the potential need for CONFIG_UBIFS_DEBUG here, but 
doing that at printk-level is also too low-level.

			Pekka
