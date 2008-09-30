Return-Path: <linux-kernel-owner+w=401wt.eu-S1753083AbYI3Jpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbYI3Jpu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 05:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbYI3Jpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 05:45:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43984 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099AbYI3Jpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 05:45:41 -0400
Date: Tue, 30 Sep 2008 11:45:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/6] Unified trace buffer
Message-ID: <20080930094516.GA1276@elte.hu>
References: <20080930030236.230994826@goodmis.org> <20080930030652.100327014@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080930030652.100327014@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0003]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> +void ring_buffer_lock(struct ring_buffer *buffer, unsigned long *flags)
> +{
> +	struct ring_buffer_per_cpu *cpu_buffer;
> +	int cpu;
> +
> +	local_irq_save(*flags);
> +
> +	for_each_buffer_cpu(buffer, cpu) {
> +		cpu_buffer = buffer->buffers[cpu];
> +		spin_lock(&cpu_buffer->lock);
> +	}
> +}

hm, that's rather unintelligent and needs to be fixed.

	Ingo
