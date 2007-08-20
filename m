Return-Path: <linux-kernel-owner+w=401wt.eu-S1761377AbXHTXWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761377AbXHTXWB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 19:22:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbXHTXVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 19:21:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:48896 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960AbXHTXVw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 19:21:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,286,1183359600"; 
   d="scan'208";a="281521866"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH -mm] IOAT: fix for UP use of cpu_physical_id()
Date: Mon, 20 Aug 2007 16:21:44 -0700
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C02E51CDD@orsmsx418.amr.corp.intel.com>
In-Reply-To: <46CA1533.2040200@zytor.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH -mm] IOAT: fix for UP use of cpu_physical_id()
Thread-Index: AcfjeT5v4e+K9Yu0Sv6V4qA0L/pCMQABTHSw
References: <20070820202908.14306.31248.stgit@localhost.localdomain> <46CA1533.2040200@zytor.com>
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       <chris.leech@gmail.com>, <ak@suse.de>,
       "Luck, Tony" <tony.luck@intel.com>
X-OriginalArrivalTime: 20 Aug 2007 23:21:45.0691 (UTC) FILETIME=[E0023AB0:01C7E380]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: H. Peter Anvin [mailto:hpa@zytor.com] 
>Sent: Monday, August 20, 2007 3:27 PM
>To: Nelson, Shannon
>Cc: akpm@linux-foundation.org; linux-kernel@vger.kernel.org; 
>chris.leech@gmail.com; ak@suse.de; Luck, Tony
>Subject: Re: [PATCH -mm] IOAT: fix for UP use of cpu_physical_id()
>
>Shannon Nelson wrote:
>> Make sure we can use cpu_physical_id() even when compiled for
>> uni-processor.
>> 
>> diff --git a/drivers/dma/ioat_dca.c b/drivers/dma/ioat_dca.c
>> index c3a500b..b1af49c 100644
>> --- a/drivers/dma/ioat_dca.c
>> +++ b/drivers/dma/ioat_dca.c
>> @@ -25,6 +25,14 @@
>>  #include <linux/smp.h>
>>  #include <linux/interrupt.h>
>>  #include <linux/dca.h>
>> +
>> +// either a kernel change is needed, or we need something 
>like this in kernel
>> +#ifndef CONFIG_SMP
>> +#include <asm/smp.h>
>> +#undef cpu_physical_id
>> +#define cpu_physical_id(cpu) (cpuid_ebx(1) >> 24)
>> +#endif
>> +
>
>This value should probably be cached.  Executing cpuid to get a static
>value seems like a bad idea.

Yeah, this whole cpu_physical_id() gizmo needs to be fixed so it is
actually usable for non-SMP configurations.  Unfortunately, I'm not the
guy to do it.

sln
--
======================================================================
Mr. Shannon Nelson                 LAN Access Division, Intel Corp.
Shannon.Nelson@intel.com                I don't speak for Intel
(503) 712-7659                    Parents can't afford to be squeamish.
