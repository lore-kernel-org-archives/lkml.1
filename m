Return-Path: <linux-kernel-owner+w=401wt.eu-S968495AbXEHWkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968495AbXEHWkm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 18:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968480AbXEHWkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 18:40:39 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:33335 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968428AbXEHWki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 18:40:38 -0400
Date: Tue, 8 May 2007 16:40:36 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] lock bitops
Message-ID: <20070508224036.GE10562@parisc-linux.org>
References: <20070508113709.GA19294@wotan.suse.de> <20070508150631.GC10562@parisc-linux.org> <20070508222926.GA20174@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508222926.GA20174@wotan.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 12:29:27AM +0200, Nick Piggin wrote:
> On Tue, May 08, 2007 at 09:06:32AM -0600, Matthew Wilcox wrote:
> > On Tue, May 08, 2007 at 01:37:09PM +0200, Nick Piggin wrote:
> > > --
> > > Introduce test_and_set_bit_lock / clear_bit_unlock bitops with lock semantics.
> > > Add non-trivial for powerpc and ia64. Convert page lock, buffer lock,
> > > bit_spin_lock, tasklet locks to use the new locks.
> > 
> > The names are a bit clumsy.  How about naming them after the effect,
> > rather than the implementation?  It struck me that really these things
> > are bit mutexes -- you can sleep while holding the lock.  How about
> > calling them bit_mutex_trylock() and bit_mutex_unlock()?
> 
> bit_spin_trylock / bit_spin_unlock be OK? ;)

We already have a bit_spin_trylock -- it keeps preempt disabled until
you bit_spin_unlock.  Oh, and it only actually sets a bit if you've got
SMP or lock debugging on.  Nice try though ;-)
