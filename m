Return-Path: <linux-kernel-owner+w=401wt.eu-S1760965AbXKTPtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760965AbXKTPtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 10:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758365AbXKTPtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 10:49:07 -0500
Received: from mga02.intel.com ([134.134.136.20]:13933 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754384AbXKTPtG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 10:49:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,442,1188802800"; 
   d="scan'208";a="276302251"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [patch][v2] x86, ptrace: support for branch trace store(BTS)
Date: Tue, 20 Nov 2007 15:49:03 -0000
Message-ID: <029E5BE7F699594398CA44E3DDF55444F71289@swsmsx413.ger.corp.intel.com>
In-Reply-To: <alpine.DEB.0.99999.0711200729570.765@twinlark.arctic.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch][v2] x86, ptrace: support for branch trace store(BTS)
thread-index: Acgri0zyGvL16xsdTTahFnbyR3HzWAAAFeEQ
References: <029E5BE7F699594398CA44E3DDF55444F3AEA7@swsmsx413.ger.corp.intel.com> <alpine.DEB.0.99999.0711200708580.765@twinlark.arctic.org> <alpine.DEB.0.99999.0711200729570.765@twinlark.arctic.org>
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "dean gaudet" <dean@arctic.org>
Cc: <linux-kernel@vger.kernel.org>, <mingo@elte.hu>, <hpa@zytor.com>,
       <tglx@linutronix.de>, <ak@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       <akpm@linux-foundation.org>
X-OriginalArrivalTime: 20 Nov 2007 15:49:02.0145 (UTC) FILETIME=[DF470B10:01C82B8C]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: dean gaudet [mailto:dean@arctic.org] 
>Sent: Dienstag, 20. November 2007 16:37
>To: Metzger, Markus T
>Cc: linux-kernel@vger.kernel.org; mingo@elte.hu; 
>hpa@zytor.com; tglx@linutronix.de; ak@suse.de; Siddha, Suresh 
>B; akpm@linux-foundation.org
>Subject: Re: [patch][v2] x86, ptrace: support for branch trace 
>store(BTS)
>
>On Tue, 20 Nov 2007, dean gaudet wrote:
>
>> On Tue, 20 Nov 2007, Metzger, Markus T wrote:
>> 
>> > +__cpuinit void ptrace_bts_init_intel(struct cpuinfo_x86 *c)
>> > +{
>> > +	switch (c->x86) {
>> > +	case 0x6:
>> > +		switch (c->x86_model) {
>> > +#ifdef __i386__
>> > +		case 0xD:
>> > +		case 0xE: /* Pentium M */
>> > +			ptrace_bts_ops = ptrace_bts_ops_pentium_m;
>> > +			break;
>> > +#endif /* _i386_ */
>> > +		case 0xF: /* Core2 */
>> > +			ptrace_bts_ops = ptrace_bts_ops_core2;
>> > +			break;
>> > +		default:
>> > +			/* sorry, don't know about them */
>> > +			break;
>> > +		}
>> > +		break;
>> > +	case 0xF:
>> > +		switch (c->x86_model) {
>> > +#ifdef __i386__
>> > +		case 0x0:
>> > +		case 0x1:
>> > +		case 0x2:
>> > +		case 0x3: /* Netburst */
>> > +			ptrace_bts_ops = ptrace_bts_ops_netburst;
>> > +			break;
>> > +#endif /* _i386_ */
>> > +		default:
>> > +			/* sorry, don't know about them */
>> > +			break;
>> > +		}
>> > +		break;
>> 
>> is this right?  i thought intel family 15 models 3 and 4 
>supported amd64
>> mode...
>
>actually... why aren't you using cpuid level 1 edx bit 21 to 
>enable/disable this feature?  isn't that the bit defined to indicate 
>whether this feature is supported or not?

This function is not checking for the presence of the feature 
but for the BTS record format.
The feature check is done in init_intel().


>and it seems like this patch and perfmon2 are going to have to 
>live with 
>each other... since they both require the use of the DS save area...

Hmmm, this might require some synchronization between those two.

Do you know how (accesses to) MSR's are managed by the kernel?

regards,
markus.

>
>-dean
>
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
