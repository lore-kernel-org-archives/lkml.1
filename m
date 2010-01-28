Return-Path: <linux-kernel-owner+w=401wt.eu-S1754505Ab0A1A3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab0A1A3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 19:29:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754235Ab0A1A3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 19:29:23 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56967 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191Ab0A1A3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 19:29:22 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 28 Jan 2010 09:26:00 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, rientjes@google.com,
       minchan.kim@gmail.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH v3] oom-kill: add lowmem usage aware oom kill handling
Message-Id: <20100128092600.95e044f7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100128001636.2026a6bc@lxorguk.ukuu.org.uk>
References: <20100121145905.84a362bb.kamezawa.hiroyu@jp.fujitsu.com>
	<20100122152332.750f50d9.kamezawa.hiroyu@jp.fujitsu.com>
	<20100125151503.49060e74.kamezawa.hiroyu@jp.fujitsu.com>
	<20100126151202.75bd9347.akpm@linux-foundation.org>
	<20100127085355.f5306e78.kamezawa.hiroyu@jp.fujitsu.com>
	<20100126161952.ee267d1c.akpm@linux-foundation.org>
	<20100127095812.d7493a8f.kamezawa.hiroyu@jp.fujitsu.com>
	<20100128001636.2026a6bc@lxorguk.ukuu.org.uk>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for comment. But I stoppped this already....

On Thu, 28 Jan 2010 00:16:36 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > Now, /proc/<pid>/oom_score and /proc/<pid>/oom_adj are used by servers.
> 
> And embedded, and some desktops (including some neat experimental hacks
> where windows slowly get to be bigger bigger oom targes the longer
> they've been non-focussed)
> 
Sure.

> > For my customers, I don't like oom black magic. I'd like to recommend to
> > use memcg, of course ;) But lowmem oom cannot be handled by memcg, well.
> > So I started from this. 
> 
> I can't help feeling this is the wrong approach. IFF we are running out
> of low memory pages then killing stuff for that reason is wrong to begin
> with except in extreme cases and those extreme cases are probably also
> cases the kill won't help.
> 
> If we have a movable user page (even an mlocked one) then if there is
> space in other parts of memory (ie the OOM is due to a single zone
> problem) we should *never* be killing in the first place, we should be
> moving the page. The mlock case is a bit hairy but the non mlock case is
> exactly the same sequence of operations as a page out and page in
> somewhere else skipping the widdling on the disk bit in the middle.
> 
> There are cases we can't do that - eg if the kernel has it pinned for
> DMA, but in that case OOM isn't going to recover the page either - at
> least not until the DMA or whatever unpins it (at which point you could
> just move it).
> 
> Am I missing something fundamental here ?
> 

I just wanted to make oom-killer shouldn't kill sshd or X-serivce or
task launcher IOW, oom-killer shouldn't do not-reasonalble selection.

If lowmem user is killed, I'll be satisfied with the cace "Oh, the process
is killed because lowmem was in short and it used lowmem, Hmmm..." and
never be satisfied with the cace "Ohch!, F*cking OOM killer killed X-server
and 10s of innocent processes!!!".

But year, I stop this. For me, panic_on_oom=1 is all and enough.

Thanks,
-Kame

