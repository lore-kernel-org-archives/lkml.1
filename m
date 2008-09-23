Return-Path: <linux-kernel-owner+w=401wt.eu-S1754798AbYIWVtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbYIWVtf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 17:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751888AbYIWVt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 17:49:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:21754 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbYIWVt0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 17:49:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,295,1220252400"; 
   d="scan'208";a="339703120"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@infradead.org>
Date: Tue, 23 Sep 2008 14:48:54 -0700
Subject: RE: [patch 1/2] x86: track memtype for RAM in page struct
Thread-Topic: [patch 1/2] x86: track memtype for RAM in page struct
Thread-Index: AckWc/e4n/dF6DjHTrK+AevRJTPmywHULQ7A
Message-ID: <7E82351C108FA840AB1866AC776AEC4630BACBB7@orsmsx505.amr.corp.intel.com>
References: <20080913000003.732756000@linux-os.sc.intel.com>
 <20080913000051.819383000@linux-os.sc.intel.com>
 <20080914141230.GB17727@elte.hu>
In-Reply-To: <20080914141230.GB17727@elte.hu>
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
>From: Ingo Molnar [mailto:mingo@elte.hu]
>Sent: Sunday, September 14, 2008 7:13 AM
>To: Pallipadi, Venkatesh
>Cc: arjan@linux.intel.com; tglx@linutronix.de; hpa@zytor.com;
>andi@firstfloor.org; linux-kernel@vger.kernel.org; Siddha,
>Suresh B; Arjan van de Ven
>Subject: Re: [patch 1/2] x86: track memtype for RAM in page struct
>
>
>* Venkatesh Pallipadi <venkatesh.pallipadi@intel.com> wrote:
>
>> From: Suresh Siddha <suresh.b.siddha@intel.com>
>> Subject: [patch 1/2] x86: track memtype for RAM in page struct
>>
>> Track the memtype for RAM pages in page struct instead of using the
>> memtype list. This avoids the explosion in the number of entries in
>> memtype list (of the order of 20,000 with AGP) and makes the PAT
>> tracking simpler. We are using PG_arch_1 bit in page->flags.
>
>this is in contradiction to this comment:
>
>>  /*
>> + * RED-PEN:  TODO: Add PageReserved() check aswell here,
>> + * once we add SetPageReserved() to all the drivers using
>> + * set_memory_* or set_pages_*
>
>if it's marked PG_arch_1, why is there any need for PageReserved?
>

Marking PageReserved will take care of all the places where Reserved is being checked,
like swap etc. And we don't have to add checks for extra bit in architecture independent
code.

Thanks,
Venki
