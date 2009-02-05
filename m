Return-Path: <linux-kernel-owner+w=401wt.eu-S1759947AbZBETKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759947AbZBETKT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:10:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759622AbZBETJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:09:31 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34339 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760171AbZBETJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:09:29 -0500
Date: Thu, 5 Feb 2009 11:06:54 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Tony Luck <tony.luck@intel.com>
cc: Jaswinder Singh Rajput <jaswinder@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       hskinnemoen@atmel.com, cooloney@kernel.org, ralf@linux-mips.org,
       dhowells@redhat.com, matthew@wil.cx, chris@zankel.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull -tip] headers_check fixes for other architectures
In-Reply-To: <12c511ca0902050955x1acb3907jdbfc1d0e6392cb91@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0902051101040.3247@localhost.localdomain>
References: <1233385816.17794.16.camel@localhost.localdomain> <12c511ca0902050955x1acb3907jdbfc1d0e6392cb91@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 5 Feb 2009, Tony Luck wrote:
> 
> Either revert this part ... or wrap the #include like this in fpu.h:
> 
> #ifndef __ASSEMBLY__
> #include <linux/types.h>
> #endif

That loses the

	arch/ia64/include/asm/types.h:# define __IA64_UL(x)             (x)

thing from <asm/types.h>, and makes some of the constants unusable from 
asm. Maybe nobody cares.

But it looks like that core really needs to use <asm/types.h> right now.

		Linus
