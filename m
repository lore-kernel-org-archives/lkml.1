Return-Path: <linux-kernel-owner+w=401wt.eu-S1759955AbXK2IZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759955AbXK2IZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 03:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbXK2IZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 03:25:14 -0500
Received: from mga03.intel.com ([143.182.124.21]:29878 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754170AbXK2IZN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 03:25:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,228,1194249600"; 
   d="scan'208";a="328389061"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: [patch 0/2] x86, ptrace:  support for branch trace store(BTS)
Date: Thu, 29 Nov 2007 08:14:10 -0000
Message-ID: <029E5BE7F699594398CA44E3DDF5544401024075@swsmsx413.ger.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 0/2] x86, ptrace:  support for branch trace store(BTS)
thread-index: AcgyX9Ih/lPxTGO2S0+V7AUS3uMpSg==
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: <linux-kernel@vger.kernel.org>, <mingo@elte.hu>, <hpa@zytor.com>,
       <tglx@linutronix.de>, <ak@suse.de>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>,
       <akpm@linux-foundation.org>
X-OriginalArrivalTime: 29 Nov 2007 08:14:07.0658 (UTC) FILETIME=[D03698A0:01C8325F]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Support for Intel's last branch recording to ptrace. This gives
debuggers
access to this hardware feature and allows them to show an execution
trace
of the debugged application.

Last branch recording (see section 18.5 in the Intel 64 and IA-32
Architectures Software Developer's Manual) allows taking an execution
trace of the running application without instrumentation. When a branch
is executed, the hardware logs the source and destination address in a
cyclic buffer given to it by the OS.

This can be a great debugging aid. It shows you how exactly you got
where you currently are without requiring you to do lots of single
stepping and rerunning.

This patch manages the various buffers, configures the trace
hardware, disentangles the trace, and provides a user interface via
ptrace. On the high-level design:
- there is one optional trace buffer per thread_struct
- upon a context switch, the trace hardware is reconfigured to either
  disable tracing or to use the appropriate buffer for the new task.
  - tracing induces ~20% overhead as branch records are sent out on
    the bus. 
  - the hardware collects trace per processor. To disentangle the
    traces for different tasks, we use separate buffers and reconfigure
    the trace hardware.
- the low-level data layout is configured at cpu initialization time
  - different processors use different branch record formats


patch 1/2 contains the kernel changes
patch 2/2 contains changes to the ptrace man pages


So far, we incorporated mostly feedback from Andi Kleen. Is there any
more feedback that needs to be addressed?


regards,
markus.
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
