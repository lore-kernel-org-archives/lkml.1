Return-Path: <linux-kernel-owner+w=401wt.eu-S1755946AbZC0JdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbZC0JdU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 05:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754576AbZC0JdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 05:33:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:49663 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949AbZC0JdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 05:33:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,431,1233561600"; 
   d="scan'208";a="501272144"
Date: Fri, 27 Mar 2009 09:43:20 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, oleg@redhat.com, juan.villacis@intel.com,
       ak@linux.jf.intel.com
Subject: [patch 0/14] x86, ptrace, bts, hw-branch-tracer: bug fixes and cleanups
Message-ID: <20090327094320.A10628@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A bug in the ptrace bts extension may cause a kernel crash.

When the ptracer exits, it stops branch tracing for all ptraced tasks
and frees the branch trace buffer. If the traced tasks are currently
running, the branch trace buffer may be freed before the cpu running
that task has stopped tracing, thus overwriting memory with branch
trace data.

Patches 1-4 fix this problem by having the tracer wait for the tracee
to become inactive. This ensures that the cpu has stopped tracing that task.

The bug affects the .29 kernel.


The rest of the patches are for tip/tracing/hw-branch-tracing only.
Patches 5 and 6 fix boot problems caused by the hw-branch-tracer
selftests reported by Ingo Molnar (thanks for reporting the problems).
Patch 8 fixes a bug in the selftest.
Patches 9 and 10 add more selftests.
Patches 7, 11 - 13 are cleanup.
Patch 14 adds support for Core i7.
---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

