Return-Path: <linux-kernel-owner+w=401wt.eu-S1765376AbYEHTpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765376AbYEHTpS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 15:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754292AbYEHTo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 15:44:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46257 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbYEHToz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 15:44:55 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Anoop <acv@linux.vnet.ibm.com>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org,
       mtk.manpages@googlemail.com
Subject: Re: ptrace PTRACE_PEEKUSER behavior
In-Reply-To: Anoop's message of  Thursday, 8 May 2008 02:51:01 -0400 <20080508025101.a9177nongg4kgg4g@imap.linux.ibm.com>
References: <20080508025101.a9177nongg4kgg4g@imap.linux.ibm.com>
X-Windows: let it get in *your* way.
Message-Id: <20080508194431.750CB26FA85@magilla.localdomain>
Date: Thu,  8 May 2008 12:44:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Quoting Roland McGrath <roland@redhat.com>:
> 
> > 'struct user' is really a virtual structure layout, and never exists
> > anywhere as an actual struct.  It's really just defining the argument
> > values that can be used in PEEKUSR/POKEUSR calls.
> 
> But the powerpc ptrace code returns the FPRs & FPSCR though they are  
> not part of user struct.

I guess I was too strong in describing 'struct user' as useful even in that
sense.  Each arch defines the offset values for its PEEKUSR/POKEUSR, and on
powerpc the asm/ptrace.h PT_* macros are the only true definition of that ABI.

'struct user' is used in a.out core dumps, if those can even still be
generated on powerpc.  Other than that, the struct is actually meaningless
cruft on powerpc.  On other machines it's almost that, except that e.g. on
x86 there is no other definition than offsetof(struct user, u_debugreg[0])
to supply that offset for PTRACE_POKEUSR.

> Does this mandate inclusion of floating point set in powerpc user struct?

I think what it mandates is dropping any idea that 'struct user' is
necessarily meaningful in any generic sense.  The only use it has is
arch-specific cases where offsetof(struct user, something) is part of the
ptrace ABI.


Thanks,
Roland
