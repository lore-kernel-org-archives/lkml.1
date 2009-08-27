Return-Path: <linux-kernel-owner+w=401wt.eu-S1751941AbZH0JFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941AbZH0JFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 05:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbZH0JFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 05:05:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:50420 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbZH0JFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 05:05:52 -0400
Subject: Re: [PATCH] perf: remove PERF_SAMPLE_RAW
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090827084321.GD2131@elte.hu>
References: <1251361073.18584.46.camel@twins>
	 <20090827084321.GD2131@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 27 Aug 2009 11:04:33 +0200
Message-Id: <1251363873.18584.49.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-27 at 10:43 +0200, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > Apparently people think trace-events became an ABI the moment perf 
> > exported them, regardless what the text surrounding 
> > PERF_SAMPLE_RAW said about the opaqueness of the data provided.
> 
> Well it's still opaque and the descriptor of what it means is in 
> debugfs so it's not an ABI as the comment says.

Clearly people their expectations didn't match this.

> > I'm not willing to make anything trace related into an ABI, hence 
> > remove this.
> 
> This removes quite a bit of nice functionality we already have, so i 
> think it's (way) too heavy handed.
> 
> I think what we want is the golden middle: a per tracepoint 
> property. I.e. we would provide:
> 
>     TRACE_EVENT_STABLE()
> 
> or TRACE_EVENT_CORE() or TRACE_EVENT_ABI() - which carries a 'will 
> maintain this as an ABI' promise from the maintainer who adds it.
> 
> Also, tracepoints are a unidirectional channel of information - in 
> practice those are way easier to handle as an ABI than other ABIs 
> such as behavior, semantics, etc. So i'd expect there to be a 
> healthy set of 'stable' tracepoints.

Whatever works for people really, I just want this discussed. I'm not at
all ready to have everything TRACE_EVENT() declared an ABI as it stands
now.
