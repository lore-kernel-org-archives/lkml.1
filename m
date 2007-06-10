Return-Path: <linux-kernel-owner+w=401wt.eu-S1762085AbXFJGsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762085AbXFJGsp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 02:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759394AbXFJGsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 02:48:38 -0400
Received: from ozlabs.org ([203.10.76.45]:45641 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759108AbXFJGsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 02:48:37 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18027.39295.464374.371664@cargo.ozlabs.ibm.com>
Date: Sun, 10 Jun 2007 16:26:07 +1000
From: Paul Mackerras <paulus@samba.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Ulrich Drepper <drepper@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
In-Reply-To: <Pine.LNX.4.64.0706090942210.14037@alien.or.mcafeemobile.com>
References: <466741BD.20106@redhat.com>
	<20070607110432.73be7960@the-village.bc.nu>
	<B8B9EC80-2E36-433E-87EB-5B31FF42FBCF@mac.com>
	<20070607151243.22caab9e.dada1@cosmosbay.com>
	<Pine.LNX.4.64.0706071243090.6445@alien.or.mcafeemobile.com>
	<466864F8.2050903@cosmosbay.com>
	<46686810.6030805@redhat.com>
	<Pine.LNX.4.64.0706071438020.6445@alien.or.mcafeemobile.com>
	<466880A4.3090908@redhat.com>
	<Pine.LNX.4.64.0706071534280.6445@alien.or.mcafeemobile.com>
	<20070608120746.GD12687@thunk.org>
	<20070608140150.6f31672f@the-village.bc.nu>
	<Pine.LNX.4.64.0706081108130.5519@alien.or.mcafeemobile.com>
	<18026.15766.574693.200636@cargo.ozlabs.ibm.com>
	<Pine.LNX.4.64.0706090942210.14037@alien.or.mcafeemobile.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi writes:

> > Why must everything that makes things a bit simpler and more
> > predictable for application programmers be called a "mistake"?
> 
> Because if you give guarantees on something, ppl start using such 
> guarantee in the wrong way. Kyle's email summarizes it.

OK, my question/protest was a bit terse.

What I am objecting to is this idea that many kernel developers seem
to have, that if there is some aspect of the kernel/user API that
becomes a bit inconvenient for the kernel to implement, then we can
put the blame on the applications that rely on that aspect, call them
names such as "legacy", "abuser", "conceptually buggy", "broken",
etc., and ultimately justify breaking the ABI -- since it's only those
applications that we have demonised that will be affected, after all.

In a way your response quoted above illustrates this perfectly.  If we
give guarantees then people will start relying on them "in the wrong
way" -- meaning, in any way that later becomes inconvenient to us.
What next?  Shall we break the guarantee that when read() returns, the
data is already in the user's buffer?  I'm sure we could improve
performance if we didn't have to give that guarantee, and after all,
only old, broken, legacy, conceptually buggy programs would be abusing
the interface by relying on that. :)

> This should really be treated as an opaque handle, with no assumption on 
> its value.

No.  This is an assertion that you have just conjured up to suit
yourself, but it is wrong.  It does not reflect either historical UNIX
practice or what is specified in POSIX.  Application writers are
perfectly justified in relying on getting the lowest-numbered unused
file descriptor.

If you don't think we should be bound by POSIX, then you are perfectly
free to go off and write your own research kernel with whatever
interface you want, and no programs available to run on it. :)

Paul.
