Return-Path: <linux-kernel-owner+w=401wt.eu-S932326AbZHUOrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326AbZHUOrf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 10:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932227AbZHUOre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 10:47:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54508 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932161AbZHUOrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 10:47:33 -0400
Date: Fri, 21 Aug 2009 16:47:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Josh Stone <jistone@redhat.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, mbligh@google.com, lizf@cn.fujitsu.com,
       Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH v2 1/2] tracing: Move tracepoint callbacks into DEFINE
Message-ID: <20090821144707.GB16810@elte.hu>
References: <1250580227-24363-1-git-send-email-jistone@redhat.com> <1250795373-32363-1-git-send-email-jistone@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250795373-32363-1-git-send-email-jistone@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Josh Stone <jistone@redhat.com> wrote:

> It's not strictly correct for the tracepoint reg/unreg callbacks 
> to occur when a client is hooking up, because the actual 
> tracepoint may no be present yet.  This happens to be fine for 
> syscall, since that's in the core kernel, but it would cause 
> problems for tracepoints defined in a module that hasn't been 
> loaded yet.  It also means the reg/unreg has to be EXPORTed for 
> any modules to use the tracepoint (as in SystemTap).
> 
> This patch removes DECLARE_TRACE_WITH_CALLBACK, and instead 
> introduces DEFINE_TRACE_WITH_CALLBACK which stores the callbacks 
> in struct tracepoint.  The callbacks are used now when the active 
> state of the tracepoint changes in set_tracepoint & 
> disable_tracepoint.
> 
> This also introduces TRACE_EVENT_WITH_CALLBACK, so those events 
> can also provide callbacks if needed.

i think something shorter would be nicer, such as:

 DECLARE_TRACE_FN
 TRACE_EVENT_FN

	Ingo
