Return-Path: <linux-kernel-owner+w=401wt.eu-S1759633AbZABV5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759633AbZABV5G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 16:57:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758226AbZABV4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 16:56:52 -0500
Received: from vms173005pub.verizon.net ([206.46.173.5]:37376 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758114AbZABV4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 16:56:52 -0500
Date: Fri, 02 Jan 2009 16:56:32 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 03/15] ACPICA: move common private headers under
 kernel/acpi/acpica/
In-reply-to: <20090102191451.GB14249@elte.hu>
X-X-Sender: lenb@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Message-id: <alpine.LFD.2.00.0901021648440.3590@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <526647e1bb69fd3248558fce365bb1fbfb226ccd.1230719795.git.len.brown@intel.com>
 <c6b6f68232ab6da57e764c64b23b4649c4e7c463.1230719801.git.len.brown@intel.com>
 <20090102191451.GB14249@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-- Len Brown, Intel Open Source Technology Center
> Random example - i dont think stuff like this is readable [in to-be 
> kernel/acpi/utilities/utcache.c]:
> 
>         if (cache->current_depth >= cache->max_depth) {
>                 ACPI_FREE(object);
>                 ACPI_MEM_TRACKING(cache->total_freed++);
>         }
> 
>         /* Otherwise put this object back into the cache */
> 
>         else {
>                 status = acpi_ut_acquire_mutex(ACPI_MTX_CACHES);
>                 if (ACPI_FAILURE(status)) {
>                         return (status);
>                 }

Oops, I notice that I skipped over this comment.

It is a good example of needed cleanup.
(I proposed moving this to kernel/acpi/acpica/, not 
kernel/acpi/utilities/)
But the Linux kernel doesn't compile the contents of utcache.c
and indeed, I should delete that entire file from the tree.

Linux compiles this in osl.c instead:

acpi_status acpi_os_release_object(acpi_cache_t * cache, void *object)
{               
        kmem_cache_free(cache, object);
        return (AE_OK);
}

thanks for pointing this out, I'll deal with it right now.

-Len

