Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbZGONRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbZGONRP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 09:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbZGONRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 09:17:15 -0400
Received: from smtp.nokia.com ([192.100.122.230]:46585 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbZGONRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 09:17:14 -0400
From: Siarhei Siamashka <siarhei.siamashka@nokia.com>
Organization: Nokia-D/Helsinki
To: ext Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH] ARM: copy_page.S: take into account the size of the cache line
Date: Wed, 15 Jul 2009 16:12:19 +0300
User-Agent: KMail/1.9.9
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1247156605-16245-1-git-send-email-kirill@shutemov.name> <20090710235123.GE30322@shareable.org>
In-Reply-To: <20090710235123.GE30322@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907151612.20240.siarhei.siamashka@nokia.com>
X-OriginalArrivalTime: 15 Jul 2009 13:16:51.0016 (UTC) FILETIME=[83CA9480:01CA054E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 11 July 2009 02:51:23 ext Jamie Lokier wrote:
> Kirill A. Shutemov wrote:
> > From: Kirill A. Shutemov <kirill@shutemov.name>
> >
> > Optimized version of copy_page() was written with assumption that cache
> > line size is 32 bytes. On Cortex-A8 cache line size is 64 bytes.
> >
> > This patch tries to generalize copy_page() to work with any cache line
> > size if cache line size is multiple of 16 and page size is multiple of
> > two cache line size.
> >
> > Unfortunately, kernel doesn't provide a macros with correct cache size.
> > L1_CACHE_SHIFT is 5 on any ARM. So we have to define macros for this
> > propose by ourself.
>
> Why don't you fix L1_CACHE_SHIFT for Cortex-A8?

That's the plan.

Right now Kirill is on a vacation, but I think he can continue investigating
this stuff when he is back and will come up with a clean solution.

Fixing L1_CACHE_SHIFT may open a whole can of worms (fixing some old
bugs, or breaking some things that might work only when incorrectly
assuming that cache line is always 32 bytes). For example, looks like this
thing in 'arch/arm/include/asm/dma-mapping.h' may be dangerous for
ARM cores, which have cache line size different from 32:

static inline int dma_get_cache_alignment(void)
{
     return 32;
}

-- 
Best regards,
Siarhei Siamashka
