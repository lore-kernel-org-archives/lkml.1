Return-Path: <linux-kernel-owner+w=401wt.eu-S1758086AbZELQC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086AbZELQC6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 12:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756190AbZELQCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 12:02:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43935 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbZELQCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 12:02:47 -0400
Subject: Re: uses of cmpxchg/xadd in spinlock.h and rwsem.h vs. CONFIG_M386
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, hpa@zytor.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090512153732.GA31131@wotan.suse.de>
References: <4A09AF8402000078000007DC@vpn.id2.novell.com>
	 <20090512153732.GA31131@wotan.suse.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 12 May 2009 18:02:37 +0200
Message-Id: <1242144157.11251.355.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-12 at 17:37 +0200, Nick Piggin wrote:
> On Tue, May 12, 2009 at 04:19:00PM +0100, Jan Beulich wrote:
> > While looking at a completely different issue I happened to grep for uses of
> > xadd, and it would appear to me that there got uses added that would make
> > a M386-configured SMP kernel die on an actual i386.
> > 
> > Oh, for the rwsem case I see - it would use the RWSEM_GENERIC_SPINLOCK case
> > when selecting M386. But I see nothing similar for the ticket spinlocks - am
> > I overlooking something?
> 
> Oh, hmm, we do actually attempt to support 386 SMP kernels... I thought
> that config wasn't allowed, but looking at the atomic.h code, it has
> ifdef fallbacks.
> 
> I guess some similar hacks could be added to spinlock.h code.

Last time this came up I thought we decided i386-smp wasn't supported,
and the Kconfig files ought to be adjusted.
