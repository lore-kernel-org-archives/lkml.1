Return-Path: <linux-kernel-owner+w=401wt.eu-S1756708AbYABWwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbYABWwD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 17:52:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754118AbYABWvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 17:51:53 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57551 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753606AbYABWvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 17:51:52 -0500
Date: Wed, 2 Jan 2008 22:49:20 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, trem <tremyfr@yahoo.fr>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc6-mm1
Message-ID: <20080102224920.33993288@lxorguk.ukuu.org.uk>
In-Reply-To: <20080102161846.GA2755@elte.hu>
References: <9DtBq-2jD-3@gated-at.bofh.it>
	<200801022131.15482.nickpiggin@yahoo.com.au>
	<1199271676.6821.112.camel@twins>
	<200801022212.29303.nickpiggin@yahoo.com.au>
	<1199273047.6821.119.camel@twins>
	<20080102121909.GA6285@elte.hu>
	<20080102132621.4da29e29@the-village.bc.nu>
	<20080102161846.GA2755@elte.hu>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> could we perhaps just replace it with a tty_mutex? (possibly a recursive 
> one) I suspect by now most of the BKL dependencies there have become 
> local to the tty code? Or are there deep VFS dependencies as well? (if 
> yes, what type of dependencies?)

The big problem is that nobody actually knows where all the dependancies
are. That is why I've started with the bits we can decipher so that it
simplifies the mess each time we clean up the locking of some lower level
aspect.

Almost all the serial drivers clone the same open and release methods (or
worse older versions of it) so that also needs doing. Lots to do, so
little time.
