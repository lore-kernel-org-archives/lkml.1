Return-Path: <linux-kernel-owner+w=401wt.eu-S1761112AbXK3J7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761112AbXK3J7Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 04:59:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbXK3J7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 04:59:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:47934 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbXK3J7J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 04:59:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,233,1194249600"; 
   d="scan'208";a="218537334"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [patch 0/2] x86, ptrace:  support for branch trace store(BTS)
Date: Fri, 30 Nov 2007 09:57:22 -0000
Message-ID: <029E5BE7F699594398CA44E3DDF5544401051EEF@swsmsx413.ger.corp.intel.com>
In-Reply-To: <20071129155940.7df70ac2.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 0/2] x86, ptrace:  support for branch trace store(BTS)
thread-index: Acgy5IrFu8GVWrxBQo+Pl+xdU0icfwASD1xA
References: <029E5BE7F699594398CA44E3DDF5544401024075@swsmsx413.ger.corp.intel.com> <20071129155940.7df70ac2.akpm@linux-foundation.org>
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <mingo@elte.hu>, <hpa@zytor.com>,
       <tglx@linutronix.de>, <ak@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Michael Kerrisk" <mtk-manpages@gmx.net>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>
X-OriginalArrivalTime: 30 Nov 2007 09:57:21.0064 (UTC) FILETIME=[662F1A80:01C83337]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>Is there any userspace code avaialble which people can use to play with
>this?

Not yet. We are talking to internal teams regarding gdb support.


>How do you envisage it being used in the long term?  Do you 
>expect any of
>the standard performance tuning tools will be tweaked to 
>understand this
>feature and if so which ones?

I would expect debuggers to use it to show an execution trace of the 
debuggee. The ptrace interface targets application debuggers; kernel
debuggers would need a slightly different interface.

This saves you a lot of single-stepping through your code to answer the
question "how exactly did I get here". I used a similar feature on bare
metal XScale to hunt data aborts, which made the task pretty easy.

Performance tools, which would be interested in the PEBS part of it,
would
need to share DS with this debugging feature. When I grep'ed the kernel
to
see who else used DS, I did not find anybody accessing the DS_SAVE_AREA
MSR.
When there are multiple users of DS, we would need to introduce some
means
of managing that resource.
We may extend this patch to add support for reading PEBS using ptrace.


>I'm generally wondering "how will developers be using this in a year or
>two's time?"

Application developers will use it via application debuggers.
Kernel developers will use it via kgdb; a kernel interface needs to be
added to it. This patch provides the hardware access and an application
debugger interface.


>The patches were horridly wordwrapped.

My apologies. Andi already complained and I hoped I got it fixed.
I'm working on using a different email client and maybe a different
email 
account.


>Is there any likelihood that any other CPUs do now or will in 
>the future
>support any similar feature to this?  If so, is an 
>implementation which is
>100% contained to arch/x86 appropriate?

I am aware of a trace feature in XScale processors. I think there is
also
something available for ARM, but I don't know details.

If the feature turns out to be really useful, I would, of course, expect
(or at least hope) that other CPU's would provide a similar feature.

Most of the code is arch specific. If other CPU's share the general BTS
layout,
some of the ptrace_bts.c code could be shared.
Since the implementation only supports x86, I think the code should go
into
arch/x86 - at least until other CPU's are supported.
I would hope that the ptrace interface will be shared across
architectures.


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
