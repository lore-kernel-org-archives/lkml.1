Return-Path: <linux-kernel-owner+w=401wt.eu-S1758520AbZIRThe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758520AbZIRThe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 15:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758069AbZIRTh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 15:37:28 -0400
Received: from smtp-out.google.com ([216.239.45.13]:2668 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758047AbZIRTh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 15:37:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=oCcq3e9QmM/8p55feKbSaJzpe4f+WeY5r15F0KPvbGUtRHY2HWfLWwzehTNkBtbwr
	vlKyHF4eRsgw02+vGoPpg==
Date: Fri, 18 Sep 2009 12:37:23 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Arnd Bergmann <arnd@arndb.de>
cc: Andrew Morton <akpm@linux-foundation.org>, ebmunson@us.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-man@vger.kernel.org, mtk.manpages@gmail.com,
       randy.dunlap@oracle.com, rth@twiddle.net, ink@jurassic.park.msu.ru
Subject: Re: [PATCH] remove duplicate asm/mman.h files
In-Reply-To: <200909181848.42192.arnd@arndb.de>
Message-ID: <alpine.DEB.1.00.0909181236190.27556@chino.kir.corp.google.com>
References: <cover.1251197514.git.ebmunson@us.ibm.com> <20090917174616.f64123fb.akpm@linux-foundation.org> <200909181719.47240.arnd@arndb.de> <200909181848.42192.arnd@arndb.de>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Sep 2009, Arnd Bergmann wrote:

> diff --git a/arch/ia64/include/asm/mman.h b/arch/ia64/include/asm/mman.h
> index cf55884..4459028 100644
> --- a/arch/ia64/include/asm/mman.h
> +++ b/arch/ia64/include/asm/mman.h
> @@ -8,21 +8,9 @@
>   *	David Mosberger-Tang <davidm@hpl.hp.com>, Hewlett-Packard Co
>   */
>  
> -#include <asm-generic/mman-common.h>
> +#include <asm-generic/mman.h>
>  
> -#define MAP_GROWSDOWN	0x00100		/* stack-like segment */
> -#define MAP_GROWSUP	0x00200		/* register stack-like segment */
> -#define MAP_DENYWRITE	0x00800		/* ETXTBSY */
> -#define MAP_EXECUTABLE	0x01000		/* mark it as an executable */
> -#define MAP_LOCKED	0x02000		/* pages are locked */
> -#define MAP_NORESERVE	0x04000		/* don't check for reservations */
> -#define MAP_POPULATE	0x08000		/* populate (prefault) pagetables */
> -#define MAP_NONBLOCK	0x10000		/* do not block on IO */
> -#define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
> -#define MAP_HUGETLB	0x40000		/* create a huge page mapping */
> -
> -#define MCL_CURRENT	1		/* lock all current mappings */
> -#define MCL_FUTURE	2		/* lock all future mappings */
> +#define MAP_GROWSUP	0x0200		/* register stack-like segment */
>  
>  #ifdef __KERNEL__
>  #ifndef __ASSEMBLY__

ia64 doesn't use MAP_GROWSUP, so it's probably not necessary to carry it 
along with your cleanup.
