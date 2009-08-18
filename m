Return-Path: <linux-kernel-owner+w=401wt.eu-S1753156AbZHROPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbZHROPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 10:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbZHROPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 10:15:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:45305 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbZHROPR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 10:15:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,402,1246863600"; 
   d="scan'208";a="440065794"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>
Date: Tue, 18 Aug 2009 15:15:14 +0100
Subject: RE: [PATCH] perf_counter: Fix a race on perf_counter_ctx
Thread-Topic: [PATCH] perf_counter: Fix a race on perf_counter_ctx
Thread-Index: AcogDESxIZikYvgbR8+ZVlKWWtGSsQAAbMtA
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77EC1CB77FF@irsmsx504.ger.corp.intel.com>
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
In-Reply-To: <20090818140022.GB13013@elte.hu>
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
>From: Ingo Molnar [mailto:mingo@elte.hu]
>Sent: Tuesday, August 18, 2009 4:00 PM
>To: Metzger, Markus T
>Cc: Peter Zijlstra; tglx@linutronix.de; hpa@zytor.com; markus.t.metzger@gmail.com; linux-
>kernel@vger.kernel.org; Paul Mackerras
>Subject: Re: [PATCH] perf_counter: Fix a race on perf_counter_ctx
>
>
>* Metzger, Markus T <markus.t.metzger@intel.com> wrote:
>
>> Well, that would push out the limit a bit, but it would still be
>> quite fragile.
>>
>> Currently, I'm not sure that this (i.e. that the interrupt
>> handling takes too long) is the underlying problem of the hangs
>> that I'm seeing.
>
>I havent seen a plausible theory yet about why an actual lockup
>would happen on your box.

So you do not think that taking too long in the ISR could cause this?

And is it working on your box?


>Does the timer IRQ perhaps slow down to such a degree that it can
>never make progress and gets re-triggered again and again? We saw
>such things with the function tracer.

How would I test this?


>Did the sampling of kernel-mode tasks ever work with the old BTS
>code?

The old BTS code used circular buffers.


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

