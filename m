Return-Path: <linux-kernel-owner+w=401wt.eu-S1759904AbXFJPwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759904AbXFJPwZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 11:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbXFJPwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 11:52:17 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1102 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbXFJPwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 11:52:16 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 10 Jun 2007 08:52:09 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Paul Mackerras <paulus@samba.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Ulrich Drepper <drepper@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
In-Reply-To: <18027.39295.464374.371664@cargo.ozlabs.ibm.com>
Message-ID: <Pine.LNX.4.64.0706100831530.24724@alien.or.mcafeemobile.com>
References: <466741BD.20106@redhat.com> <20070607110432.73be7960@the-village.bc.nu>
 <B8B9EC80-2E36-433E-87EB-5B31FF42FBCF@mac.com> <20070607151243.22caab9e.dada1@cosmosbay.com>
 <Pine.LNX.4.64.0706071243090.6445@alien.or.mcafeemobile.com>
 <466864F8.2050903@cosmosbay.com> <46686810.6030805@redhat.com>
 <Pine.LNX.4.64.0706071438020.6445@alien.or.mcafeemobile.com>
 <466880A4.3090908@redhat.com> <Pine.LNX.4.64.0706071534280.6445@alien.or.mcafeemobile.com>
 <20070608120746.GD12687@thunk.org> <20070608140150.6f31672f@the-village.bc.nu>
 <Pine.LNX.4.64.0706081108130.5519@alien.or.mcafeemobile.com>
 <18026.15766.574693.200636@cargo.ozlabs.ibm.com>
 <Pine.LNX.4.64.0706090942210.14037@alien.or.mcafeemobile.com>
 <18027.39295.464374.371664@cargo.ozlabs.ibm.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jun 2007, Paul Mackerras wrote:

> What I am objecting to is this idea that many kernel developers seem
> to have, that if there is some aspect of the kernel/user API that
> becomes a bit inconvenient for the kernel to implement, then we can
> put the blame on the applications that rely on that aspect, call them
> names such as "legacy", "abuser", "conceptually buggy", "broken",
> etc., and ultimately justify breaking the ABI -- since it's only those
> applications that we have demonised that will be affected, after all.
> 
> In a way your response quoted above illustrates this perfectly.  If we
> give guarantees then people will start relying on them "in the wrong
> way" -- meaning, in any way that later becomes inconvenient to us.
> What next?  Shall we break the guarantee that when read() returns, the
> data is already in the user's buffer?  I'm sure we could improve
> performance if we didn't have to give that guarantee, and after all,
> only old, broken, legacy, conceptually buggy programs would be abusing
> the interface by relying on that. :)

This fds will be out of POSIX definition in any case. They have to be 
based at very high values in any case in order to be useful, and this 
already breaks the POSIX definition of them.



> > This should really be treated as an opaque handle, with no assumption on 
> > its value.
> 
> No.  This is an assertion that you have just conjured up to suit
> yourself, but it is wrong.  It does not reflect either historical UNIX
> practice or what is specified in POSIX.  Application writers are
> perfectly justified in relying on getting the lowest-numbered unused
> file descriptor.

You seem to deny the fact that libraries cannot reliably use fds allocated 
by POSIX rules for internal communication with the kernel. I really don't 
know what to say, if not that we must have a different definition of the 
word "reliable".
Maybe if you go back in the thread and give your solutions, using POSIX 
fds allocation semantics, to the problems that have been exposed, that 
might help understanding.



- Davide


