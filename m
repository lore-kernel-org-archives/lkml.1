Return-Path: <linux-kernel-owner+w=401wt.eu-S1756933AbYAOV1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933AbYAOV1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 16:27:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbYAOV1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 16:27:13 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:63064 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbYAOV1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 16:27:12 -0500
Date: Tue, 15 Jan 2008 16:27:08 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>
Subject: Re: [RFC PATCH 17/30 v3] initialize the clock source to jiffies
 clock.
In-Reply-To: <20080115211404.GB17439@Krystal>
Message-ID: <Pine.LNX.4.58.0801151621140.29090@gandalf.stny.rr.com>
References: <20080115204907.838227723@goodmis.org> <20080115205024.650312976@goodmis.org>
 <20080115211404.GB17439@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 15 Jan 2008, Mathieu Desnoyers wrote:
> >
> > This patch simply initializes the clock to use clocksource_jiffies, so
> > that any early user of clocksource_read will not crash.
> >
>
> Hrm, is it sane at all to use the jiffies as a clocksource at early
> boot? I thought it was updated by the timer interrupt, which is only
> activated late in the boot process.

It gives us a bogus value, but we know it's always there. This was
discovered in the -rt patch where we had a hard hang at early bootup.
Seems that the tracer was calling for a clock source before it was
initialized, and it called a null pointer.

The original fix was to just make a dummy timer source that returned zero.
But using jiffies seemed a better solution.

-- Steve
