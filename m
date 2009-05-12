Return-Path: <linux-kernel-owner+w=401wt.eu-S1755662AbZELPhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662AbZELPhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbZELPhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:37:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44138 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753266AbZELPhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:37:32 -0400
Date: Tue, 12 May 2009 17:37:32 +0200
From: Nick Piggin <npiggin@suse.de>
To: Jan Beulich <JBeulich@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: uses of cmpxchg/xadd in spinlock.h and rwsem.h vs. CONFIG_M386
Message-ID: <20090512153732.GA31131@wotan.suse.de>
References: <4A09AF8402000078000007DC@vpn.id2.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A09AF8402000078000007DC@vpn.id2.novell.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 04:19:00PM +0100, Jan Beulich wrote:
> While looking at a completely different issue I happened to grep for uses of
> xadd, and it would appear to me that there got uses added that would make
> a M386-configured SMP kernel die on an actual i386.
> 
> Oh, for the rwsem case I see - it would use the RWSEM_GENERIC_SPINLOCK case
> when selecting M386. But I see nothing similar for the ticket spinlocks - am
> I overlooking something?

Oh, hmm, we do actually attempt to support 386 SMP kernels... I thought
that config wasn't allowed, but looking at the atomic.h code, it has
ifdef fallbacks.

I guess some similar hacks could be added to spinlock.h code.
