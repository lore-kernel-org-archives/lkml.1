Return-Path: <linux-kernel-owner+w=401wt.eu-S1754696AbZB1RZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbZB1RZF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 12:25:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbZB1RYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 12:24:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59524 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752665AbZB1RYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 12:24:53 -0500
Date: Sat, 28 Feb 2009 09:23:36 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Roland McGrath <roland@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       linux-mips@linux-mips.org, sparclinux@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 2/2] x86-64: seccomp: fix 32/64 syscall hole
In-Reply-To: <20090228072554.CFEA6FC3DA@magilla.sf.frob.com>
Message-ID: <alpine.LFD.2.00.0902280916470.3111@localhost.localdomain>
References: <20090228030226.C0D34FC3DA@magilla.sf.frob.com> <20090228030413.5B915FC3DA@magilla.sf.frob.com> <alpine.LFD.2.00.0902271932520.3111@localhost.localdomain> <alpine.LFD.2.00.0902271948570.3111@localhost.localdomain>
 <20090228072554.CFEA6FC3DA@magilla.sf.frob.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 27 Feb 2009, Roland McGrath wrote:
> 
> I don't know any other arch well enough to be sure that TIF_32BIT isn't the
> wrong test there too.  I'd like to leave that worry to the arch maintainers.

Agreed - it may be that others will want to not use TIF_32BIT too. It 
really does make much more sense to have it as a thread-local status flag 
than as an atomic (and thus expensive to modify) thread-flag, not just on 
x86.

But I think other architectures will find it easier to see what's going on 
if the code is straightforward and they can just fix their 
'is_compat_task()' function. And:

> But here is the patch you asked for.

Yes, this looks much more straightforward. 

And I guess the seccomp interaction means that this is potentially a 
2.6.29 thing. Not that I know whether anybody actually _uses_ seccomp. It 
does seem to be enabled in at least Fedora kernels, but it might not be 
used anywhere.

		Linus
