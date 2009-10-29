Return-Path: <linux-kernel-owner+w=401wt.eu-S1752651AbZJ2JT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbZJ2JT3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 05:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbZJ2JT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 05:19:27 -0400
Received: from mail.gmx.net ([213.165.64.20]:34318 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752303AbZJ2JT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 05:19:26 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19AVRxpNPFAdR2Rs3cc/D2b00MLAfRnnkj+wsm8y7
	8Rx1R0Mw+RucLq
Subject: Re: [patch] Re: [regression bisect -next] BUG: using
 smp_processor_id() in preemptible [00000000] code: rmmod
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       hpa@zytor.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <20091029091411.GE22963@elte.hu>
References: <1256784158.2848.8.camel@dhcp231-106.rdu.redhat.com>
	 <1256805552.7158.22.camel@marge.simson.net>
	 <20091029091411.GE22963@elte.hu>
Content-Type: text/plain
Date: Thu, 29 Oct 2009 10:19:27 +0100
Message-Id: <1256807967.7158.58.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.73
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-29 at 10:14 +0100, Ingo Molnar wrote:

> hm, the problem is kthread_bind(). It is rummaging around in scheduler 
> internals without holding the runqueue lock - and this now got exposed. 
> Even though it is operating on (supposedly ...) inactive tasks, the guts 
> of that function should be moved into sched.c and it should be fixed to 
> have proper locking.

Yeah, I was thinking that nobody should ever be able to hit that without
it being a bug.. but wimped out.

	-Mike

