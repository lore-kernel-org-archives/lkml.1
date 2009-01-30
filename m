Return-Path: <linux-kernel-owner+w=401wt.eu-S1756144AbZA3Uk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbZA3Uk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 15:40:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754640AbZA3Ukv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 15:40:51 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:60239 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635AbZA3Uku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 15:40:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [git pull V2] headers_check fixes
Date: Fri, 30 Jan 2009 21:40:36 +0100
User-Agent: KMail/1.9.9
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <1233342254.21493.8.camel@localhost.localdomain> <20090130192627.GA32705@elte.hu>
In-Reply-To: <20090130192627.GA32705@elte.hu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901302140.37432.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+HVkpwgbjcqXJpSovNlJBYEL92qM9WUf7MO4/
 +0KTPIADZwpr2a8r9WpVvvjxDdBdmem/DJmwTL+/DjZmBtNjAD
 bsMm+bz7SqEI28Eluy0hg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 January 2009, Ingo Molnar wrote:
> Sam, would you mind to remove the CONFIG_* warnings from headers_check, 
> and get that commit to Linus ASAP? (or we can put it into this branch too, 
> if you prefer it that way)
> 
> Those warnings wont be worked around in the headers and that check litters 
> the CONFIG_HEADER_CHECK=y build with warnings right now and make it 
> impossible to reach a warning-free build.

I double-checked the remaining CONFIG_* warnings in this version to make sure
that we are not dropping any warnings about actual bugs. There are a few places
where the kernel exports more than it should, but there is a lot more of that
without warnings, so that's fine.

The only places that believe to be bugs that needs fixing are in
<linux/kvm.h> and <asm-x86/ptrace-abi.h>. Avi has a patch for kvm.h
that in the kvm tree.

Below, you can find a patch for the remaining problem.

	Arnd <><
---

Subject: x86: export PTRACE_BTS interfaces to user space

The definitions for PTRACE_BTS_* are inside of #ifdef CONFIG_X86_PTRACE_BTS,
which means that they are invisible to user space. Remove the #ifdef so
that the interface becomes visible.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

--- a/arch/x86/include/asm/ptrace-abi.h
+++ b/arch/x86/include/asm/ptrace-abi.h
@@ -80,8 +80,6 @@
 
 #define PTRACE_SINGLEBLOCK	33	/* resume execution until next branch */
 
-#ifdef CONFIG_X86_PTRACE_BTS
-
 #ifndef __ASSEMBLY__
 #include <linux/types.h>
 
@@ -140,6 +138,5 @@ struct ptrace_bts_config {
    BTS records are read from oldest to newest.
    Returns number of BTS records drained.
 */
-#endif /* CONFIG_X86_PTRACE_BTS */
 
 #endif /* _ASM_X86_PTRACE_ABI_H */
