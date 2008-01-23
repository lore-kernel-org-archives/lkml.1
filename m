Return-Path: <linux-kernel-owner+w=401wt.eu-S1756162AbYAWSLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbYAWSLn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 13:11:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037AbYAWSLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 13:11:34 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38683 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953AbYAWSLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 13:11:33 -0500
Subject: Re: [PATCH 19/20 -v5] Trace irq disabled critical timings
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, Jan Kiszka <jan.kiszka@siemens.com>,
       John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <20080123172712.GE18698@redhat.com>
References: <20080123160236.969334052@goodmis.org>
	 <20080123160444.197366580@goodmis.org> <20080123165353.GA12598@goodmis.org>
	 <20080123171107.GB12598@goodmis.org>  <20080123172712.GE18698@redhat.com>
Content-Type: text/plain
Date: Wed, 23 Jan 2008 18:58:23 +0100
Message-Id: <1201111103.6341.73.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-23 at 12:27 -0500, Frank Ch. Eigler wrote:
> Hi -
> 
> On Wed, Jan 23, 2008 at 12:11:07PM -0500, Steven Rostedt wrote:
> > This patch adds latency tracing for critical timings
> > (how long interrupts are disabled for).
> > [...]
> 
> Is there an opportunity here to share effort with latencytop, and
> ideally to use markers as much as possible for these event hooks?

I'm still thinking latencytop should only record stack traces and do the
rest in user-space. 

Also, the things the latency tracer and latecytop measure are quite
different. the latency tracer measures how long a non-schedulable
section is, latencytop measures how a task was scheduled away.

