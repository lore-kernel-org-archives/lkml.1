Return-Path: <linux-kernel-owner+w=401wt.eu-S1761496AbZBYKJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761496AbZBYKJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 05:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759571AbZBYKIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 05:08:48 -0500
Received: from mga09.intel.com ([134.134.136.24]:50720 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755611AbZBYKIq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 05:08:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,264,1233561600"; 
   d="scan'208";a="492933463"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Date: Wed, 25 Feb 2009 10:08:39 +0000
Subject: RE: [tip:tracing/hw-branch-tracing] tracing/hw-branch-tracing:
	convert bts-tracer mutex to a spinlock
Thread-Topic: [tip:tracing/hw-branch-tracing] tracing/hw-branch-tracing:
	convert bts-tracer mutex to a spinlock
Thread-Index: AcmXL6S2nM+fbq95QtGuEwLmZAK/ywAAB2Tw
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E4A4C1F31@irsmsx504.ger.corp.intel.com>
References: <tip-2d542cf34264ac92e9e7ac55c0b096b066d569d2@kernel.org>
 <928CFBE8E7CB0040959E56B4EA41A77E4A4C1EF6@irsmsx504.ger.corp.intel.com>
 <20090225095814.GC12352@elte.hu>
In-Reply-To: <20090225095814.GC12352@elte.hu>
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
>Sent: Wednesday, February 25, 2009 10:58 AM
>To: Metzger, Markus T


>* Metzger, Markus T <markus.t.metzger@intel.com> wrote:
>
>> > static void trace_bts_prepare(struct trace_iterator *iter)
>> > {
>> >-    mutex_lock(&bts_tracer_mutex);
>> >+    spin_lock(&bts_tracer_lock);
>> >
>> >     on_each_cpu(trace_bts_cpu, iter->tr, 1);
>> >
>> >-    mutex_unlock(&bts_tracer_mutex);
>> >+    spin_unlock(&bts_tracer_lock);
>> > }
>>
>> Whereas start/stop are relatively fast, the above operation is
>> rather expensive. Would it make sense to use
>> schedule_on_each_cpu() instead of on_each_cpu()?
>
>it's perfectly fine to do that on_each_cpu() under the spinlock.
>schedule_on_each_cpu() would likely be more expensive - and for
>no good reason.

OK. 

And I assume you like the spinlock better than the
get/put_online_cpus(), as well.

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

