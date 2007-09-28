Return-Path: <linux-kernel-owner+w=401wt.eu-S1755778AbXI1M2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778AbXI1M2h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 08:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbXI1M23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 08:28:29 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:50756 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbXI1M22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 08:28:28 -0400
Message-ID: <46FCF365.6020109@linux.vnet.ibm.com>
Date: Fri, 28 Sep 2007 17:58:21 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       amitkale@linsyssoft.com, trini@kernel.crashing.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Jason Wessel <jason.wessel@windriver.com>,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: 2.6.23-rc6-mm1 powerpc - kgdb is broken [Resending PATCH]
References: <46F114D2.40809@linux.vnet.ibm.com> <46F1700D.2020205@windriver.com> <20070919123629.05e3a06c.akpm@linux-foundation.org> <18162.967.558342.829193@cargo.ozlabs.ibm.com> <20070920073817.GA28202@infradead.org>  <46FCD968.8090304@linux.vnet.ibm.com> <1190976441.18681.34.camel@chaos>
In-Reply-To: <1190976441.18681.34.camel@chaos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Fri, 2007-09-28 at 16:07 +0530, Kamalesh Babulal wrote:
>   
>> The kgdb is also broken with 2.6.23-rc8-mm2 on the powerpc .
>> The below patch disables the kgdb from getting compiled over
>> powerpc platform.
>>
>> Signed-off-by : Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
>> ---
>>
>> --- linux-2.6.23-rc8/lib/Kconfig.kgdb   2007-09-28 06:33:37.000000000 +0530
>> +++ linux-2.6.23-rc8/lib/~Kconfig.kgdb  2007-09-28 23:48:33.000000000 +0530
>> @@ -14,7 +14,7 @@ config KGDB
>>         bool "KGDB: kernel debugging with remote gdb"
>>         select WANT_EXTRA_DEBUG_INFORMATION
>>         select KGDB_ARCH_HAS_SHADOW_INFO if X86_64
>> -       depends on DEBUG_KERNEL && (ARM || X86 || MIPS || (SUPERH && !SUPERH64) || IA64 || PPC)
>> +       depends on DEBUG_KERNEL && (ARM || X86 || MIPS || (SUPERH && !SUPERH64) || IA64 || !PPC)
>>     
>
> This enables the KGDB config for _ALL_ platforms except powerpc. 
>
> Just remove PPC completely.
>
> 	tglx
>   
Thanks thomas for the suggestion, resending the patch.

Signed-off-by : Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
---

--- linux-2.6.23-rc8/lib/Kconfig.kgdb   2007-09-28 17:46:55.000000000 +0530
+++ linux-2.6.23-rc8/lib/~Kconfig.kgdb  2007-09-28 17:51:43.000000000 +0530
@@ -14,7 +14,7 @@ config KGDB
        bool "KGDB: kernel debugging with remote gdb"
        select WANT_EXTRA_DEBUG_INFORMATION
        select KGDB_ARCH_HAS_SHADOW_INFO if X86_64
-       depends on DEBUG_KERNEL && (ARM || X86 || MIPS || (SUPERH && !SUPERH64) || IA64 || PPC)
+       depends on DEBUG_KERNEL && (ARM || X86 || MIPS || (SUPERH && !SUPERH64) || IA64)
        help
          If you say Y here, it will be possible to remotely debug the
          kernel using gdb.  Documentation of kernel debugger is available

-- 

Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.

