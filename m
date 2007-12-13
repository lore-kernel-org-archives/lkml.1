Return-Path: <linux-kernel-owner+w=401wt.eu-S933712AbXLNBC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933712AbXLNBC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 20:02:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752497AbXLNBCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 20:02:49 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:36125 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419AbXLNBCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 20:02:48 -0500
X-Greylist: delayed 2108 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Dec 2007 20:02:47 EST
Message-ID: <47619E29.10101@tycho.nsa.gov>
Date: Thu, 13 Dec 2007 16:03:37 -0500
From: Eamon Walsh <ewalsh@tycho.nsa.gov>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Adam Jackson <ajax@redhat.com>, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au
Subject: Re: [PATCH] apm_event{,info}_t are userspace types.
References: <1196452963295-git-send-email-ajax@redhat.com> <20071212024700.19560b60.akpm@linux-foundation.org>
In-Reply-To: <20071212024700.19560b60.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 30 Nov 2007 15:02:43 -0500 Adam Jackson <ajax@redhat.com> wrote:
> 
>> These types define the size of data read from /dev/apm_bios.  They
>> should not be hidden behind #ifdef __KERNEL__.
> 
> Missing info: what are the consequences of this fix?  What id broken when
> it it not applied?

This is killing my xserver compile, apm_event_t is used in the xserver 
source.  The commit that introduced the problem is:

commit ee8e7cfe9d330d6f1ce0b9b1620d6df5d9cf6b70
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Oct 22 10:56:19 2007 +1000

     Make asm-x86/bootparam.h includable from userspace.

     To actually write a bootloader (or, say, the lguest launcher)
     currently requires duplication of these structures.  Making them
     includable from userspace is much nicer.

     We merge the common userspace-required definitions of e820_32/64.h
     into e820.h for export.

     Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

> 
> 
>> ---
>>  include/linux/apm_bios.h |    6 +++---
>>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> Please include Signed-off-by:, as per Documentation/SubmittingPatches,
> thanks.
> 
>> diff --git a/include/linux/apm_bios.h b/include/linux/apm_bios.h
>> index 9754baa..01a6244 100644
>> --- a/include/linux/apm_bios.h
>> +++ b/include/linux/apm_bios.h
>> @@ -18,6 +18,9 @@
>>  
>>  #include <linux/types.h>
>>  
>> +typedef unsigned short	apm_event_t;
>> +typedef unsigned short	apm_eventinfo_t;
>> +
>>  struct apm_bios_info {
>>  	__u16	version;
>>  	__u16	cseg;
>> @@ -32,9 +35,6 @@ struct apm_bios_info {
>>  
>>  #ifdef __KERNEL__
>>  
>> -typedef unsigned short	apm_event_t;
>> -typedef unsigned short	apm_eventinfo_t;
>> -
>>  #define APM_CS		(GDT_ENTRY_APMBIOS_BASE * 8)
>>  #define APM_CS_16	(APM_CS + 8)
>>  #define APM_DS		(APM_CS_16 + 8)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Eamon Walsh <ewalsh@tycho.nsa.gov>
National Security Agency
