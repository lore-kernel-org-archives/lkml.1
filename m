Return-Path: <linux-kernel-owner+w=401wt.eu-S1758161AbZCTQYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161AbZCTQYF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 12:24:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbZCTQXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 12:23:52 -0400
Received: from mga03.intel.com ([143.182.124.21]:20898 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704AbZCTQXw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 12:23:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,395,1233561600"; 
   d="scan'208";a="122456530"
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
Date: Fri, 20 Mar 2009 16:23:44 +0000
Subject: RE: [patch] x86, bts: use atomic memory allocation
Thread-Topic: [patch] x86, bts: use atomic memory allocation
Thread-Index: AcmorYajgr4TY41IQQmaIE9N0yHZTQAgkIfwABHi3FA=
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E924000A9@irsmsx504.ger.corp.intel.com>
References: <20090318192700.A6038@sedona.ch.intel.com>
 <20090319161141.GA12144@elte.hu>
 <928CFBE8E7CB0040959E56B4EA41A77E923FFCA4@irsmsx504.ger.corp.intel.com>
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77E923FFCA4@irsmsx504.ger.corp.intel.com>
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
>From: Metzger, Markus T
>Sent: Friday, March 20, 2009 9:08 AM
>To: Ingo Molnar


>>> Ds_request_bts() needs to allocate memory. It uses GFP_KERNEL.
>>>
>>> Hw-branch-tracer calls ds_request_bts() within on_each_cpu().
>>>
>>> Use atomic memory allocation to allow it to be used in that context.
>>
>>the hw-branch-tracer still crashes during bootup. Have you tried the
>>config i sent to you, and have you tried to reproduce it? I've
>>attached another config that crashes.
>
>The first config boots OK.
>The second config boots OK with the additional changes to keep the GFP_KERNEL
>and move the ds_request_bts() calls out of the on_each_cpu() in the hw-branch-tracer.

I must have been asleep this morning.
The first config boots OK.
The second config does not boot, at all. Even if I completely disable DS support in the config.
However, with the new patches, it boots as far as with DS disabled.
It then hangs after CFA self-test.

With DS enabled and without the patches, it stops with a call trace somewhere in
the hw-branch-tracer selftest.


>I then bootet a defconfig kernel with some debugging enabled and I get the following
>message:
>[    1.731080] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
>[    1.731180] swapper/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
>[    1.731180]  (ds_lock){?.+...}, at: [<ffffffff8101560f>] ds_put_context+0x21/0xf3

I fixed this, as well, meanwhile.


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

