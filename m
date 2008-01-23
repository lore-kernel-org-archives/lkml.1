Return-Path: <linux-kernel-owner+w=401wt.eu-S1757046AbYAWRqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046AbYAWRqA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 12:46:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754323AbYAWRpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 12:45:52 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:42970 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759AbYAWRpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 12:45:51 -0500
Date: Wed, 23 Jan 2008 12:45:45 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Frank Ch. Eigler" <fche@redhat.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, Jan Kiszka <jan.kiszka@siemens.com>,
       John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 19/20 -v5] Trace irq disabled critical timings
In-Reply-To: <20080123172712.GE18698@redhat.com>
Message-ID: <Pine.LNX.4.58.0801231241090.13236@gandalf.stny.rr.com>
References: <20080123160236.969334052@goodmis.org> <20080123160444.197366580@goodmis.org>
 <20080123165353.GA12598@goodmis.org> <20080123171107.GB12598@goodmis.org>
 <20080123172712.GE18698@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 23 Jan 2008, Frank Ch. Eigler wrote:
> On Wed, Jan 23, 2008 at 12:11:07PM -0500, Steven Rostedt wrote:
> > This patch adds latency tracing for critical timings
> > (how long interrupts are disabled for).
> > [...]
>
> Is there an opportunity here to share effort with latencytop, and
> ideally to use markers as much as possible for these event hooks?

Well, I just found out about latencytop a couple of days ago when Arjan
announced it. I took a quick look and it seems to be more of a general
collection of information. This tracer pinpoints out specific maxes.
Although I may be wrong (I have to admit, I haven't had the time to really
look at what LatencyTop does, but I have been using this tracer in -rt for
a number of years).

As for using markers, I just piggied back on top of lockdep, since it has
the same hooks that I needed. If we were to replace them with markers,
then I would say lockdep should use the markers too.

One thing about markers, only one probe may be allowed at a time. Perhaps
we should fix this by using something like I did with the mcount hook.

-- Steve

