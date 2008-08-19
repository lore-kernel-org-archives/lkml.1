Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbYHSFYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbYHSFYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 01:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbYHSFYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 01:24:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:38976 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbYHSFYI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 01:24:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,233,1217833200"; 
   d="scan'208";a="371760925"
From: "Li, Shaohua" <shaohua.li@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Date: Tue, 19 Aug 2008 13:24:03 +0800
Subject: RE: [patch]pageattr: cache flush before tlb flush
Thread-Topic: [patch]pageattr: cache flush before tlb flush
Thread-Index: AckBumTzQmvgz1DjQSWkY0s+SUN/qQAAUpzg
Message-ID: <76780B19A496DC4B80439008DAD7076C0D000E86@PDSMSX501.ccr.corp.intel.com>
References: <1219026451.16428.4.camel@sli10-desk.sh.intel.com>
 <48AA559A.6060903@zytor.com>
In-Reply-To: <48AA559A.6060903@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: H. Peter Anvin [mailto:hpa@zytor.com]
>Sent: Tuesday, August 19, 2008 1:10 PM
>To: Li, Shaohua
>Cc: lkml; Andrew Morton; Ingo Molnar; Pallipadi, Venkatesh
>Subject: Re: [patch]pageattr: cache flush before tlb flush
>
>Shaohua Li wrote:
>> clflush uses a virtual address but cache line is physical indexed in
>> x86. In my understanding, clflush will do some pagetable walk, so doing
>> cache flush first should reduce some pagetable walk.
>>
>> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
>
>I would say NAK on this.
>
>Doing the CLFLUSH first does cut down on page table walking, but opens a
>hole in the sequencing: first set PAT to an uncachable mode, then flush.
>
>If an unlucky prefetch comes in during this window, then you will have a
>dirty cache again.
>
>So no, this is not a good idea.
Ok, looks possible in theory.

Thanks,
Shaohua
