Return-Path: <linux-kernel-owner+w=401wt.eu-S1030781AbXDPPzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030781AbXDPPzh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 11:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030782AbXDPPzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 11:55:37 -0400
Received: from zcars04f.nortel.com ([47.129.242.57]:51577 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030781AbXDPPzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 11:55:36 -0400
Message-ID: <46239C62.4090302@nortel.com>
Date: Mon, 16 Apr 2007 09:55:14 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>
CC: Willy Tarreau <w@1wt.eu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       hui Bill Huey <billh@gnuppy.monkey.org>, Ingo Molnar <mingo@elte.hu>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Peter Williams <pwil3058@bigpond.net.au>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <20070415051645.GA28438@gnuppy.monkey.org> <20070415084447.GC24886@elte.hu> <20070415095146.GA30327@gnuppy.monkey.org> <84144f020704150339i4a0d437fja6868ab671558ba1@mail.gmail.com> <20070415124527.GP943@1wt.eu> <20070415152643.GH8915@holomorphy.com>
In-Reply-To: <20070415152643.GH8915@holomorphy.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Apr 2007 15:55:19.0244 (UTC) FILETIME=[A1FE48C0:01C7803F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:

> The sorts of like explicit decisions I'd like to be made for these are:
> (1) In a mixture of tasks with varying nice numbers, a given nice number
> 	corresponds to some share of CPU bandwidth. Implementations
> 	should not have the freedom to change this arbitrarily according
> 	to some intention.

The first question that comes to my mind is whether nice levels should 
be linear or not.  I would lean towards nonlinear as it allows a wider 
range (although of course at the expense of precision).  Maybe something 
like "each nice level gives X times the cpu of the previous"?  I think a 
value of X somewhere between 1.15 and 1.25 might be reasonable.

What about also having something that looks at latency, and how latency 
changes with niceness?

What about specifying the timeframe over which the cpu bandwidth is 
measured?  I currently have a system where the application designers 
would like it to be totally fair over a period of 1 second.  As you can 
imagine, mainline doesn't do very well in this case.

Chris



