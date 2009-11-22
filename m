Return-Path: <linux-kernel-owner+w=401wt.eu-S1753981AbZKVBqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbZKVBqt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 20:46:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbZKVBqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 20:46:48 -0500
Received: from tomts36.bellnexxia.net ([209.226.175.93]:63128 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752903AbZKVBqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 20:46:48 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArcEAE8kCEtGGN1W/2dsb2JhbACBTNFnhDwEgXA
Date: Sat, 21 Nov 2009 20:46:53 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       rostedt@goodmis.org, andi@firstfloor.org, roland@redhat.com,
       rth@redhat.com
Subject: Re: [RFC PATCH 2/6] jump label v3 - x86: Introduce generic jump
	patching without stop_machine
Message-ID: <20091122014652.GA29217@Krystal>
References: <cover.1258580048.git.jbaron@redhat.com> <37e397b27509c378f93b9a30f1158791d1b99be7.1258580048.git.jbaron@redhat.com> <4B071000.9080408@zytor.com> <4B072EF5.2090402@redhat.com> <20091121162145.GE12100@Krystal> <4B0861D4.7030702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4B0861D4.7030702@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 20:33:52 up 95 days, 12:23,  4 users,  load average: 0.59, 0.22,
	0.13
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu (mhiramat@redhat.com) wrote:
> Mathieu Desnoyers wrote:
> > We should really do performance benchmarks comparing stop_machine() and
> > the int3-based approach rather than to try to come up with tricky
> > schemes. It's not a real problem until we prove there is indeed a
> > performance regression. I suspect that the combined effect of cache-line
> > bouncing, worker thread overhead and the IPI of stop_machine is probably
> > comparable to the two IPIs we propose for int3.
> 
> I assume that total latency of XMC is almost same on normal-size SMP.
> However,
> - stop_machine() can't support NMI/SMI.
> - stop_machine() stops all other processors while XMC.

I would also add that stop_machine() increases the system interrupt
latency of an amount O(num_online_cpus()), which I'd like to avoid given
the 90- to 128-core machines heading our way pretty quickly.

> 
> Anyway, int3-based approach still needs to be ensured its safeness
> by processor architects. So, until that, stop_machine() approach
> also useful for some cases.

True. This makes me think: If performance happens to be a problem, we
could do batched jump instruction modification. Using an hash table to
contain the pointers would allow us to only perform a single pair of IPI
for a whole bunch of instruction modifications.

Mathieu

> 
> Thank you,
 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
