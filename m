Return-Path: <linux-kernel-owner+w=401wt.eu-S932115AbXHHNqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115AbXHHNqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 09:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbXHHNqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 09:46:25 -0400
Received: from mga03.intel.com ([143.182.124.21]:5418 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825AbXHHNqY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 09:46:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,236,1183359600"; 
   d="scan'208";a="260470359"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 5/5] x86_64 EFI support -v3: EFI document
Date: Wed, 8 Aug 2007 21:46:15 +0800
Message-ID: <9D7649D18729DE4BB2BD7B494F7FEDC246DC2B@pdsmsx415.ccr.corp.intel.com>
In-Reply-To: <200708081208.01080.ak@suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 5/5] x86_64 EFI support -v3: EFI document
Thread-Index: AcfZpEOubAzrT1rySEufv4w2F4alhgAGkKIg
From: "Huang, Ying" <ying.huang@intel.com>
To: "Andi Kleen" <ak@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, <akpm@linux-foundation.org>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Chandramouli Narayanan" <mouli@linux.intel.com>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 08 Aug 2007 13:46:16.0871 (UTC) FILETIME=[7E456B70:01C7D9C2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Andi Kleen [mailto:ak@suse.de]
>Subject: Re: [PATCH 5/5] x86_64 EFI support -v3: EFI document
>> The needed code changing is minimal. In fact, I can boot 32bit Linux
>> kernel on my x86_64 EFI machine. With setup as follow:
>>
>> 1. Apply the efi-fb.patch
>Just for the frame buffer, right?

Yes.

>> 2. make efi fb driver not depend on EFI
>> 3. configure kernel as follow:
>>    a. CONFIG_EFI is turned off
>>    b. CONFIG_FB_EFI is turned on
>
>Hmm, how does the 32bit kernel know where the e820 map is passed then?
>With CONFIG_EFI turned off it will just ask the real mode BIOS I think
>and I doubt elilo simulates that.

I have not tested elilo. I use another x86_64 EFI boot loader (it will
be released soon), but elilo works in the same way, and I will test
elilo later. The 16bit entry of kernel (arch/(i386|x86_64)/boot/setup.S)
is not used by elilo. Instead, elilo collects the needed information
defined in include/asm-x86_64/bootsetup.h itself, and passes it to
kernel 32bit entry (arch/(i386|x86_64)/boot/compressed/head.S). For E820
map, the elilo converts the EFI memory map to E820 map in "boot
parameters memory" which is copied to "boot_params" or "x86_boot_params"
by Linux kernel later.

>Or did you apply more patches?

No, just the frame buffer patch.

Best Regards,
Huang Ying
