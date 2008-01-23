Return-Path: <linux-kernel-owner+w=401wt.eu-S1756680AbYAWSSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680AbYAWSSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 13:18:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbYAWSSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 13:18:34 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:63122 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbYAWSSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 13:18:33 -0500
Date: Wed, 23 Jan 2008 13:18:19 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Daniel Walker <dwalker@mvista.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 01/20 -v5] printk - dont wakeup klogd with interrupts
 disabled
In-Reply-To: <1201110185.13596.22.camel@imap.mvista.com>
Message-ID: <Pine.LNX.4.58.0801231315500.6127@gandalf.stny.rr.com>
References: <20080123160236.969334052@goodmis.org>  <20080123160441.236562634@goodmis.org>
  <1201107978.13596.16.camel@imap.mvista.com>  <Pine.LNX.4.58.0801231213430.12932@gandalf.stny.rr.com>
 <1201110185.13596.22.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 23 Jan 2008, Daniel Walker wrote:

>
> > 	if (wake_klogd && !runqueue_is_locked())
> > 		wake_up_klogd();
> >
> > This probably is the cleanest solution since it simply prevents the
> > deadlock from occurring.
>
> Do you really need to call it with the runqueue lock held .. There are
> other issue with the calls at that level.. For instance in -rt these
> call can actually hang the system in the console laying from inside
> printk (something I reported more than 6 months ago) .. It would be
> better to move them around the scheduler rather than inside it..

The wakeup hook in schedule is when we find out that we hit our max. I
could postpone that somehow, but that would require more glue code than I
would like to add.

As for -rt, we've disabled printk for consoles not ATOMIC safe. So the
only consoles that will print in atomic sections so far are, earlyprintk
and the VGA.

Tim, could you send me your "postponed print" patches. That sounds like
something the -rt patch could use.

Thanks,

-- Steve

