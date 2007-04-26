Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbXDZGF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbXDZGF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 02:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754758AbXDZGF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 02:05:29 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:59746 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754AbXDZGF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 02:05:26 -0400
Message-ID: <463041BC.8000708@oracle.com>
Date: Wed, 25 Apr 2007 23:07:56 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>, ak@suse.de
Subject: Re: [PATCH -mm] x86_64: kill 19000+ sparse warnings
References: <20070425224509.46153baa.randy.dunlap@oracle.com> <20070425225516.8b573d34.akpm@linux-foundation.org>
In-Reply-To: <20070425225516.8b573d34.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 25 Apr 2007 22:45:09 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> Eliminate 19439 (!!) sparse warnings like:
>> include/linux/mm.h:321:22: warning: constant 0xffff810000000000 is so big it is unsigned long
>>
>> Eliminate 56 sparse warnings like:
>> arch/x86_64/kernel/setup.c:248:16: warning: constant 0xffffffff80000000 is so big it is unsigned long
>>
>> Eliminate 5 sparse warnings like:
>> arch/x86_64/kernel/module.c:49:13: warning: constant 0xfffffffffff00000 is so big it is unsigned long
>>
>> Eliminate 23 sparse warnings like:
>> arch/x86_64/mm/init.c:551:37: warning: constant 0xffffc20000000000 is so big it is unsigned long
>>
>> Eliminate 6 sparse warnings like:
>> arch/x86_64/kernel/module.c:49:13: warning: constant 0xffffffff88000000 is so big it is unsigned long
>>
>> Eliminate 23 sparse warnings like:
>> arch/x86_64/mm/init.c:552:6: warning: constant 0xffffe1ffffffffff is so big it is unsigned long
>>
>> Eliminate 3 sparse warnings like:
>> arch/x86_64/kernel/e820.c:186:17: warning: constant 0x3fffffffffff is so big it is long
>>
>> ...
>>
>> +#ifdef __ASSEMBLY__
>>  #define MAXMEM		 0x3fffffffffff
>>  #define VMALLOC_START    0xffffc20000000000
>>  #define VMALLOC_END      0xffffe1ffffffffff
>>  #define MODULES_VADDR    0xffffffff88000000
>>  #define MODULES_END      0xfffffffffff00000
>>  #define MODULES_LEN   (MODULES_END - MODULES_VADDR)
>> +#else
>> +#define MAXMEM		 0x3fffffffffffUL
>> +#define VMALLOC_START    0xffffc20000000000UL
>> +#define VMALLOC_END      0xffffe1ffffffffffUL
>> +#define MODULES_VADDR    0xffffffff88000000UL
>> +#define MODULES_END      0xfffffffffff00000UL
>> +#define MODULES_LEN   (MODULES_END - MODULES_VADDR)
>> +#endif
>>  
> 
> hm, the duplication is unfortunate.

Yep.

> I wonder if it's worth doing a cpp token-pasting trick to avoid having to
> do that.

oh.  there is already an include/asm-x86_64/const.h that will help
with that.  I'll try it out.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
