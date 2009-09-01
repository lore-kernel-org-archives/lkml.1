Return-Path: <linux-kernel-owner+w=401wt.eu-S1755033AbZIAO1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033AbZIAO1X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 10:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754990AbZIAO1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 10:27:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:61982 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754974AbZIAO1V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 10:27:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,312,1249282800"; 
   d="scan'208";a="546684033"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>
Date: Tue, 1 Sep 2009 15:27:18 +0100
Subject: RE: [discuss] BTS overflow handling, was: [PATCH] perf_counter: Fix
 a race on perf_counter_ctx
Thread-Topic: [discuss] BTS overflow handling, was: [PATCH] perf_counter:
 Fix a race on perf_counter_ctx
Thread-Index: AcorC5XR7AsKI602Q0yo8rrw7ow4DQAAMBjA
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77EC46CF2A6@irsmsx504.ger.corp.intel.com>
References: <20090808120315.GA14086@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF464@irsmsx504.ger.corp.intel.com>
	 <20090810134608.GA8295@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF78D@irsmsx504.ger.corp.intel.com>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1CB7725@irsmsx504.ger.corp.intel.com>
	 <1250600348.7583.280.camel@twins> <1250600385.7583.281.camel@twins>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1CB7775@irsmsx504.ger.corp.intel.com>
	 <1250602664.7583.293.camel@twins>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1CB77C8@irsmsx504.ger.corp.intel.com>
	 <20090818140022.GB13013@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1CB77FF@irsmsx504.ger.corp.intel.com>
	 <928CFBE8E7CB0040959E56B4EA41A77EC465EFC5@irsmsx504.ger.corp.intel.com>
	 <928CFBE8E7CB0040959E56B4EA41A77EC465F989@irsmsx504.ger.corp.intel.com>
	 <1251810046.7547.13.camel@twins>
	 <928CFBE8E7CB0040959E56B4EA41A77EC46CF212@irsmsx504.ger.corp.intel.com>
 <1251813197.7547.27.camel@twins>
In-Reply-To: <1251813197.7547.27.camel@twins>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Peter Zijlstra [mailto:a.p.zijlstra@chello.nl]
>Sent: Tuesday, September 01, 2009 3:53 PM
>To: Metzger, Markus T
>Cc: Ingo Molnar; tglx@linutronix.de; hpa@zytor.com; markus.t.metzger@gmail.com; linux-
>kernel@vger.kernel.org; Paul Mackerras
>Subject: RE: [discuss] BTS overflow handling, was: [PATCH] perf_counter: Fix a race on
>perf_counter_ctx
>
>On Tue, 2009-09-01 at 14:32 +0100, Metzger, Markus T wrote:
>
>> >> My current theory is that the BTS buffer fills up so quickly when tracing
>> >> the kernel, that the kernel is busy handling overflows and reacting on
>> >> other interrupts that pile up while we're handling the BTS overflow.
>> >>
>> >> When I trace user-mode branches, it works.
>> >>
>> >> When I do not copy the trace during overflow handling, the kernel does not hang.
>> >
>> >Agreed, that was my suspicion as well. Would you happen to know where to
>> >get these USB debug port cables, and how to find out if a machine
>> >supports this?
>>
>>
>> I'm sorry but I don't understand what you mean with "these USB debug port cables".
>
>Not sure either, whatever makes all the code from commit:
>5c05917e7fe313a187ad6ebb94c1c6cf42862a0b usable I guess.


Sorry, I don't know anything about that.


>> >> I do need 3 buffers of 2048 entries = 3x48 pages per cpu, though.
>> >
>> >And those pages have to be contiguous too, right? That's an order-6
>> >alloc, painful.
>>
>>
>> According to an earlier discussion with Roland, they don't have to.
>> They still need to be locked, though.
>> According to some other discussion with Andrew and Ingo, I still use
>> kmalloc to allocate those buffers.
>
>Section 18.18.5 of book 3B says the DS buffer base is a linear address.
>This suggests each buffer does need contiguous pages.
>
>48 contiguous pages constitutes an order-6 allocation (64 pages), which
>is unreliable at best.

Roland argued that this means virtually contiguous, not physically.


>> When I use schedule_work() instead, how would I ensure that the work is done
>> before the traced (or tracing) task is rescheduled?
>
>No, basically the only thing left is softirqs, which can be preempted by
>hardirqs, but that's a horrid hack too, esp since processing the BTS
>outside of the handler will basically result in the BTS tracing its own
>processing, generating even more data to process.

I would have disabled perf on that cpu; it won't work, otherwise,
since the draining code alone would generate more trace than fits into
a buffer. I would need to disable preemption, though.

Are you saying that schedule_work() won't work? It will quite likely be very
lossy, but why won't it work at all?

How would that softirq approach work? Could you point me to some reference
code?


thanks and regards,
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

