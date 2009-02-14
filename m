Return-Path: <linux-kernel-owner+w=401wt.eu-S1758747AbZBNANu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747AbZBNANu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 19:13:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbZBNANl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 19:13:41 -0500
Received: from ozlabs.org ([203.10.76.45]:41820 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364AbZBNANk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 19:13:40 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18838.3244.453480.752915@cargo.ozlabs.ibm.com>
Date: Sat, 14 Feb 2009 11:13:32 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] Make context switch and migration software counters
	work again
In-Reply-To: <20090213112333.GE15679@elte.hu>
References: <18837.21802.429822.796289@cargo.ozlabs.ibm.com>
	<20090213112333.GE15679@elte.hu>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> Agreed. Right now we do have some context-switching overhead for
> inherited counters, clearly visible in context-switch intense
> workloads if they are run via perfstat, so it would be very nice
> to optimize this some more.

Yes, that's one of the complaints I have heard from performance tool
developers, that the context switch overhead of perf_counters is too
high (and specifically, higher than perfmon2/3).  We do a lot of work
on each context switch updating counter values (involving a couple of
atomic operations per counter), setting counter states etc., and (on
POWER) computing PMU configurations, that either isn't really
necessary or could be cached.  Also, it might be useful to do lazy PMU
switching like we do with the FPU to reduce the overhead further when
only one task is using the PMU.  That's all going to make the code
more complex, though. :)

Paul.
