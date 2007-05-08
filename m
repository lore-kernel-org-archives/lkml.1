Return-Path: <linux-kernel-owner+w=401wt.eu-S934553AbXEHMXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934553AbXEHMXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 08:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934515AbXEHMXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 08:23:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934475AbXEHMXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 08:23:18 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070508113709.GA19294@wotan.suse.de> 
References: <20070508113709.GA19294@wotan.suse.de> 
To: Nick Piggin <npiggin@suse.de>
Cc: linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] lock bitops 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Tue, 08 May 2007 13:22:56 +0100
Message-ID: <10196.1178626976@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@suse.de> wrote:

> This patch (along with the subsequent one to optimise unlock_page) reduces
> the overhead of lock_page/unlock_page (measured with page faults and a patch
> to lock the page in the fault handler) by about 425 cycles on my 2-way G5.

Seems reasonable, though test_and_set_lock_bit() might be a better name.

> +There are two special bitops with lock barrier semantics (acquire/release,
> +same as spinlocks).

You should update Documentation/memory-barriers.txt also.

>  #define TestSetPageLocked(page)		\
>  		test_and_set_bit(PG_locked, &(page)->flags)
> +#define TestSetPageLocked_Lock(page)		\
> +		test_and_set_bit_lock(PG_locked, &(page)->flags)

Can we get away with just moving TestSetPageLocked() to the new function
rather than adding another accessor?  Or how about LockPageLocked() and
UnlockPageLocked() rather than SetPageLocked_Lock() that last looks wrong
somehow.

The FRV changes look reasonable, btw.

David

