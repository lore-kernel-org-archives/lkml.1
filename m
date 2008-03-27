Return-Path: <linux-kernel-owner+w=401wt.eu-S1759945AbYC0NbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759945AbYC0NbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 09:31:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758371AbYC0NaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 09:30:22 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:45324 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757974AbYC0NaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 09:30:20 -0400
Message-Id: <20080327132057.449831367@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 27 Mar 2008 09:20:57 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch for 2.6.26 0/7] Architecture Independent Markers
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 27 Mar 2008 13:30:13 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

After a few RFC rounds, I propose these markers for 2.6.26. They include
work done after comments from the memory management community. Most of them have
been used by the LTTng project for about 2 years.

The first patch in the patchset does a small addition to the markers API : it
allows marker sites to declare a _trace_mark marker. I forces use of a marker
which does not rely on an instruction modification mechanism to enable itself.
It's required in some kernel code paths (lockdep, printk, some traps, __init and
__exit code). I would prefer to get this in before the immediate values, since
the immediate values optimization, which depends on the rework of x86
alternatives, paravirt and kprobes currently being merged, takes longer than
expected.

I do not expect this marker set to cover every bits of the kernel (and this is
not its purpose). It's just a good start that has proven to be very useful to
the LTTng community in the past 2 years.

This patchset applies over 2.6.25-rc7 in this order :

markers-define-non-optimized-marker.patch
lttng-instrumentation-fs.patch
lttng-instrumentation-ipc.patch
lttng-instrumentation-kernel.patch
lttng-instrumentation-mm.patch
lttng-instrumentation-net.patch
lttng-instrumentation-lib.patch

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
