Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbYAJUfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbYAJUfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 15:35:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbYAJUfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 15:35:13 -0500
Received: from mga03.intel.com ([143.182.124.21]:2741 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbYAJUfL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 15:35:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,267,1196668800"; 
   d="scan'208";a="363729162"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch 07/11] PAT x86: pat-conflict resolution using linear list
Date: Thu, 10 Jan 2008 12:08:16 -0800
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE5A2890@orsmsx423.amr.corp.intel.com>
In-Reply-To: <p73r6gpmr3v.fsf@bingen.suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 07/11] PAT x86: pat-conflict resolution using linear list
Thread-Index: AchTvXmh8KV5hX4pTDa/E9dm2jTlzQAASHKA
References: <20080110184840.927409000@intel.com><20080110184855.906407000@intel.com> <p73r6gpmr3v.fsf@bingen.suse.de>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Andi Kleen" <andi@firstfloor.org>
Cc: <ebiederm@xmission.com>, <rdreier@cisco.com>,
       <torvalds@linux-foundation.org>, <gregkh@suse.de>, <airlied@skynet.ie>,
       <davej@redhat.com>, <mingo@elte.hu>, <tglx@linutronix.de>,
       <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
X-OriginalArrivalTime: 10 Jan 2008 20:07:22.0697 (UTC) FILETIME=[6964D390:01C853C4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>-----Original Message-----
>From: Andi Kleen [mailto:andi@firstfloor.org] 
>Sent: Thursday, January 10, 2008 11:13 AM
>To: Pallipadi, Venkatesh
>Cc: ebiederm@xmission.com; rdreier@cisco.com; 
>torvalds@linux-foundation.org; gregkh@suse.de; 
>airlied@skynet.ie; davej@redhat.com; mingo@elte.hu; 
>tglx@linutronix.de; hpa@zytor.co; 
>linux-kernel@vger.kernel.org; Siddha, Suresh B
>Subject: Re: [patch 07/11] PAT x86: pat-conflict resolution 
>using linear list
>
>venkatesh.pallipadi@intel.com writes:
>>  
>>  	/* Reset the direct mapping. Can block */
>> -	if (p->flags >> 20)
>> -		ioremap_change_attr(p->phys_addr, p->size, 0);
>> +	if (p->flags >> 20) {
>> +		free_mattr(p->phys_addr, p->phys_addr + 
>get_vm_area_size(p),
>> +		           p->flags>>20);
>> +		ioremap_change_attr(p->phys_addr, 
>get_vm_area_size(p), 0);
>
>If you really unmap all holes and forbid (or let it just return the
>__va address) ioremap on anything mapped (which is probably ok) then
>you can eliminate that completely.
>

We heard X can allocate a page and then map it UC using it through gart.
So, I don't we can forbid all ioremaps for RAM.

Thanks,
Venki
