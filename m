Return-Path: <linux-kernel-owner+w=401wt.eu-S1751276AbXDZP4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751276AbXDZP4L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 11:56:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753412AbXDZP4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 11:56:10 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51061 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751276AbXDZP4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 11:56:09 -0400
Date: Thu, 26 Apr 2007 08:53:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
cc: Johannes Berg <johannes@sipsolutions.net>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Con Kolivas <kernel@kolivas.org>,
       suspend2-devel@lists.suspend2.net, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
 hang in atomic copy)
In-Reply-To: <20070426110953.GQ17387@elf.ucw.cz>
Message-ID: <alpine.LFD.0.98.0704260850200.9964@woody.linux-foundation.org>
References: <200704182357.28107.mail@earthworm.de> <20070418220228.GA14536@elte.hu>
 <1176947576.5906.21.camel@nigel.suspend2.net> <20070419070437.GA25211@elte.hu>
 <20070424202336.GC16503@elf.ucw.cz> <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
 <20070424212408.GD16457@elf.ucw.cz> <1177582633.6814.29.camel@johannes.berg>
 <20070426103051.GP17387@elf.ucw.cz> <1177585458.6814.45.camel@johannes.berg>
 <20070426110953.GQ17387@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Apr 2007, Pavel Machek wrote:
> 
> #define SNAPSHOT_ATOMIC_SNAPSHOT	_IOW(SNAPSHOT_IOC_MAGIC, 3, void *)
> #define SNAPSHOT_SET_IMAGE_SIZE		_IOW(SNAPSHOT_IOC_MAGIC, 6, unsigned long)
> #define SNAPSHOT_AVAIL_SWAP		_IOR(SNAPSHOT_IOC_MAGIC, 7, void *)
> #define SNAPSHOT_GET_SWAP_PAGE		_IOR(SNAPSHOT_IOC_MAGIC, 8, void *)
> #define SNAPSHOT_SET_SWAP_FILE		_IOW(SNAPSHOT_IOC_MAGIC, 10, unsigned int)
> #define SNAPSHOT_PMOPS			_IOW(SNAPSHOT_IOC_MAGIC, 12, unsigned int)
> 
> Are these a problem? Do we need to just use u32 as a argument to keep
> ioctl numbers same between 32 and 64bit versions?

No, you need to use the *proper* type as an argument, and assuming that 
type has the same representation in both 32-bit and 64-bit world, the 
numbers will automatically match.

Using "void *" is totally bogus. It's supposed to be the actual argument 
you pass in, not the pointer to it. If your argument doesn't have a 
"struct xyz" kind of format, then you could use "int" (or u32 or 
something: but realistically int is 32-bit for the forseeable future), but 
it's always wrong to pass in "void *" or "unsigned long", since either of 
those are just a sign of the interface being either (a) misunderstood or 
(b) broken.

		Linus
