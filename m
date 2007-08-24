Return-Path: <linux-kernel-owner+w=401wt.eu-S1758758AbXHXUZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758758AbXHXUZa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 16:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbXHXUZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 16:25:22 -0400
Received: from main.gmane.org ([80.91.229.2]:58093 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbXHXUZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 16:25:21 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: RFC: issues concerning the next NAPI interface
Date: Fri, 24 Aug 2007 13:24:57 -0700
Organization: Linux Foundation
Message-ID: <20070824132457.3207b8de@freepuppy.rosehill.hemminger.net>
References: <8VHRR-45R-17@gated-at.bofh.it>
	<8VKwj-8ke-27@gated-at.bofh.it>
	<E1IOeSm-0000bm-Jo__24045.532072387$1187982363$gmane$org@be1.lrz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 069-064-229-129.pdx.net
In-Reply-To: <E1IOeSm-0000bm-Jo__24045.532072387$1187982363$gmane$org@be1.lrz>
X-Newsreader: Claws Mail 2.10.0 (GTK+ 2.10.14; x86_64-redhat-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2007 21:04:56 +0200
Bodo Eggert <7eggert@gmx.de> wrote:

> Linas Vepstas <linas@austin.ibm.com> wrote:
> > On Fri, Aug 24, 2007 at 03:59:16PM +0200, Jan-Bernd Themann wrote:
> 
> >> 3) On modern systems the incoming packets are processed very fast. Especially
> >> on SMP systems when we use multiple queues we process only a few packets
> >> per napi poll cycle. So NAPI does not work very well here and the interrupt
> >> rate is still high.
> > 
> > I saw this too, on a system that is "modern" but not terribly fast, and
> > only slightly (2-way) smp. (the spidernet)
> > 
> > I experimented wih various solutions, none were terribly exciting.  The
> > thing that killed all of them was a crazy test case that someone sprung on
> > me:  They had written a worst-case network ping-pong app: send one
> > packet, wait for reply, send one packet, etc.
> > 
> > If I waited (indefinitely) for a second packet to show up, the test case
> > completely stalled (since no second packet would ever arrive).  And if I
> > introduced a timer to wait for a second packet, then I just increased
> > the latency in the response to the first packet, and this was noticed,
> > and folks complained.
> 
> Possible solution / possible brainfart:
> 
> Introduce a timer, but don't start to use it to combine packets unless you
> receive n packets within the timeframe. If you receive less than m packets
> within one timeframe, stop using the timer. The system should now have a
> decent response time when the network is idle, and when the network is
> busy, nobody will complain about the latency.-)

I expect the overhead of OS timers and resolution makes this unsuitable for fast
networks. You need the hardware to do it. On slow networks, it doesn't matter.

-- 
Stephen Hemminger <shemminger@linux-foundation.org>

