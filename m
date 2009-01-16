Return-Path: <linux-kernel-owner+w=401wt.eu-S935724AbZAPPEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935724AbZAPPEO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 10:04:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759864AbZAPPD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 10:03:56 -0500
Received: from mga01.intel.com ([192.55.52.88]:27634 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755785AbZAPPDz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 10:03:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,277,1231142400"; 
   d="scan'208";a="657679110"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Steven Rostedt <srostedt@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>
Date: Fri, 16 Jan 2009 15:03:48 +0000
Subject: RE: [patch 3/5] x86, ftrace, hw-branch-tracer: dump on oops
Thread-Topic: [patch 3/5] x86, ftrace, hw-branch-tracer: dump on oops
Thread-Index: Acl36oX/nK7SN/RNR72FRnUgJEWMQQAAEwxQ
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E0CDD7B78@irsmsx504.ger.corp.intel.com>
References: <20090116115829.A30245@sedona.ch.intel.com>
 <1232117724.21980.80.camel@localhost.localdomain>
In-Reply-To: <1232117724.21980.80.camel@localhost.localdomain>
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
>Sent: Friday, January 16, 2009 3:55 PM
>To: Metzger, Markus T
>Cc: linux-kernel@vger.kernel.org; mingo@elte.hu; tglx@linutronix.de; hpa@zytor.com;
>markus.t.metzger@gmail.com
>Subject: Re: [patch 3/5] x86, ftrace, hw-branch-tracer: dump on oops
>
>BTW, you have two 1/5 patches but no 2/5 patch.
>
>On Fri, 2009-01-16 at 11:58 +0100, Markus Metzger wrote:
>> Dump the branch trace on an oops (based on ftrace_dump_on_oops).
>
>Does the ftrace_dump_on_oops not work?  We may want to change
>ftrace_dump to see if a tracer has been registered, and use its format
>for output.

It does work and I am using it.
It only works one time, though. Ftrace kills itself before dumping its buffer.

The trace is collected in a separate buffer. trace_hw_branch_oops() reads that buffer and adds the trace to the ftrace buffer, so ftrace can then dump it.


>>       bts_trace_stop(tr);
>>       unregister_hotcpu_notifier(&bts_hotcpu_notifier);
>> +
>> +     hw_branch_trace = NULL;
>
>unless you test hw_branch_trace for content, I usually never NULL the
>local tracer variable. This prevents races. The worst that can happen
>without nulling it, is that your tracer will write into another tracer's
>buffer. No real harm done. But if you have it as null and a race
>happens, you can crash the kernel.

Sounds reasonable. I'll change it.

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

