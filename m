Return-Path: <linux-kernel-owner+w=401wt.eu-S1753332AbZALMg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbZALMg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 07:36:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343AbZALMgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 07:36:21 -0500
Received: from styx.suse.cz ([82.119.242.94]:44008 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751316AbZALMgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 07:36:21 -0500
Date: Mon, 12 Jan 2009 13:36:19 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
cc: Jeremy Fitzhardinge <jeremy@xensource.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: remove byte locks
In-Reply-To: <20090112120743.GC24266@elte.hu>
Message-ID: <alpine.LNX.1.10.0901121334510.5377@jikos.suse.cz>
References: <alpine.LNX.1.10.0901121247430.5377@jikos.suse.cz> <20090112120743.GC24266@elte.hu>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jan 2009, Ingo Molnar wrote:

> > Remove byte locks implementation, which was introduced by Jeremy in 
> > 8efcbab6 ("paravirt: introduce a "lock-byte" spinlock implementation"), 
> > but turned out to be dead code that is not used by any in-kernel 
> > virtualization guest (Xen uses its own variant of spinlocks implementation 
> > and KVM is not planning to move to byte locks).
> > 
> > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> > ---
> >  arch/x86/include/asm/paravirt.h      |    2 -
> >  arch/x86/include/asm/spinlock.h      |   66 +--------------------------------
> >  arch/x86/kernel/paravirt-spinlocks.c |   10 -----
> >  3 files changed, 2 insertions(+), 76 deletions(-)
> didnt you send a patch in this lkml thread:
> 
>   Subject: Re: Is 386 processor still supported?

> that makes use of byte-locks on i386 ?

I did, but that patch was bogus, as we indeed don't support smp on M386.

This is totally independent -- it just removes dead code (byte locks) that 
has no in-tree user at all.

> But i guess we should solve M386 and M486 by only allowing it on !SMP, 
> hence spinlock support is moot there, right?

Agreed. But that's a different issue.

Thanks,

-- 
Jiri Kosina
SUSE Labs
