Return-Path: <linux-kernel-owner+w=401wt.eu-S933910AbXHXAKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933910AbXHXAKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 20:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764770AbXHXAKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 20:10:09 -0400
Received: from styx.suse.cz ([82.119.242.94]:58355 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764508AbXHXAKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 20:10:06 -0400
Date: Fri, 24 Aug 2007 02:09:59 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Zan Lynx <zlynx@acm.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Jakub Jelinek <jakub@redhat.com>, Kees Cook <kees@outflux.net>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: 2.6.23-rc3-mm1 - memory layout change?  - lost support for
 MAP_32BIT? - mono crashes
In-Reply-To: <20070823165201.717ed62d.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0708240157430.5402@jikos.suse.cz>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
 <1187834905.190825.16.camel@localhost> <Pine.LNX.4.64.0708231126380.2460@twin.jikos.cz>
 <20070823165201.717ed62d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(some more CCs added)

On Thu, 23 Aug 2007, Andrew Morton wrote:

> It is quite unobvious to me that the whole pie-randomization thing is 
> worth merging.  Why shouldn't we just drop the lot?

Hi Andrew,

well, whenever it comes to address space layout randomization, there 
usually follows a huge debate whether it is needed or not, some people 
think it's useful and powerful security protection against 0day attacks, 
other people think that it's just fighting the bugs in userspace software 
in a wrong way.

Opinions differ, that's why there is a way to turn the VA space 
randomization completely off trivially.

We already have randomized stack, randomized mmap base, randomized vdso 
page in mainline kernel, but code and heap still stay on deterministic 
addresses. I think providing the possibility for users to have really full 
address space randomization (if they want to) is much better than 
providing the current slightly crippled state, when some parts of address 
space are randomized and some are not. Or do you think we should rather 
rip all the randomization off?

And it's almost certain to me that users want this functionality - look 
major distros. They seem to have out-of-tree patches to provide this 
functionality to their users, IMHO.

Thanks,

-- 
Jiri Kosina
