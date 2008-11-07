Return-Path: <linux-kernel-owner+w=401wt.eu-S1755620AbYKGFpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620AbYKGFpu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 00:45:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754768AbYKGFoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 00:44:15 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:60927 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754746AbYKGFoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 00:44:14 -0500
Message-Id: <20081107052336.652868737@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 07 Nov 2008 00:23:36 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
Subject: [RFC patch 00/18] Trace Clock v2
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri,  7 Nov 2008 05:43:22 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've cleaned up the LTTng timestamping code, renamed it into "trace clock",
ripped apart the tsc_sync.c x86 code, added documentation (printk to the console
when the tracing clock is used) about what to do when an unsync TSC is detected.
I however kept the cache-line bouncing workaround for now. However, I now
synchronize the counters every jiffy with a per-cpu timer so it gives an upper
bound to the time imprecision.

The trace clock works with a trace_clock_get()/put(), so all the mechanic and
overhead that might be required to provide correct timestamps on weird systems
is *only* enabled when tracing is active.

I plan to stick to this simple solution for now so we can get reliable tracing
for 95ish% of systems out there, and to keep room for improvement (nice NTP-like
schemes) for a later version. (sadly, given this is actually v2, I cannot say
"let's keep that for v2") ;)

This patchset applies on top of 2.6.28-rc3.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
