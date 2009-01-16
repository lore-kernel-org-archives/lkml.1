Return-Path: <linux-kernel-owner+w=401wt.eu-S935466AbZAPPAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935466AbZAPPAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 10:00:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757324AbZAPPAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 10:00:10 -0500
Received: from mga02.intel.com ([134.134.136.20]:33312 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473AbZAPPAI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 10:00:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,277,1231142400"; 
   d="scan'208";a="482235593"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Steven Rostedt <srostedt@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>
Date: Fri, 16 Jan 2009 14:59:37 +0000
Subject: RE: [patch 1/5] x86, ftrace, hw-branch-tracer: support hotplug cpus
Thread-Topic: [patch 1/5] x86, ftrace, hw-branch-tracer: support hotplug cpus
Thread-Index: Acl36Xn6eqOa4m4jQSy2KRNvVORRmwAAVtOg
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E0CDD7B6E@irsmsx504.ger.corp.intel.com>
References: <20090116115051.A29998@sedona.ch.intel.com>
 <1232117253.21980.74.camel@localhost.localdomain>
In-Reply-To: <1232117253.21980.74.camel@localhost.localdomain>
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
>From: Steven Rostedt [mailto:srostedt@redhat.com]
>Sent: Friday, January 16, 2009 3:48 PM
>To: Metzger, Markus T

>> +    local_irq_save(irq1);
>> +    cpu = raw_smp_processor_id();
>> +    if (atomic_inc_return(&tr->data[cpu]->disabled) != 1)
>> +            goto out;
>>
>> -    event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry), &irq);
>> +    event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry), &irq2);
>>      if (!event)
>>              return;
>
>You need a goto out here, otherwise you leave with interrupts disabled.
>

Thanks. I will fix it and send an updated patch.

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

