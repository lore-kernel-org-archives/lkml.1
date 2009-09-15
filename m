Return-Path: <linux-kernel-owner+w=401wt.eu-S1753283AbZIOLhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbZIOLhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 07:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbZIOLg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 07:36:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:38421 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753156AbZIOLgz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 07:36:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,390,1249282800"; 
   d="scan'208";a="550705798"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 15 Sep 2009 12:35:23 +0100
Subject: RE: [patch, resend] x86, perf_counter, bts: optimize BTS overflow
 handling
Thread-Topic: [patch, resend] x86, perf_counter, bts: optimize BTS overflow
 handling
Thread-Index: Aco196pWgXhhdX3LR7yU0tsEPElV2QAAGZFw
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77EC47B0EC1@irsmsx504.ger.corp.intel.com>
References: <20090915130023.A16204@sedona.ch.intel.com>
	 <1253013145.5506.50.camel@laptop>
	 <928CFBE8E7CB0040959E56B4EA41A77EC47B0E9E@irsmsx504.ger.corp.intel.com>
 <1253013915.5506.54.camel@laptop>
In-Reply-To: <1253013915.5506.54.camel@laptop>
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
>Sent: Tuesday, September 15, 2009 1:25 PM
>To: Metzger, Markus T
>Cc: mingo@elte.hu; tglx@linutronix.de; hpa@zytor.com; markus.t.metzger@gmail.com; linux-
>kernel@vger.kernel.org
>Subject: RE: [patch, resend] x86, perf_counter, bts: optimize BTS overflow handling
>
>On Tue, 2009-09-15 at 12:18 +0100, Metzger, Markus T wrote:
>
>> >> Restructure perf_counter sampling into sample creation and sample
>> >> output.
>> >> Prepare a single reference sample for BTS sampling and update the from
>> >> and to address fields when draining the BTS buffer.
>> >> Drain the entire BTS buffer between a single perf_output_begin() /
>> >> perf_output_end() pair.
>> >
>> >Generally looks very nice, one thing though, why did you take regs out
>> >of perf_sample_data, now you get to pass around one extra param..
>>
>>
>> That is to make perf_sample_data describe the sample directly.
>>
>> The regs are used to create the sample; they're not needed once
>> the sample has been created.
>
>True, but I'd have been lazy and not added that extra parameter all over
>the place, but sure ;-)
>
>This is now fast enough to BTS trace the kernel too?

It is. At least on my box.

Once that patch has been accepted, I will ask Ingo to drop
1653192f510bd8114b7b133d7289e6e5c3e95046.

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

