Return-Path: <linux-kernel-owner+w=401wt.eu-S1756430AbZCQM0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430AbZCQM0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 08:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755511AbZCQM0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 08:26:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:41198 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbZCQM0n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 08:26:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,378,1233561600"; 
   d="scan'208";a="673581279"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>
Date: Tue, 17 Mar 2009 12:26:21 +0000
Subject: RE: [patch 1/5] x86, bts: detect size of DS fields
Thread-Topic: [patch 1/5] x86, bts: detect size of DS fields
Thread-Index: Acmm7wRbn8xBA9EbQjezeg12DGOnvQABhJ/A
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E4A664285@irsmsx504.ger.corp.intel.com>
References: <20090313104218.A30096@sedona.ch.intel.com>
 <20090313110357.GC31094@elte.hu>
 <928CFBE8E7CB0040959E56B4EA41A77E4A663C47@irsmsx504.ger.corp.intel.com>
 <20090317105558.GK6477@elte.hu>
In-Reply-To: <20090317105558.GK6477@elte.hu>
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
>Sent: Tuesday, March 17, 2009 11:56 AM
>To: Metzger, Markus T


>the bigger problem is the runtime failure (boot warning) that i
>reported. Hence i cannot apply any new patches yet until that is
>resolved.

I found your email at lkml.org.

I think I found the problem:
  ds_request_bts() needs to allocate a small amount of memory.
  It uses GFP_KERNEL.

Hw-branch-tracer essentially does on_each_cpu(ds_request_bts()).


Since ds_request_bts() is meant to be called on the cpu that should
be traced, it should use GFP_ATOMIC to allow calls from smp_call_function()
and friends.

Would that be acceptable?

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

