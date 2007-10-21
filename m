Return-Path: <linux-kernel-owner+w=401wt.eu-S1752003AbXJUGnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbXJUGnS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 02:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751118AbXJUGnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 02:43:10 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:40273 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbXJUGnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 02:43:08 -0400
Message-ID: <471AF4DE.80705@linux.vnet.ibm.com>
Date: Sun, 21 Oct 2007 12:12:38 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: 2.6.23-mm1 - regression- PowerPC link failure at arch/powerpc/kernel/head_64.o
References: <20071011213126.cf92efb7.akpm@linux-foundation.org> <471465D8.9030100@linux.vnet.ibm.com> <20071016002850.4296827e.akpm@linux-foundation.org> <47146BD4.8000608@linux.vnet.ibm.com>
In-Reply-To: <47146BD4.8000608@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kamalesh Babulal wrote:
> Andrew Morton wrote:
>> On Tue, 16 Oct 2007 12:48:48 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
>>
>>> Hi Andrew,
>>>
>>> The link failure while compiling the kernel with allyesconfig over the lpar, 
>>> which was seen in 2.6.23-rc8-mm2 (http://lkml.org/lkml/2007/9/30/2) is still 
>>> seen in 2.6.23-mm1, the link failure is
>>>
>>> ld: arch/powerpc/kernel/head_64.o(.text+0x80c8): sibling call optimization to `.text.init.refok' does not allow automatic multiple TOCs; recompile with -mminimal-toc or -fno-optimize-sibling-calls, or make `.text.init.refok' extern
>>> ld: arch/powerpc/kernel/head_64.o(.text+0x8160): sibling call optimization to `.text.init.refok' does not allow automatic multiple TOCs; recompile with -mminimal-toc or -fno-optimize-sibling-calls, or make `.text.init.refok' extern
>>> ld: arch/powerpc/kernel/head_64.o(.text+0x81c4): sibling call optimization to `.text.init.refok' does not allow automatic multiple TOCs; recompile with -mminimal-toc or -fno-optimize-sibling-calls, or make `.text.init.refok' extern
>>> ld: final link failed: Bad value
>>> make: *** [.tmp_vmlinux1] Error 1
>>>
>>> # gcc -v
>>> Using built-in specs.
>>> Target: powerpc64-suse-linux
>>> Configured with: ../configure --enable-threads=posix --prefix=/usr --with-local-prefix=/usr/local --infodir=/usr/share/info --mandir=/usr/share/man --libdir=/usr/lib --libexecdir=/usr/lib --enable-languages=c,c++,objc,fortran,obj-c++,java,ada --enable-checking=release --with-gxx-include-dir=/usr/include/c++/4.1.2 --enable-ssp --disable-libssp --disable-libgcj --with-slibdir=/lib --with-system-zlib --enable-shared --enable-__cxa_atexit --enable-libstdcxx-allocator=new --program-suffix=-4.1 --enable-version-specific-runtime-libs --without-system-libunwind --with-cpu=default32 --enable-secureplt --with-long-double-128 --host=powerpc64-suse-linux
>>> Thread model: posix
>>> gcc version 4.1.2 20061115 (prerelease) (SUSE Linux)
>>>
>>> ld -v
>>> GNU ld version 2.17.50.0.5 20060927 (SUSE Linux)
>>>
>>>
>>> Anything I can provide to help diagnose this?
>>>
>> Did we work out which patch is causing this?
>> -
> Hi Andrew,
> No, we did not work out on which patch is causing this ! I will try a bisect to find the patch causing this issue.
> 
Hi Andrew,

After the bisecting, i found that the patch git-net.patch is the cause for the link failure.

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
