Return-Path: <linux-kernel-owner+w=401wt.eu-S1752835AbZIXPDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbZIXPDd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 11:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbZIXPDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 11:03:32 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:39104 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752244AbZIXPDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 11:03:32 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqIEAD4nu0pMROOX/2dsb2JhbACBUtYBhBsF
Date: Thu, 24 Sep 2009 11:03:33 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [patch 12/12] Tracepoints - Immediate Values
Message-ID: <20090924150333.GA26389@Krystal>
References: <20090924132626.485545323@polymtl.ca> <20090924133400.830759403@polymtl.ca> <1253803872.18939.28.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1253803872.18939.28.camel@laptop>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 10:57:35 up 37 days,  1:47,  2 users,  load average: 0.27, 0.26,
	0.25
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Thu, 2009-09-24 at 09:26 -0400, Mathieu Desnoyers wrote:
> > plain text document attachment (tracepoints-immediate-values.patch)
> > Use immediate values in tracepoints.
> 
> I might have missed it, but did both the Intel and AMD cpu folks clear
> the SMP code rewrite bits?
> 

SMP handling is performed with stop_machine() in this patchset. Nothing
fancy here.

I've got other patches, not included in this patchset, which implements
nmi-safe code modification, based on a scheme using breakpoints and
IPIs, inspired from djprobes. That one might be worth clearing with
intel/amd devs before merging.

However, doing code patching within stop_machine() is pretty safe, given
all other CPUs are busy-looping with interrupts off while this happens.
Ftrace already does this.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
