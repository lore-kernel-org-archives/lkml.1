Return-Path: <linux-kernel-owner+w=401wt.eu-S1754437AbXDWWsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437AbXDWWsn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 18:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754439AbXDWWsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 18:48:43 -0400
Received: from gw.goop.org ([64.81.55.164]:57009 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754427AbXDWWsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 18:48:41 -0400
Message-ID: <462D37D2.3060208@goop.org>
Date: Mon, 23 Apr 2007 15:48:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       Juliusz Chroboczek <jch@pps.jussieu.fr>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Bill Davidsen <davidsen@tmr.com>, Willy Tarreau <w@1wt.eu>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
References: <20070420140457.GA14017@elte.hu> <200704220155.20856.kernel@kolivas.org> <20070421160008.GA28783@elte.hu> <200704220959.34978.kernel@kolivas.org> <87647oblx5.fsf@pps.jussieu.fr> <alpine.LFD.0.98.0704221620310.9964@woody.linux-foundation.org> <20070423013429.GB25162@wotan.suse.de> <alpine.LFD.0.98.0704230844410.9964@woody.linux-foundation.org> <20070423191143.GA16849@elte.hu> <alpine.LFD.0.98.0704231227300.9964@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0704231227300.9964@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> The "perfect" situation would be that when somebody goes to sleep, any 
> extra points it had could be given to whoever it woke up last. Note that 
> for something like X, it means that the points are 100% ephemeral: it gets 
> points when a client sends it a request, but it would *lose* the points 
> again when it sends the reply!
>
> So it would only accumulate "scheduling points" while multiuple clients 
> are actively waiting for it, which actually sounds like exactly the right 
> thing. However, I don't really see how to do it well, especially since the 
> kernel cannot actually match up the client that gave some scheduling 
> points to the reply that X sends back.
>   

This works out in quite an interesting way.  If the economy is closed -
all clients and servers are managed by the same scheduler - then the
server could get no inherent CPU priority and live entirely on donated
shares.  If that were the case, you'd have to make sure that the server
used the donation from client A on client A's work, otherwise you'd get
freeloaders - but maybe it will all work out.

It gets more interesting when you have a non-closed system - the X
server is working on behalf of external clients over TCP.  Presumably
wakeups from incoming TCP connections wouldn't have any scheduler shares
associated with it, so the X server would have to use its inherent CPU
allocation to service those requests.  Or the external client could
effectively end up freeloading off portions of the local clients' donations.

    J
