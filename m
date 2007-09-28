Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249AbXI1KiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbXI1KiH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 06:38:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbXI1Khy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 06:37:54 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:42130 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224AbXI1Khx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 06:37:53 -0400
Message-ID: <46FCD968.8090304@linux.vnet.ibm.com>
Date: Fri, 28 Sep 2007 16:07:28 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       amitkale@linsyssoft.com, trini@kernel.crashing.org
CC: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Jason Wessel <jason.wessel@windriver.com>,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: 2.6.23-rc6-mm1 powerpc - kgdb is broken
References: <46F114D2.40809@linux.vnet.ibm.com> <46F1700D.2020205@windriver.com> <20070919123629.05e3a06c.akpm@linux-foundation.org> <18162.967.558342.829193@cargo.ozlabs.ibm.com> <20070920073817.GA28202@infradead.org>
In-Reply-To: <20070920073817.GA28202@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Thu, Sep 20, 2007 at 03:23:19PM +1000, Paul Mackerras wrote:
>   
>> I could remove all the kgdb support from arch/powerpc as a first step,
>> if that would make it easier to pull in the new stuff...
>>     
>
> Given that the existing powerpc kgdb bits didn't seem to work at all when
> I tried them that seems like a perfectly fine thing to do.
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   
Hi Paul,

The kgdb is also broken with 2.6.23-rc8-mm2 on the powerpc .
The below patch disables the kgdb from getting compiled over
powerpc platform.

Signed-off-by : Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
---

--- linux-2.6.23-rc8/lib/Kconfig.kgdb   2007-09-28 06:33:37.000000000 +0530
+++ linux-2.6.23-rc8/lib/~Kconfig.kgdb  2007-09-28 23:48:33.000000000 +0530
@@ -14,7 +14,7 @@ config KGDB
        bool "KGDB: kernel debugging with remote gdb"
        select WANT_EXTRA_DEBUG_INFORMATION
        select KGDB_ARCH_HAS_SHADOW_INFO if X86_64
-       depends on DEBUG_KERNEL && (ARM || X86 || MIPS || (SUPERH && !SUPERH64) || IA64 || PPC)
+       depends on DEBUG_KERNEL && (ARM || X86 || MIPS || (SUPERH && !SUPERH64) || IA64 || !PPC)
        help
          If you say Y here, it will be possible to remotely debug the
          kernel using gdb.  Documentation of kernel debugger is available

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.

