Return-Path: <linux-kernel-owner+w=401wt.eu-S1753441AbZIOMII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbZIOMII (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 08:08:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753349AbZIOMIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 08:08:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:52165 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbZIOMH6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 08:07:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,390,1249282800"; 
   d="scan'208";a="493594866"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Pavel Machek <pavel@ucw.cz>
CC: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>
Date: Tue, 15 Sep 2009 13:07:26 +0100
Subject: RE: [patch] x86, perf_counter, bts: optimize BTS overflow handling
Thread-Topic: [patch] x86, perf_counter, bts: optimize BTS overflow handling
Thread-Index: Aco1+J443cKv7kzFT7K6PErWNgIgcwAATN8g
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77EC47B0F20@irsmsx504.ger.corp.intel.com>
References: <20090908083110.A7541@sedona.ch.intel.com>
 <20090915113408.GD1328@ucw.cz>
In-Reply-To: <20090915113408.GD1328@ucw.cz>
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
>From: Pavel Machek [mailto:pavel@ucw.cz]
>Sent: Tuesday, September 15, 2009 1:34 PM
>To: Metzger, Markus T
>Cc: mingo@elte.hu; tglx@linutronix.de; hpa@zytor.com; markus.t.metzger@gmail.com; linux-
>kernel@vger.kernel.org; a.p.zijlstra@chello.nl
>Subject: Re: [patch] x86, perf_counter, bts: optimize BTS overflow handling
>
>On Tue 2009-09-08 08:31:10, Markus Metzger wrote:
>> Draining the BTS buffer on a buffer overflow interrupt takes too long
>> resulting in a kernel lockup when tracing the kernel.
>
>Wait. If 'takes too long' leads to 'lockup'...solution is not making
>it faster. Solution should be making kernel robust -- maybe disable
>tracing when it can't keep up or something...? or maybe disabling
>interrupt until you handle the previous one...?
>								Pavel

Maybe I got the term 'lockup' wrong? The symptom is that the system gets slower
and then seems to freeze. When I disable tracing in such a frozen system (via
a debugger), it recovers. When I attached the debugger, one core had been busy
processing the BTS overflow, the other core had been waiting for an smp call
response.


BTS overflow interrupts are processed one after the other. BTS is disabled
as long as we handle the interrupt. We do not trace overflow handling; but we
trace all the rest.

The problem as I see it is that the kernel generates too much trace and it
takes too long to generate samples out of it so that it does not make progress,
any more - or very very slow progress.

Optimizing sample generation allows it to make progress fast enough.

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

