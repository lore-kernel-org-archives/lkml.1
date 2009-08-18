Return-Path: <linux-kernel-owner+w=401wt.eu-S1758929AbZHRNUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758929AbZHRNUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 09:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758886AbZHRNUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 09:20:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:50068 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758874AbZHRNUn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 09:20:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,402,1246863600"; 
   d="scan'208";a="440034388"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>
Date: Tue, 18 Aug 2009 14:20:30 +0100
Subject: RE: [PATCH] perf_counter: Fix a race on perf_counter_ctx
Thread-Topic: [PATCH] perf_counter: Fix a race on perf_counter_ctx
Thread-Index: AcogA8ajHpVyqPAxRdCSLgiZwbVxowAAjFUg
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77EC1CB7775@irsmsx504.ger.corp.intel.com>
References: <928CFBE8E7CB0040959E56B4EA41A77EC1BFEFEB@irsmsx504.ger.corp.intel.com>
	 <20090807103127.GA23139@elte.hu> <20090807103610.GA23728@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF02D@irsmsx504.ger.corp.intel.com>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF048@irsmsx504.ger.corp.intel.com>
	 <20090807112421.GB30014@elte.hu> <20090807113349.GA31673@elte.hu>
	 <1249667341.17467.5.camel@twins> <20090808120315.GA14086@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF464@irsmsx504.ger.corp.intel.com>
	 <20090810134608.GA8295@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF78D@irsmsx504.ger.corp.intel.com>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1CB7725@irsmsx504.ger.corp.intel.com>
	 <1250600348.7583.280.camel@twins> <1250600385.7583.281.camel@twins>
In-Reply-To: <1250600385.7583.281.camel@twins>
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
>From: Peter Zijlstra [mailto:peterz@infradead.org]
>Sent: Tuesday, August 18, 2009 3:00 PM
>To: Metzger, Markus T
>Cc: Ingo Molnar; tglx@linutronix.de; hpa@zytor.com; markus.t.metzger@gmail.com; linux-
>kernel@vger.kernel.org; Paul Mackerras
>Subject: RE: [PATCH] perf_counter: Fix a race on perf_counter_ctx
>
>On Tue, 2009-08-18 at 14:59 +0200, Peter Zijlstra wrote:
>> On Tue, 2009-08-18 at 13:49 +0100, Metzger, Markus T wrote:
>> > Hi Ingo, Peter,
>> >
>> > Did you say that branch tracing is working for you?
>> >
>> > On my system, the kernel hangs.
>> >
>> > Could it be that it simply takes too long to copy the trace? When I set the number
>> > of samples to 10, everything seems to work OK. When I increase that number to 1000,
>> > the kernel is getting very slow and eventually hangs.
>> >
>> > I get a message "hrtimer: interrupt too slow", and I get a soft lockup bug. The rest
>> > of the message log seems pretty garbled.
>
>How many NMI/s is this generating anyway?

One every 800 or so branches in the current configuration - which results in 800 plus
a few perf_counter_output() calls per interrupt.

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

