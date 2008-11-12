Return-Path: <linux-kernel-owner+w=401wt.eu-S1753023AbYKLM7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbYKLM7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 07:59:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbYKLM7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 07:59:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:58084 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbYKLM7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 07:59:31 -0500
Date: Wed, 12 Nov 2008 07:59:28 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] tracing/fastboot: Use the ring-buffer timestamp for
 initcall entries
In-Reply-To: <20081112092548.GE4748@elte.hu>
Message-ID: <alpine.DEB.1.10.0811120757190.2529@gandalf.stny.rr.com>
References: <491A062A.8080406@gmail.com> <20081112092548.GE4748@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 12 Nov 2008, Ingo Molnar wrote:

> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Impact: Split the boot tracer entries in two parts: call and return
> > 
> > Now that we are using the sched tracer from the boot tracer, we want 
> > to use the same timestamp than the ring-buffer to have consistent 
> > time captures between sched events and initcall events. So we get 
> > rid of the old time capture by the boot tracer and split the 
> > initcall events in two parts: call and return. This way we have the 
> > ring buffer timestamp of both.
> > 
> > There is an example of a trace in attachment.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > ---
> >  include/trace/boot.h      |   31 ++++++++---
> >  init/main.c               |   32 ++++++------
> >  kernel/trace/trace.h      |   17 ++++--
> >  kernel/trace/trace_boot.c |  123 ++++++++++++++++++++++++++++++++++-----------
> >  4 files changed, 144 insertions(+), 59 deletions(-)
> 
> applied	to tip/tracing/fastboot, thanks	Frederic! 
> 
> one small detail, do we need these messages in the boot tracer:
> 
>   ##### CPU 1 buffer started ####
> 
> they are helpful for latency traces but might be confusing for boot 
> traces. (they lose their attraction after having seen a dozen of them)

Yeah, I was thinking of putting in a iter_ctrl to disable them. But then, 
should they be on or off by default?

The pro for having them off by default, they are not as distracting.

The con for having them off by default, they lose their meaning, and 
developers get confused when they see CPU 1 starting after 100 prints of 
CPU0, when they both should have started.

-- Steve

