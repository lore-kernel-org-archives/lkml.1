Return-Path: <linux-kernel-owner+w=401wt.eu-S1760254AbYDQSwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760254AbYDQSwY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 14:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbYDQSwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 14:52:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35242 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603AbYDQSwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 14:52:14 -0400
Date: Thu, 17 Apr 2008 20:51:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Message-ID: <20080417185158.GA26603@elte.hu>
References: <20080416202338.GA6007@elte.hu> <20080417002552.5742ad65.akpm@linux-foundation.org> <84144f020804170045s24cbb802u3358ec6b5d391a10@mail.gmail.com> <20080417012051.ed56f4ab.akpm@linux-foundation.org> <Pine.LNX.4.64.0804171130090.4929@sbz-30.cs.Helsinki.FI> <84144f020804170134k4c98f022xc247442592fb1a44@mail.gmail.com> <20080417014217.ab0453a9.akpm@linux-foundation.org> <20080417114900.GA17033@infradead.org> <20080417110135.08b076ac.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080417110135.08b076ac.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> afaik the sysprof-vs-oprofile issue still hasn't been settled.  Maybe 
> it's no longer a relevant question with the new code - I just don't 
> know. Everything went all quiet and then this stuff happened.

i dont think there's any big issue here. Sysprof is a time and stack 
system-wide tracer/profiler, oprofile profiles CPU events - deep 
stacktracing is an afterthought there. And how do you set up oprofile to 
do precise time events?

with sysprof you can do:

  cd /sys/kernel/debug/tracing
  echo sysprof > current_tracer
  cat trace_pipe

and you'll see the trace events go by, live. The user-space bits of 
sysprof have been ported over to ftrace/sysprof already and it's a 
really nice tool that shows a deep stack-trace based hierarchical 
"vertical" profile instead of the usual finegrained profile.

It certainly helps that the author of the tracer plugin (Soeren 
Sandmann) is the author of the userspace app too - so there's a rather 
well-working feedback loop here ;-)

With oprofile all these things are rather indirect, the API is more 
complex, it forces per-CPU buffers, etc. etc. I think for 
instrumentation the driving force must be usability, and sysprof/ftrace 
is hands down more usable - to me at least.

	Ingo
