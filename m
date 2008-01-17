Return-Path: <linux-kernel-owner+w=401wt.eu-S1756581AbYAQTiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581AbYAQTiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 14:38:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbYAQTh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 14:37:59 -0500
Received: from mga03.intel.com ([143.182.124.21]:45236 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbYAQTh5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 14:37:57 -0500
X-ExtLoop1: 1
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [-mm Patch] uml: fix a building error
Date: Thu, 17 Jan 2008 11:38:53 -0800
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE5E90DF@orsmsx423.amr.corp.intel.com>
In-Reply-To: <20080117105606.ff89e9e9.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [-mm Patch] uml: fix a building error
Thread-Index: AchZOp3yRYwEYYuDRDCinMrWzOdevgABW0OQ
References: <20080117023514.9df393cf.akpm@linux-foundation.org><20080117135641.GD2693@hacking><200801171911.16230.m.kozlowski@tuxland.pl> <20080117105606.ff89e9e9.akpm@linux-foundation.org>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       "Mariusz Kozlowski" <m.kozlowski@tuxland.pl>
Cc: "WANG Cong" <xiyou.wangcong@gmail.com>, <linux-kernel@vger.kernel.org>,
       "Jeff Dike" <jdike@addtoit.com>,
       <user-mode-linux-devel@lists.sourceforge.net>,
       "David Miller" <davem@davemloft.net>, <sparclinux@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>
X-OriginalArrivalTime: 17 Jan 2008 19:37:56.0180 (UTC) FILETIME=[755BF940:01C85940]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Andrew Morton [mailto:akpm@linux-foundation.org] 
>Sent: Thursday, January 17, 2008 10:56 AM
>To: Mariusz Kozlowski
>Cc: WANG Cong; linux-kernel@vger.kernel.org; Jeff Dike; 
>user-mode-linux-devel@lists.sourceforge.net; David Miller; 
>sparclinux@vger.kernel.org; Ingo Molnar; Thomas Gleixner; 
>Pallipadi, Venkatesh
>Subject: Re: [-mm Patch] uml: fix a building error
>
>On Thu, 17 Jan 2008 19:11:13 +0100 Mariusz Kozlowski 
><m.kozlowski@tuxland.pl> wrote:
>
>> Hello,
>> 
>> > This patch fixes this building error:
>> > ...
>> > drivers/char/mem.c: In function 'read_mem':
>> > drivers/char/mem.c:136: error: implicit declaration of 
>function 'unxlate_dev_mem_ptr'
>> > ...
>> 
>> I see this on sparc64 as well:
>> 
>>   CC      drivers/char/mem.o
>> drivers/char/mem.c: In function 'read_mem':
>> drivers/char/mem.c:136: error: implicit declaration of 
>function 'unxlate_dev_mem_ptr'
>> make[2]: *** [drivers/char/mem.o] Error 1
>> make[1]: *** [drivers/char] Error 2
>> make: *** [drivers] Error 2
>> 
>> Does sparc64 need similar fix?
>> 
>
>The PAT patches strike again.
>
>Ingo, I think you might need to toss some cross-compilers into 
>that build
>test setup of yours.
>

These functions were defined for other archs in asm-generic/iomap.h.
We need all archs including it in io.h. I now see only few archs are
including it..

Apart from unxlate, there is also ioremap_wc which is defined in the
same way.

I can send a patch for this. But, I don't have cross compiler setup for
all archs to test. Andrew, I will need your help.

Thanks,
Venki
