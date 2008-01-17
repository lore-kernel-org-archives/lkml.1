Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbYAQCwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbYAQCwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 21:52:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbYAQCwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 21:52:13 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:61753 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbYAQCwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 21:52:12 -0500
Date: Wed, 16 Jan 2008 21:51:57 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: john stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>, Paul Mackerras <paulus@samba.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [RFC PATCH 16/22 -v2] add get_monotonic_cycles
In-Reply-To: <20080117024000.GD2322@Krystal>
Message-ID: <Pine.LNX.4.58.0801162150490.20257@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0801151658190.29090@gandalf.stny.rr.com>
 <20080115220824.GB22242@Krystal> <Pine.LNX.4.58.0801151717250.29090@gandalf.stny.rr.com>
 <20080116031730.GA2164@Krystal> <Pine.LNX.4.58.0801152238130.19680@gandalf.stny.rr.com>
 <20080116145604.GB31329@Krystal> <1f1b08da0801161436k4a7ac1e3kd83590951e7bebb9@mail.gmail.com>
 <1200523867.6127.5.camel@localhost.localdomain>
 <Pine.LNX.4.58.0801161827450.17781@gandalf.stny.rr.com>
 <1200536889.6127.52.camel@localhost.localdomain> <20080117024000.GD2322@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 16 Jan 2008, Mathieu Desnoyers wrote:
> >
> > Yep. clocksource_get_cycles() ended up not being as useful as an helper
> > function (I was hoping the arch vsyscall implementations could use it,
> > but they've done too much optimization - although that may reflect a
> > need up the chain to the clocksource structure).
> >
>
> The problem with vsyscall is that we will have a hard time disabling
> preemption :( Therefore, insuring that the read of the data is done in a
> timely manner is hard to do.

You'll have more than a hard time disabling preemption for vsyscall. We'll
need to come up with a better solution then. vsyscall can not modify any
kernel memory, nor can it disable preemption.

-- Steve

