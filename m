Return-Path: <linux-kernel-owner+w=401wt.eu-S1757576AbYLDKug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576AbYLDKug (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 05:50:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754723AbYLDKu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 05:50:27 -0500
Received: from ozlabs.org ([203.10.76.45]:47019 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754513AbYLDKu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 05:50:26 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18743.46549.833800.667962@cargo.ozlabs.ibm.com>
Date: Thu, 4 Dec 2008 21:49:57 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Joakim.Tjernlund@transmode.se
Subject: Re: [PATCH] Allow times and time system calls to return small
	negative values
In-Reply-To: <20081204075751.GA32594@elte.hu>
References: <18743.25968.602602.875295@drongo.ozlabs.ibm.com>
	<20081204075751.GA32594@elte.hu>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> > +	force_successful_syscall_return();
> >  	return compat_jiffies_to_clock_t(jiffies);
> 
> just curious: what code does force_successful_syscall_return() actually 
> run in the powerpc case - those bits are missing from this patch. I 
> suspect it sets some sort of flag?

It sets the TIF_NOERROR thread flag, which is tested in the syscall
exit path along with various other thread flags.

force_successful_syscall_return() is defined for powerpc in
arch/powerpc/include/asm/ptrace.h.  It's nothing new, it has existed
for ages and is used in a few other places already.  It has existing
non-null definitions on alpha, ia64, powerpc, and sparc64.

Paul.
