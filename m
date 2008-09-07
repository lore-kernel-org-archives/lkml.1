Return-Path: <linux-kernel-owner+w=401wt.eu-S1755098AbYIGLBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098AbYIGLBZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 07:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbYIGLBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 07:01:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41849 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753127AbYIGLBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 07:01:15 -0400
Date: Sun, 7 Sep 2008 04:00:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       davej@codemonkey.org.uk, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jack Steiner <steiner@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 07/13] sched: Reduce stack size requirements in
 kernel/sched.c
Message-Id: <20080907040009.611ac986.akpm@linux-foundation.org>
In-Reply-To: <1220783087.8687.73.camel@twins.programming.kicks-ass.net>
References: <20080906235036.891970000@polaris-admin.engr.sgi.com>
	<20080906235037.880702000@polaris-admin.engr.sgi.com>
	<1220783087.8687.73.camel@twins.programming.kicks-ass.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 07 Sep 2008 12:24:47 +0200 Peter Zijlstra <peterz@infradead.org> wrote:

> get_online_cpus() can sleep, but you just disabled preemption with those
> get_cpumask_var() horribles!

make cpu_hotplug.refcount an atomic_t.

> Couldn't be arsed to look through the rest, but I really hate this
> cpumask_ptr() stuff that relies on disabling preemption.

that's harder to fix ;)
