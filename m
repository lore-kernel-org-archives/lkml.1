Return-Path: <linux-kernel-owner+w=401wt.eu-S1755413AbXLGMGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbXLGMGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 07:06:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbXLGMGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 07:06:04 -0500
Received: from mga02.intel.com ([134.134.136.20]:48717 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899AbXLGMGB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 07:06:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,266,1194249600"; 
   d="scan'208";a="289973320"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: ptrace API extensions for BTS
Date: Fri, 7 Dec 2007 12:01:28 -0000
Message-ID: <029E5BE7F699594398CA44E3DDF55444010F9074@swsmsx413.ger.corp.intel.com>
In-Reply-To: <200712071218.17914.ak@suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: ptrace API extensions for BTS
thread-index: Acg4wuwY8N9S4xrDT/mkg8uZJBU7+gAAyuAw
References: <029E5BE7F699594398CA44E3DDF55444010F8D7C@swsmsx413.ger.corp.intel.com> <200712071218.17914.ak@suse.de>
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "Andi Kleen" <ak@suse.de>
Cc: <roland@redhat.com>, <markus.t.metzger@gmail.com>,
       <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
       <mingo@elte.hu>, "Siddha, Suresh B" <suresh.b.siddha@intel.com>
X-OriginalArrivalTime: 07 Dec 2007 12:01:49.0843 (UTC) FILETIME=[F2D09630:01C838C8]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Andi Kleen [mailto:ak@suse.de] 
>Sent: Freitag, 7. Dezember 2007 12:18

>> I would like to settle the discussion and find an interface that
>> everybody can agree to, so I can implement that interface and we can
>> move forward with the patch.
>
>The most efficient interface would be zero copy with tracer 
>user process
>supplying memory that is pinned (get_user_pages()) subject to the
>mlock rlimit. Then kernel telling the CPU to directly log into
>that.

That would require users to understand all kinds of BTS formats
and to detect the hardware they are running on in order to interpret
the data.

So far, there are two different formats. But one of them is wasting
an entire word of memory per record. I could imagine that this would
change some day.

Other architectures would likely use an entirely different format.
Users who want to support several architectures would benefit from
a common format for this from-to branch information.


>> Regarding 1, we currently provide scheduling timestamps, 
>which are arch
>
>That's actually broken because you don't log the CPU number.
>sched_clock() without the CPU number associated is meaningless 
>on systems without synchronized, pstate invariant TSC 
>[that is older Intel systems or some larger current systems]

I see.

The intention was not to provide exact timestamps, but rather a
relative order of BTS chunks that would allow debuggers to
show which parts were (actually, "might have been" is the best we
can say) executed in parallel, and which parts were definitely 
executed sequentially.

Without a global time, though, this becomes rather meaningless.

Is there some other metric that would allow me to order BTS 
chunks for different threads?


>> Additional architectures may want to (re)use and extend the x86 bts
>> record, or they may want to invent their own format. In the 
>former case,
>
>I think that's actually not a good goal. If the code is so complicated
>that it makes sense sharing then you did something wrong :)

Agreed;-)

Users would benefit if they wanted to support multiple architectures.
They would need to invent such a more general interface; or duplicate 
code, which is never a good thing.


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
