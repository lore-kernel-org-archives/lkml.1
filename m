Return-Path: <linux-kernel-owner+w=401wt.eu-S1755297AbZIUJOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbZIUJOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 05:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753988AbZIUJOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 05:14:06 -0400
Received: from smtp-out.google.com ([216.239.33.17]:47604 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbZIUJOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 05:14:05 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=spVsv4sBZmB/82+knDdX+WJlZeLLwUfvRwbTX1lYXnCZfjoqqAZiahn5RC2OjdOQQ
	10Fn9Ue1rr7EMb58Q81Og==
Date: Mon, 21 Sep 2009 02:13:59 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>,
       Fenghua Yu <fenghua.yu@intel.com>, Tony Luck <tony.luck@intel.com>
cc: ebmunson@us.ibm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-man@vger.kernel.org, mtk.manpages@gmail.com,
       randy.dunlap@oracle.com, rth@twiddle.net, ink@jurassic.park.msu.ru,
       linux-ia64@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] remove duplicate asm/mman.h files
In-Reply-To: <200909211031.25369.arnd@arndb.de>
Message-ID: <alpine.DEB.1.00.0909210208180.16086@chino.kir.corp.google.com>
References: <cover.1251197514.git.ebmunson@us.ibm.com> <200909181848.42192.arnd@arndb.de> <alpine.DEB.1.00.0909181236190.27556@chino.kir.corp.google.com> <200909211031.25369.arnd@arndb.de>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Sep 2009, Arnd Bergmann wrote:

> > > -#define MCL_CURRENT	1		/* lock all current mappings */
> > > -#define MCL_FUTURE	2		/* lock all future mappings */
> > > +#define MAP_GROWSUP	0x0200		/* register stack-like segment */
> > >  
> > >  #ifdef __KERNEL__
> > >  #ifndef __ASSEMBLY__
> > 
> > ia64 doesn't use MAP_GROWSUP, so it's probably not necessary to carry it 
> > along with your cleanup.
> 
> ia64 is the only architecture defining it, nobody uses it in the kernel.
> If the ia64 maintainers want to remove it in a separate patch, that
> would probably be a good idea.
> 

I'll do it then.

> I tried not to change the ABI in any way in my patch, and there is
> a theoretical possibility that some user space program on ia64 currently
> depends on that definition.
> 

I don't buy that as justification, if some userspace program uses it based 
on the false belief that it actually does what it says, it's probably 
better to break their build than perpetuating the lie that it's different 
than ~MAP_GROWSDOWN.


ia64: remove definition for MAP_GROWSUP

MAP_GROWSUP is unused.

Signed-off-by: David Rientjes <rientjes@google.com>
---
diff --git a/arch/ia64/include/asm/mman.h b/arch/ia64/include/asm/mman.h
--- a/arch/ia64/include/asm/mman.h
+++ b/arch/ia64/include/asm/mman.h
@@ -11,7 +11,6 @@
 #include <asm-generic/mman-common.h>
 
 #define MAP_GROWSDOWN	0x00100		/* stack-like segment */
-#define MAP_GROWSUP	0x00200		/* register stack-like segment */
 #define MAP_DENYWRITE	0x00800		/* ETXTBSY */
 #define MAP_EXECUTABLE	0x01000		/* mark it as an executable */
 #define MAP_LOCKED	0x02000		/* pages are locked */
