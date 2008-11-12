Return-Path: <linux-kernel-owner+w=401wt.eu-S1752827AbYKLJ0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbYKLJ0K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 04:26:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbYKLJZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 04:25:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53891 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbYKLJZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 04:25:56 -0500
Date: Wed, 12 Nov 2008 10:25:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] tracing/fastboot: Use the ring-buffer timestamp
	for initcall entries
Message-ID: <20081112092548.GE4748@elte.hu>
References: <491A062A.8080406@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491A062A.8080406@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Impact: Split the boot tracer entries in two parts: call and return
> 
> Now that we are using the sched tracer from the boot tracer, we want 
> to use the same timestamp than the ring-buffer to have consistent 
> time captures between sched events and initcall events. So we get 
> rid of the old time capture by the boot tracer and split the 
> initcall events in two parts: call and return. This way we have the 
> ring buffer timestamp of both.
> 
> There is an example of a trace in attachment.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  include/trace/boot.h      |   31 ++++++++---
>  init/main.c               |   32 ++++++------
>  kernel/trace/trace.h      |   17 ++++--
>  kernel/trace/trace_boot.c |  123 ++++++++++++++++++++++++++++++++++-----------
>  4 files changed, 144 insertions(+), 59 deletions(-)

applied	to tip/tracing/fastboot, thanks	Frederic! 

one small detail, do we need these messages in the boot tracer:

  ##### CPU 1 buffer started ####

they are helpful for latency traces but might be confusing for boot 
traces. (they lose their attraction after having seen a dozen of them)

	Ingo
