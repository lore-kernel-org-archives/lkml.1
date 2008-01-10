Return-Path: <linux-kernel-owner+w=401wt.eu-S1759262AbYAJTRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759262AbYAJTRg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:17:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbYAJTR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:17:28 -0500
Received: from mga11.intel.com ([192.55.52.93]:47406 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184AbYAJTR1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:17:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,267,1196668800"; 
   d="scan'208";a="283396877"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch 02/11] PAT x86: Map only usable memory in x86_64 identity map and kernel text
Date: Thu, 10 Jan 2008 11:17:07 -0800
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE5A2805@orsmsx423.amr.corp.intel.com>
In-Reply-To: <p737iiho5yq.fsf@bingen.suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 02/11] PAT x86: Map only usable memory in x86_64 identity map and kernel text
Thread-Index: AchTvBomqeVXFlSzTPaJ53BoRaCNjwAAEaLQ
References: <20080110184840.927409000@intel.com><20080110184854.787474000@intel.com> <p737iiho5yq.fsf@bingen.suse.de>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Andi Kleen" <andi@firstfloor.org>
Cc: <ebiederm@xmission.com>, <rdreier@cisco.com>,
       <torvalds@linux-foundation.org>, <gregkh@suse.de>, <airlied@skynet.ie>,
       <davej@redhat.com>, <mingo@elte.hu>, <tglx@linutronix.de>,
       <hpa@zytor.co>, <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
X-OriginalArrivalTime: 10 Jan 2008 19:16:14.0783 (UTC) FILETIME=[44C64CF0:01C853BD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: linux-kernel-owner@vger.kernel.org 
>[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Andi Kleen
>Sent: Thursday, January 10, 2008 11:07 AM
>To: Pallipadi, Venkatesh
>Cc: ebiederm@xmission.com; rdreier@cisco.com; 
>torvalds@linux-foundation.org; gregkh@suse.de; 
>airlied@skynet.ie; davej@redhat.com; mingo@elte.hu; 
>tglx@linutronix.de; hpa@zytor.co; 
>linux-kernel@vger.kernel.org; Siddha, Suresh B
>Subject: Re: [patch 02/11] PAT x86: Map only usable memory in 
>x86_64 identity map and kernel text
>
>venkatesh.pallipadi@intel.com writes:
>
>> x86_64: Map only usable memory in identity map. 
>
>I don't think that is needed or makes sense for reserved/ACPI * etc. 
>Only e820 holes should be truly unmapped because only those should
>contain mmio.

Do you mean just the regions that are not listed in e820 at all? We
should also not map anything marked "RESERVED" in e820. Right?

>> All reserved memory maps to a
>> zero page. 
>
>Why zero page?  Why not unmap.

I had it unmapped first. Then thought of zero mapping for dd of devmem
to continue working. May be there are apps that depend on that?
Also, dd of devmem seems to be already broken with big memory without
any of these changes.
 
>Anyways you could make that a zillion times more simple by 
>just rounding
>the e820 areas to 2MB -- for the holes only that should be ok I think; 
>i would expect them to be near always already suitably aligned.
>
>In short this can be all done much simpler.

On systems I tested, ACPI regions are typically not 2MB aligned. And on
some systems there are few 4k pages of reserved holes just before
0xa0000. PCI reserved regions are 2MB aligned however. I agree that
making this 2MB aligned will make this patch a lot simpler. But, not all
reserved regions seems to be aligned that way.

Thanks,
Venki
