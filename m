Return-Path: <linux-kernel-owner+w=401wt.eu-S937824AbXFGWk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937824AbXFGWk1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 18:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765977AbXFGWkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 18:40:18 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4369 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764608AbXFGWkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 18:40:16 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 7 Jun 2007 15:40:14 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@redhat.com>
cc: Eric Dumazet <dada1@cosmosbay.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
In-Reply-To: <466880A4.3090908@redhat.com>
Message-ID: <Pine.LNX.4.64.0706071534280.6445@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7>
 <20070606235906.72439d16@the-village.bc.nu>
 <Pine.LNX.4.64.0706061558550.10383@alien.or.mcafeemobile.com>
 <20070607001932.35c9591c@the-village.bc.nu> <466741BD.20106@redhat.com>
 <20070607110432.73be7960@the-village.bc.nu> <B8B9EC80-2E36-433E-87EB-5B31FF42FBCF@mac.com>
 <20070607151243.22caab9e.dada1@cosmosbay.com>
 <Pine.LNX.4.64.0706071243090.6445@alien.or.mcafeemobile.com>
 <466864F8.2050903@cosmosbay.com> <46686810.6030805@redhat.com>
 <Pine.LNX.4.64.0706071438020.6445@alien.or.mcafeemobile.com>
 <466880A4.3090908@redhat.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007, Ulrich Drepper wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Davide Libenzi wrote:
> > What we can sanily do, is re-random the base if no fds are in there (of 
> > course CLOFORK and CLOEXEC do not count).
> 
> With the last comment you mean "count after CLOFORK and CLOEXEC", right?
>  So the re-basing would be done in two places: after fork and after execve?

Yes. Files with the CLOFORK and CLOEXEC flag do not count for fork and 
exec copies.
I was also planning on doing it in __put_unused_fd(), every time 
fmap->count goes to zero. But get_random_int() is not as cheap as I 
thought. If we use a cheaper (although less secure) function to mix pid & 
jiffies, we could do it even in there.



- Davide


