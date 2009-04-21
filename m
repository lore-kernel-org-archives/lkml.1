Return-Path: <linux-kernel-owner+w=401wt.eu-S1754511AbZDUIXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbZDUIXf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 04:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbZDUIXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 04:23:18 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:34652 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbZDUIXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 04:23:17 -0400
Date: Tue, 21 Apr 2009 10:25:23 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Simek <michal.simek@petalogix.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-arch@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Microblaze noMMU/MMU merge
Message-ID: <20090421082523.GA19864@uranus.ravnborg.org>
References: <49ED79AB.10004@petalogix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49ED79AB.10004@petalogix.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 09:45:47AM +0200, Michal Simek wrote:
> Hi All,
> 
> I would like to say your opinion about putting together Microblaze MMU
> arch to noMMU version.
> 
> In C code will be #ifdef CONFIG_MMU ... #endif  or #ifndef.
> 
> Here is proposal for headers. The similar style is used in m68k but I
> would like to have the same code
> for both archs in main file.
> 
> #ifndef _ASM_MICROBLAZE_PAGE_H
> #define _ASM_MICROBLAZE_PAGE_H
> 
> code for noMMU and MMU which is the same for both.
> 
> #ifdef __uClinux__
> #include "page_no.h" -> noMMU specific
> #else
> #include "page_mm.h"-> MMU specific
> #endif
> #endif /* _ASM_MICROBLAZE_PAGE_H */

Use dedicated header files for nommu / mmu only when it is really necessary.

In headers that are _NOT_ exported you can use CONFIG_MMU to test
if you are building for MMU or not - which is more readable.
 
The reason why you cannot use CONFIG_MMU in exported headers
are that CONFIG_MMU is not valid in the userspace headers (not set/unset).

In the optimal case you have no conditionals in the exported haders
and then just use CONFIG_MMU all over.

	Sam

