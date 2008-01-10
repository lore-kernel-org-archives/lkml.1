Return-Path: <linux-kernel-owner+w=401wt.eu-S1757292AbYAJW2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292AbYAJW2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 17:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754855AbYAJW2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 17:28:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:38760 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754596AbYAJW2N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 17:28:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,268,1196668800"; 
   d="scan'208";a="320860814"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch 02/11] PAT x86: Map only usable memory in x86_64 identity map and kernel text
Date: Thu, 10 Jan 2008 14:27:10 -0800
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE5A29A5@orsmsx423.amr.corp.intel.com>
In-Reply-To: <alpine.LFD.1.00.0801101413490.3148@woody.linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 02/11] PAT x86: Map only usable memory in x86_64 identity map and kernel text
Thread-Index: AchT1vutDkseaWHxSx+H9vyaOSC7agAAMqiw
References: <20080110184840.927409000@intel.com> <20080110184854.787474000@intel.com> <alpine.LFD.1.00.0801101303570.3148@woody.linux-foundation.org> <924EFEDD5F540B4284297C4DC59F3DEE5A2958@orsmsx423.amr.corp.intel.com> <alpine.LFD.1.00.0801101413490.3148@woody.linux-foundation.org>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: <ak@muc.de>, <ebiederm@xmission.com>, <rdreier@cisco.com>,
       <gregkh@suse.de>, <airlied@skynet.ie>, <davej@redhat.com>,
       <mingo@elte.hu>, <tglx@linutronix.de>, <akpm@linux-foundation.org>,
       <arjan@infradead.org>, "Barnes, Jesse" <jesse.barnes@intel.com>,
       <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
X-OriginalArrivalTime: 10 Jan 2008 22:26:19.0793 (UTC) FILETIME=[D2B0B810:01C853D7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Linus Torvalds [mailto:torvalds@linux-foundation.org] 
>Sent: Thursday, January 10, 2008 2:15 PM
>To: Pallipadi, Venkatesh
>Cc: ak@muc.de; ebiederm@xmission.com; rdreier@cisco.com; 
>gregkh@suse.de; airlied@skynet.ie; davej@redhat.com; 
>mingo@elte.hu; tglx@linutronix.de; akpm@linux-foundation.org; 
>arjan@infradead.org; Barnes, Jesse; davem@davemloft.net; 
>linux-kernel@vger.kernel.org; Siddha, Suresh B
>Subject: RE: [patch 02/11] PAT x86: Map only usable memory in 
>x86_64 identity map and kernel text
>
>
>
>On Thu, 10 Jan 2008, Pallipadi, Venkatesh wrote:
>> 
>> Yes. I had those pages not mapped at all earlier. The reason 
>I switched
>> to zero page is to continue support cases like:
>>  BIOS-e820: 0000000000000000 - 000000000009cc00 (usable)
>>  BIOS-e820: 000000000009cc00 - 00000000000a0000 (reserved)
>>  BIOS-e820: 00000000000cc000 - 00000000000d0000 (reserved)
>>  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
>>  BIOS-e820: 0000000000100000 - 00000000cff60000 (usable)
>> 
>> In this case if some one does a dd of /dev/mem before they 
>can read the
>> contents of usable memory in 0x100000-0xcff60000 range.
>
>Well, I think that /dev/mem should simply give them the right 
>info. That's 
>what people use /dev/mem for - doing things like reading BIOS 
>images etc. 
>
>So returning *either* a zero page *or* stopping at the first 
>hole is both 
>equally wrong. 
>

I was not fully clear in my earlier email. Mapping /dev/mem would still
work with our changes. As they go through proper map interface. It is
the dd of dev mem which does the read that has the problem. I was
wondering of apps using dd.

Thanks,
Venki
