Return-Path: <linux-kernel-owner+w=401wt.eu-S1760105AbYCESVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760105AbYCESVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 13:21:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756798AbYCESVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 13:21:08 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54690 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755792AbYCESVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 13:21:07 -0500
Date: Wed, 5 Mar 2008 19:22:31 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Valdis.Kletnieks@vt.edu,
       linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: Re: 2.6.25-rc3-mm1 - PROFILE_LIKELY redux..
Message-ID: <20080305182231.GC12629@one.firstfloor.org>
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org> <4911.1204701694@turing-police.cc.vt.edu> <p738x0x5al2.fsf@bingen.suse.de> <20080305100221.1d7316e6.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080305100221.1d7316e6.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, but both those files now have:
> 
> /*
>  * likely and unlikely explode when used in vdso in combination with
>  * profile-likely-unlikely-macros.patch
>  */
> #undef likely
> #define likely(x) (x)
> #undef unlikely
> #define unlikely(x) (x)

> 
> at the top, so it'll be something else.  Perhaps a `likely' snuck in via an

I see. 

> inline in a header file.  It would be better to add a #define DONT_DO_THAT

I think you need to do it differently. Not undef/define, but set
some symbol that is checked by the unlikely profiler and it won't
enable itself with that symbol set.  Then header files would be covered too.


> at the top of arch/x86/kernel/vsyscall_64.c and
> arch/x86/vdso/vclock_gettime.c, then use that to defeat likely-profiling.

Possible.  The problem is that there are now vsyscall functions in
other files too, especially hpet_64.c and tsc_64.c

Perhaps this is something that should be just checked in modpost instead. 
Any external references from the vsyscall section to another section
should be flag'ed as error (cc'ed Sam in case he wants to look at that) 

-Andi
