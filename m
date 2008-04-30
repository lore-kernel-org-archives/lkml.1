Return-Path: <linux-kernel-owner+w=401wt.eu-S1761750AbYD3MyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761750AbYD3MyH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 08:54:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755880AbYD3Mxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 08:53:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:9327 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754394AbYD3Mxw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 08:53:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,728,1199692800"; 
   d="scan'208";a="378495827"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] /dev/mem gcc weak function workaround
Date: Wed, 30 Apr 2008 05:49:46 -0700
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEEF7D18E@orsmsx423.amr.corp.intel.com>
In-Reply-To: <20080429.212833.192304794.davem@davemloft.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] /dev/mem gcc weak function workaround
Thread-Index: AciqerBweu6gfj5aQqKxaXufiBy6HwARK7tA
References: <20080430013108.GA18207@linux-os.sc.intel.com> <20080429.212833.192304794.davem@davemloft.net>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "David Miller" <davem@davemloft.net>, <trini@kernel.crashing.org>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>,
       <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
X-OriginalArrivalTime: 30 Apr 2008 12:52:52.0374 (UTC) FILETIME=[1A1F7B60:01C8AAC1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: David Miller [mailto:davem@davemloft.net] 
>Sent: Tuesday, April 29, 2008 9:29 PM
>To: Pallipadi, Venkatesh
>Cc: mingo@elte.hu; tglx@linutronix.de; hpa@zytor.com; 
>akpm@linux-foundation.org; linux-kernel@vger.kernel.org
>Subject: Re: [PATCH] /dev/mem gcc weak function workaround
>
>From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
>Date: Tue, 29 Apr 2008 18:31:09 -0700
>
>> Some flavors of gcc 4.1.0 and 4.1.1 seems to have trouble 
>understanding
>> weak function definitions. Calls to function from the same 
>file where it is
>> defined as weak _may_ get inlined, even when there is a 
>non-weak definition of
>> the function elsewhere. I tried using attribute 'noinline' 
>which does not
>> seem to help either.
>> 
>> One workaround for this is to have weak functions defined in 
>different
>> file as below. Other possible way is to not use weak 
>functions and go back
>> to ifdef logic.
>> 
>> There are few other usages in kernel that seem to depend on 
>weak (and noinline)
>> working correctly, which can also potentially break and 
>needs such workarounds.
>> Example -
>> mach_reboot_fixups() in arch/x86/kernel/reboot.c is one such 
>call which
>> is getting inlined with a flavor of gcc 4.1.1.
>> 
>> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
>
>This sounds like a bug.  And if gcc does multi-file compilation it
>can in theory do the same mistake even if you move it to another
>file.
>
>We need something more bulletproof here.
>

The references here
http://gcc.gnu.org/ml/gcc-bugs/2006-05/msg02801.html
http://gcc.gnu.org/bugzilla/show_bug.cgi?id=27781

seem to suggest that the bug is only with weak definition in the same
file.
So, having them in a different file should be good enough workaround
here.

Tom: Comments?

>Also, we have a macro for marking things weak "__weak" which should
>be used here.

Yes. Will change that.

Thanks,
Venki
