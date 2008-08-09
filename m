Return-Path: <linux-kernel-owner+w=401wt.eu-S1754243AbYHIPBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243AbYHIPBz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 11:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbYHIPBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 11:01:47 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:3956 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbYHIPBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 11:01:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=prh5dzTdQ+AJCZPTaqH8HS7qsbWPtZ0+zYT64CgyehtXj8++AUDer7Citbl2f9kS0X
         OGV0itwj9fjWc+f3YqEjE5iv5gYUpMaYtKfZA3qWu+S66upTJPI/OuLN/lLK9uPkppIi
         HL3Lqt8C9W/w4Ooo5yQPnwFXqDd7WiAd57yZA=
Message-ID: <863e9df20808090801p7f9e11bar84d0e661440d591e@mail.gmail.com>
Date: Sat, 9 Aug 2008 20:31:45 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH 0/5] ftrace: to kill a daemon
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "David Miller" <davem@davemloft.net>,
       "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
       "Roland McGrath" <roland@redhat.com>,
       "Ulrich Drepper" <drepper@redhat.com>,
       "Rusty Russell" <rusty@rustcorp.com.au>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Gregory Haskins" <ghaskins@novell.com>,
       "Arnaldo Carvalho de Melo" <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       "Clark Williams" <williams@redhat.com>
In-Reply-To: <alpine.DEB.1.10.0808090854170.24140@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080807182013.984175558@goodmis.org>
	 <863e9df20808090248h3adc2ac3mdb3217fe2876ab3b@mail.gmail.com>
	 <alpine.DEB.1.10.0808090854170.24140@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 9, 2008 at 6:31 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> Dynamically modifying text that might be in the pipeline on another CPU
> may or may not be dangerous on all archs.

Kprobes leaves this mess for individual archs to handle (see
arch_arm_kprobe). What would be nice to have is an explanation as to
which archs are safe from this and under what conditions. Also, for
!SMP, this boot-time patching approach and the associated build time
paraphernalia would simply be a bloat. There we can simply have a
daemonless ftrace which patches mcount sites synchronously. Why not
let each arch have this hinge on CONFIG_SMP?

> The fix here is to convert the mcount calls to nops at boot up. This is
> really ideal on all archs. This means we know ever mcount call, and we get
> rid of the requirement that we need to run the code once before we can
> trace it.

This solution indeed would fit all archs well but for some it may be
an overkill (or is it?...I'd like to know that :-\ ).

Oh and as you pointed out, it would mean that we have to no longer run
the code before starting to trace it. But why don't we do that now?
How about calling the tracer from ftrace_record_ip? All we need to do
is pass along the parent_ip from mcount.

> The kstop_machine is now only left at the start and stop of tracing.

This a nice fix. I'm just looking to find out what the self modifying
code problem here translates to on different archs for my own
understanding :-)

Thanks,
Abhishek Sagar
