Return-Path: <linux-kernel-owner+w=401wt.eu-S1751851AbZH1J5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851AbZH1J5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 05:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbZH1J5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 05:57:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:5070 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249AbZH1J5X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 05:57:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="181411091"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>
Date: Fri, 28 Aug 2009 10:56:52 +0100
Subject: RE: [PATCH] perf_counter: Fix a race on perf_counter_ctx
Thread-Topic: [PATCH] perf_counter: Fix a race on perf_counter_ctx
Thread-Index: AcogDESxIZikYvgbR8+ZVlKWWtGSsQAAbMtAAe2TxCA=
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77EC465EFC5@irsmsx504.ger.corp.intel.com>
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
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77EC1CB77FF@irsmsx504.ger.corp.intel.com>
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
>From: Metzger, Markus T
>Sent: Tuesday, August 18, 2009 4:15 PM
>To: Ingo Molnar
>Cc: Peter Zijlstra; tglx@linutronix.de; hpa@zytor.com; markus.t.metzger@gmail.com; linux-
>kernel@vger.kernel.org; Paul Mackerras
>Subject: RE: [PATCH] perf_counter: Fix a race on perf_counter_ctx
>
>>-----Original Message-----
>>From: Ingo Molnar [mailto:mingo@elte.hu]
>>Sent: Tuesday, August 18, 2009 4:00 PM
>>To: Metzger, Markus T
>>Cc: Peter Zijlstra; tglx@linutronix.de; hpa@zytor.com; markus.t.metzger@gmail.com; linux-
>>kernel@vger.kernel.org; Paul Mackerras
>>Subject: Re: [PATCH] perf_counter: Fix a race on perf_counter_ctx
>>
>>
>>* Metzger, Markus T <markus.t.metzger@intel.com> wrote:
>>
>>> Well, that would push out the limit a bit, but it would still be
>>> quite fragile.
>>>
>>> Currently, I'm not sure that this (i.e. that the interrupt
>>> handling takes too long) is the underlying problem of the hangs
>>> that I'm seeing.
>>
>>I havent seen a plausible theory yet about why an actual lockup
>>would happen on your box.
>
>So you do not think that taking too long in the ISR could cause this?
>
>And is it working on your box?
>
>
>>Does the timer IRQ perhaps slow down to such a degree that it can
>>never make progress and gets re-triggered again and again? We saw
>>such things with the function tracer.
>
>How would I test this?
>
>
>>Did the sampling of kernel-mode tasks ever work with the old BTS
>>code?
>
>The old BTS code used circular buffers.

Ingo,

I'm not making any progress with the kernel hang.

User-mode tracing is working OK (e.g. -e branches:u) and circular buffers are
working fine, as well. I can do "perf top -c 1 -e branches:u" and simultaneous
"perf record -c 1 -e branches:u", but as soon as I try to trace the kernel,
it hangs (and /var/log/messages is typically garbled).

Please drop the BTS patch.

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

