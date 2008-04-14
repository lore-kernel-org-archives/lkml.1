Return-Path: <linux-kernel-owner+w=401wt.eu-S1758426AbYDNAih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758426AbYDNAih (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 20:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753444AbYDNAi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 20:38:29 -0400
Received: from ozlabs.org ([203.10.76.45]:50229 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320AbYDNAi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 20:38:28 -0400
Subject: Re: [PATCH 1/2] Add thread_info_cache_init() to all archs
From: Benjamin Herrenschmidt <benh@ozlabs.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org, takata@linux-m32r.org,
       linux-m32r@ml.linux-m32r.org, Linux-Arch <linux-arch@vger.kernel.org>
In-Reply-To: <20080413171953.bde5e9ac.akpm@linux-foundation.org>
References: <20080410032354.90CB1DDF0F@ozlabs.org>
	 <20080413171953.bde5e9ac.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 10:38:26 +1000
Message-Id: <1208133506.6958.82.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +#ifndef thread_info_cache_init
> > +#define thread_info_cache_init	do { } while(0)
> > +#endif
> 
> This trick does cause a bit of a problem: it is undefined which arch header
> file is to provide the alternative definition of thread_info_cache_init.

I this case it's well defined: thread_info.h. Maybe I should add a
comment ?

> So we can (and have) ended up in the situation where the override appears
> in different files on different architectures and various screwups ensue.

Yup.

> So I'd suggest that we have a bigfatcomment telling implementors which file
> the override should be implemented in.  And make sure that this arch file is
> directly included from within sched.h.

Will do.

> I have a suspicion that we can still get in a mess if .c files include the
> per-arch file and don't include sched.h, but I forget where this happened
> and why it broke stuff.

In this case, there's only one call site and will only every be one, so
that shouldn't be a problem. I don't see init/main.c not including
sched.h

> Sigh.  A nice, coded-in-C implementation within each and every architecture
> remains the best implementation, and all the little tricks-to-save-typing
> have failure modes.

Well, I started doing it in all arch, and people around here told me
that was not a good idea , that it would be trouble if the prototype
ever had to change (adding an arg, etc... though very unlikely to happen
in that case, granted).

> otoh, if only one .c file will ever call this function then I think that
> all problems are solved by
> 
> a) moving the above ifdeffery into the .c file
> b) adding a comment explaining which arch file must provide the override
> c) directly including that file from within the .c file.

I can definitely do that. I have no problem either way. I can add to all
archs too, it's just that whatever way I choose, some people won't be
happy with it :-)

Anyway, I'll move the ifdeferry to init/main.c then.

Cheers,
Ben.

