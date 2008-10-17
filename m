Return-Path: <linux-kernel-owner+w=401wt.eu-S1756625AbYJQS7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625AbYJQS7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 14:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754403AbYJQS7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 14:59:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:23300 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754266AbYJQS7D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 14:59:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,433,1220252400"; 
   d="scan'208";a="452613092"
From: "Luck, Tony" <tony.luck@intel.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 17 Oct 2008 11:58:31 -0700
Subject: RE: [RFC patch 15/15] LTTng timestamp x86
Thread-Topic: [RFC patch 15/15] LTTng timestamp x86
Thread-Index: AckwiBkOFQ0tCPtySiK2HW8RgJyYXgAAFiew
Message-ID: <57C9024A16AD2D4C97DC78E552063EA35334594F@orsmsx505.amr.corp.intel.com>
References: <20081016232729.699004293@polymtl.ca>
 <20081016234657.837704867@polymtl.ca>
 <alpine.LFD.2.00.0810161701470.3288@nehalem.linux-foundation.org>
 <20081017012835.GA30195@Krystal>
 <57C9024A16AD2D4C97DC78E552063EA3532D455F@orsmsx505.amr.corp.intel.com>
 <20081017172515.GA9639@goodmis.org>
 <57C9024A16AD2D4C97DC78E552063EA3533458AC@orsmsx505.amr.corp.intel.com>
 <20081017184215.GB9874@Krystal>
In-Reply-To: <20081017184215.GB9874@Krystal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hrm, on such systems
> - *large* amount of cpus
> - no synchronized TSCs
>
> What would be the best approach to order events ?

There isn't a perfect solution for this.  My feeling is
that your best hope is with per-cpu buffers logged with
the local TSC ... together with some fancy heuristics to
post-process the logs to come up with the best approximation
to the actual ordering.

If you have a tight upper bound estimate for the
errors in converting from "per-cpu" TSC values to "global
system time" then the post processing tool will be able
to identify events for which the order is uncertain.

> Do you think we should consider using HPET, event though it's
> painfully slow ? Would it be faster than cache-line bouncing
> on such large boxes ? With a frequency around 10MHz, that
> would give a 100ns precision, which should be enough
> to order events.

This sounds like a poor choice.  Makes all traces very
slow.  100ns precision isn't all that good ... we can
probably do almost as well estimating the delta between
TSC on different cpus.

-Tony
