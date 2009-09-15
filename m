Return-Path: <linux-kernel-owner+w=401wt.eu-S1752955AbZIOLM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955AbZIOLM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 07:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbZIOLM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 07:12:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:52399 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbZIOLM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 07:12:27 -0400
Subject: Re: [patch, resend] x86, perf_counter, bts: optimize BTS overflow
 handling
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       markus.t.metzger@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <20090915130023.A16204@sedona.ch.intel.com>
References: <20090915130023.A16204@sedona.ch.intel.com>
Content-Type: text/plain
Date: Tue, 15 Sep 2009 13:12:25 +0200
Message-Id: <1253013145.5506.50.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Totally missed the first one, sorry for that :/

On Tue, 2009-09-15 at 13:00 +0200, Markus Metzger wrote:
> Draining the BTS buffer on a buffer overflow interrupt takes too long
> resulting in a kernel lockup when tracing the kernel.
> 
> Restructure perf_counter sampling into sample creation and sample
> output.
> Prepare a single reference sample for BTS sampling and update the from
> and to address fields when draining the BTS buffer.
> Drain the entire BTS buffer between a single perf_output_begin() /
> perf_output_end() pair.

Generally looks very nice, one thing though, why did you take regs out
of perf_sample_data, now you get to pass around one extra param..

> CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
> ---
>  arch/x86/kernel/cpu/perf_counter.c |   60 	37 +	23 -	0 !
>  include/linux/perf_counter.h       |   68 	64 +	4 -	0 !
>  kernel/perf_counter.c              |  306 	161 +	145 -	0 !
>  3 files changed, 262 insertions(+), 172 deletions(-)

What is that diffstat thing? I always get things like:

 kernel/sched.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


