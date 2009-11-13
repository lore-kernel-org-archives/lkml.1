Return-Path: <linux-kernel-owner+w=401wt.eu-S1754981AbZKMO3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981AbZKMO3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 09:29:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbZKMO32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 09:29:28 -0500
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:56806 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753377AbZKMO32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 09:29:28 -0500
Date: Fri, 13 Nov 2009 15:29:17 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Martin Michlmayr <tbm@cyrius.com>
Cc: Albin Tonnerre <albin.tonnerre@free-electrons.com>,
       akpm@linux-foundation.org, hpa@zytor.com, rmk@arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/4] Add support for LZO-compressed kernels for ARM
Message-ID: <20091113142917.GA12149@Chamillionaire.breakpoint.cc>
References: <1257942478-18719-1-git-send-email-albin.tonnerre@free-electrons.com>
 <1257942478-18719-2-git-send-email-albin.tonnerre@free-electrons.com>
 <1257942478-18719-3-git-send-email-albin.tonnerre@free-electrons.com>
 <20091112125938.GA19698@deprecation.cyrius.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20091112125938.GA19698@deprecation.cyrius.com>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Martin Michlmayr | 2009-11-12 12:59:38 [+0000]:

>* Albin Tonnerre <albin.tonnerre@free-electrons.com> [2009-11-11 13:27]:
>> This is the second part of patch. This part includes:
>>  - changes to ach/arch/boot/Makefile to make it easier to add new
>>    compression types
>> +
>> +# For __aeabi_uidivmod
>> +lib1funcs = $(srctree)/arch/$(SRCARCH)/lib/lib1funcs.o
>
>I build my kernel in a different directory to where the sources are
>stored and I get:
>
>make[7]: *** No rule to make target `/home/tbm/kernel/linux-2.6-2.6.32~rc6/debian/build/source_armel_none/arch/arm/lib/lib1funcs.o', needed by `arch/arm/boot/compressed/vmlinux'.  Stop.
>
>The following patch makes it compile for me:
>
>--- a/arm/boot/compressed/Makefile	2009-11-12 12:26:47.000000000 +0000
>+++ b/arm/boot/compressed/Makefile	2009-11-12 12:26:58.000000000 +0000
>@@ -101,7 +101,7 @@
> LDFLAGS_vmlinux += -T
> 
> # For __aeabi_uidivmod
>-lib1funcs = $(srctree)/arch/$(SRCARCH)/lib/lib1funcs.o
>+lib1funcs = arch/$(SRCARCH)/lib/lib1funcs.o

+lib1funcs = $(obj)/arch/$(SRCARCH)/lib/lib1funcs.o

This is untested but it should refer to obj because you break out of
tree builds (O=) if you don't :)

> 
> # Don't allow any static data in misc.o, which
> # would otherwise mess up our GOT table
>
>-- 
>Martin Michlmayr
>http://www.cyrius.com/

Sebastian
