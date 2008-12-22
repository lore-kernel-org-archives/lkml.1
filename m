Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbYLVPC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbYLVPC3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 10:02:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754629AbYLVPCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 10:02:21 -0500
Received: from mga09.intel.com ([134.134.136.24]:37913 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754135AbYLVPCU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 10:02:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,263,1228118400"; 
   d="scan'208";a="372888931"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "eranian@gmail.com" <eranian@gmail.com>
CC: "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>,
       "Villacis, Juan" <juan.villacis@intel.com>
Date: Mon, 22 Dec 2008 15:02:09 +0000
Subject: RE: [patch] x86, ptrace: require admin privileges for ptrace BTS
 extension
Thread-Topic: [patch] x86, ptrace: require admin privileges for ptrace BTS
 extension
Thread-Index: AclkOJZEx4l1z3oRSXeanC/oZSHFoAADBSdw
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E0CC3B06E@irsmsx504.ger.corp.intel.com>
References: <20081222130218.A31747@sedona.ch.intel.com>
 <7c86c4470812220523y7ccca8cag40f758393017cf7c@mail.gmail.com>
In-Reply-To: <7c86c4470812220523y7ccca8cag40f758393017cf7c@mail.gmail.com>
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
>From: stephane eranian [mailto:eranian@googlemail.com] 
>Sent: Montag, 22. Dezember 2008 14:24
>To: Metzger, Markus T

>On Mon, Dec 22, 2008 at 1:02 PM, Markus Metzger
><markus.t.metzger@intel.com> wrote:
>> Require admin privileges for ptrace BTS extension.
>>
>Can you explain the motivations for this?
>
>I thought the BTS extension was a per-process functionality.
>So how come I can debug and single step my process without
>admin privilege and I cannot capture its own branches. Does this
>have to do with user vs. kernel execution of the proces (BTS
>captures everything if I recall)?

Ingo requested this as a precaution.
We found a bug: the DS context pointer is not cleared on fork.
The bug is fixed in tip/master but the fix is considered too intrusive to be promoted that late.
The restriction will be removed once the fix is in.

regards,
markus.



>
>Thanks.
>
>>
>> Reported-by: Ingo Molnar <mingo@elte.hu>
>> Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
>> ---
>>
>> Index: gits/arch/x86/kernel/ptrace.c
>> ===================================================================
>> --- gits.orig/arch/x86/kernel/ptrace.c  2008-12-22 
>09:09:25.000000000 +0100
>> +++ gits/arch/x86/kernel/ptrace.c       2008-12-22 
>11:03:01.000000000 +0100
>> @@ -21,6 +21,7 @@
>>  #include <linux/audit.h>
>>  #include <linux/seccomp.h>
>>  #include <linux/signal.h>
>> +#include <linux/capability.h>
>>
>>  #include <asm/uaccess.h>
>>  #include <asm/pgtable.h>
>> @@ -742,6 +743,10 @@
>>        struct ptrace_bts_config cfg;
>>        int error = 0;
>>
>> +       error = -EPERM;
>> +       if (!capable(CAP_SYS_ADMIN))
>> +               goto errout;
>> +
>>        error = -EOPNOTSUPP;
>>        if (!bts_cfg.sizeof_bts)
>>                goto errout;
>> ---------------------------------------------------------------------
>> Intel GmbH
>> Dornacher Strasse 1
>> 85622 Feldkirchen/Muenchen Germany
>> Sitz der Gesellschaft: Feldkirchen bei Muenchen
>> Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
>> Registergericht: Muenchen HRB 47456 Ust.-IdNr.
>> VAT Registration No.: DE129385895
>> Citibank Frankfurt (BLZ 502 109 00) 600119052
>>
>> This e-mail and any attachments may contain confidential material for
>> the sole use of the intended recipient(s). Any review or distribution
>> by others is strictly prohibited. If you are not the intended
>> recipient, please contact the sender and delete all copies.
>>
>>
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

