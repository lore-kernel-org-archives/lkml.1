Return-Path: <linux-kernel-owner+w=401wt.eu-S1759465AbZDCGm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465AbZDCGm0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 02:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750930AbZDCGmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 02:42:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:46451 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbZDCGmO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 02:42:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,318,1235980800"; 
   d="scan'208";a="399989932"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 3 Apr 2009 07:42:08 +0100
Subject: RE: [patch 13/18] x86, ds: add leakage warning
Thread-Topic: [patch 13/18] x86, ds: add leakage warning
Thread-Index: AcmzyS8mt7uRhtjwSKCpC2lVl4oQMwAW2pCg
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E92718067@irsmsx504.ger.corp.intel.com>
References: <20090402145455.597376000@intel.com>
 <20090402145726.223198000@intel.com> <20090402192755.GD2455@elte.hu>
In-Reply-To: <20090402192755.GD2455@elte.hu>
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
>Sent: Thursday, April 02, 2009 9:28 PM
>To: Metzger, Markus T
>Cc: tglx@linutronix.de; hpa@zytor.com; markus.t.metzger@gmail.com; roland@redhat.com;
>eranian@googlemail.com; oleg@redhat.com; Villacis, Juan; ak@linux.jf.intel.com; linux-
>kernel@vger.kernel.org
>Subject: Re: [patch 13/18] x86, ds: add leakage warning
>
>
>* markus.t.metzger@intel.com <markus.t.metzger@intel.com> wrote:
>
>> +static inline void ds_warn_leak(struct task_struct *tsk)
>> +{
>> +	WARN(tsk->thread.ds_ctx, "leaking DS context\n");
>> +}
>
>> +	ds_warn_leak(tsk);
>
>since we normally expect X86_DS enabled i'd suggest this
>simplification: always have thread.ds_ctx around so the WARN_ON can
>go there unconditionally. (it wont trigger in the !DS case)

OK.


>>  struct task_struct;
>>  struct mm_struct;
>> +struct ds_context;
>
>why is this needed in processor.h?

This seems to be common practice.

The only thing we need here is a forward declaration in order to put a pointer
field into the thread_struct.

The same holds for sched.h, which uses bts_context. Since bts_context again has a pointer
to a task_struct, we would have circular dependencies, so either one needs a forward
declaration.

If I split ds.h into ds_types.h and ds_api.h, the only place where this could
be used would be processor.h. All the rest needs to include both - or, rather,
ds_api.h, which then includes ds_types.h.



>ds.h should be split into ds_types.h and ds_api.h, with the pure
>data type definitions in ds_types.h. processor.h (which needs to
>know about the DS context type) then includes ds_types.h - which
>is a lightweight header.
>
>Actual DS using facilities also disable ds_api.h.
>
>This keeps data types nicely separated from methods and inlines.
>
>	Ingo
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

