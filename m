Return-Path: <linux-kernel-owner+w=401wt.eu-S1760999AbYAJTYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760999AbYAJTYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:24:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760936AbYAJTYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:24:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:21583 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760930AbYAJTYc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:24:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,267,1196668800"; 
   d="scan'208";a="251997259"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch 09/11] PAT x86: Add ioremap_wc support
Date: Thu, 10 Jan 2008 11:25:25 -0800
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE5A281A@orsmsx423.amr.corp.intel.com>
In-Reply-To: <p733at5o5vr.fsf@bingen.suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 09/11] PAT x86: Add ioremap_wc support
Thread-Index: AchTvDkPXeQ7IrrrTi2h9/RQ4YiGTwAAS8OQ
References: <20080110184840.927409000@intel.com><20080110184856.379082000@intel.com> <p733at5o5vr.fsf@bingen.suse.de>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Andi Kleen" <andi@firstfloor.org>
Cc: <ebiederm@xmission.com>, <rdreier@cisco.com>,
       <torvalds@linux-foundation.org>, <gregkh@suse.de>, <airlied@skynet.ie>,
       <davej@redhat.com>, <mingo@elte.hu>, <tglx@linutronix.de>,
       <hpa@zytor.co>, <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
X-OriginalArrivalTime: 10 Jan 2008 19:24:31.0584 (UTC) FILETIME=[6CE41E00:01C853BE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>-----Original Message-----
>From: Andi Kleen [mailto:andi@firstfloor.org] 
>Sent: Thursday, January 10, 2008 11:09 AM
>To: Pallipadi, Venkatesh
>Cc: ebiederm@xmission.com; rdreier@cisco.com; 
>torvalds@linux-foundation.org; gregkh@suse.de; 
>airlied@skynet.ie; davej@redhat.com; mingo@elte.hu; 
>tglx@linutronix.de; hpa@zytor.co; 
>linux-kernel@vger.kernel.org; Siddha, Suresh B
>Subject: Re: [patch 09/11] PAT x86: Add ioremap_wc support
>
>venkatesh.pallipadi@intel.com writes:
>> Index: linux-2.6.git/include/asm-generic/iomap.h
>> ===================================================================
>> --- linux-2.6.git.orig/include/asm-generic/iomap.h	
>2008-01-08 03:31:37.000000000 -0800
>> +++ linux-2.6.git/include/asm-generic/iomap.h	
>2008-01-08 05:15:56.000000000 -0800
>> @@ -65,4 +65,8 @@
>>  extern void __iomem *pci_iomap(struct pci_dev *dev, int 
>bar, unsigned long max);
>>  extern void pci_iounmap(struct pci_dev *dev, void __iomem *);
>>  
>> +#ifndef ioremap_wc
>> +#define ioremap_wc ioremap_nocache
>> +#endif
>
>I don't think that's a good idea. Drivers should be able to 
>detect this somehow.
>Handling UC mappings as WC will probably give very poor results.
>

It is the other way. ioremap_wc aliases to ioremap_nocache.
This was based on earlier feedback from Roland.
>From: Roland Dreier [mailto:rdreier@cisco.com] 
>I think ioremap_wc() needs to be available on all archs for this to be
>really useful to drivers.  It can be a fallback to ioremap_nocache()
>everywhere except 64-bit x86, but it's not nice for every driver that
>wants to use this to need an "#ifdef X86" or whatever.

Thanks,
Venki
