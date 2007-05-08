Return-Path: <linux-kernel-owner+w=401wt.eu-S1755039AbXEHPYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039AbXEHPYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 11:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754939AbXEHPKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 11:10:23 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:58959 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966039AbXEHPGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 11:06:37 -0400
Date: Tue, 8 May 2007 09:06:32 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] lock bitops
Message-ID: <20070508150631.GC10562@parisc-linux.org>
References: <20070508113709.GA19294@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508113709.GA19294@wotan.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 01:37:09PM +0200, Nick Piggin wrote:
> --
> Introduce test_and_set_bit_lock / clear_bit_unlock bitops with lock semantics.
> Add non-trivial for powerpc and ia64. Convert page lock, buffer lock,
> bit_spin_lock, tasklet locks to use the new locks.

The names are a bit clumsy.  How about naming them after the effect,
rather than the implementation?  It struck me that really these things
are bit mutexes -- you can sleep while holding the lock.  How about
calling them bit_mutex_trylock() and bit_mutex_unlock()?

