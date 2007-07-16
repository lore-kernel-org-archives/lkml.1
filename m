Return-Path: <linux-kernel-owner+w=401wt.eu-S1761580AbXGPJpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761580AbXGPJpT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 05:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756014AbXGPJpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 05:45:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57784 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755046AbXGPJpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 05:45:05 -0400
Date: Mon, 16 Jul 2007 11:45:03 +0200
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc][patch 2/2] x86_64: FIFO ticket spinlocks
Message-ID: <20070716094503.GC21464@wotan.suse.de>
References: <20070716045932.GA19914@wotan.suse.de> <20070716050134.GB19914@wotan.suse.de> <20070716092646.GA18423@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716092646.GA18423@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2007 at 11:26:46AM +0200, Ingo Molnar wrote:
> 
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > [...] trylock is more significantly slower, but they are relatively 
> > rare.
> 
> trylock is the main thing that the spinlock debugging code uses, and 
> SPINLOCK_DEBUG is frequently enabled by distro kernels. OTOH, the cost 
> looks like to be +5 instructions, right? Still ...

Which trylocks do you mean? The lockbreak spinlocks use trylock, but
those are not used with the ticket version.

I wouldn't be against adding an option between either of the lock
types, if there was value in it. But I would like to default ticket
locks to "y", at least in -rc kernels, in order to see if performance
goes down anywhere.
