Return-Path: <linux-kernel-owner+w=401wt.eu-S936214AbXFFWwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936214AbXFFWwm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764464AbXFFWwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:52:34 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1229 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763548AbXFFWwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:52:33 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 6 Jun 2007 15:52:31 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: David Miller <davem@davemloft.net>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       dada1@cosmosbay.com
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
In-Reply-To: <20070606.154434.21926922.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0706061549110.10383@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7>
 <20070606.154434.21926922.davem@davemloft.net>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2007, David Miller wrote:

> From: Davide Libenzi <davidel@xmailserver.org>
> Date: Wed, 06 Jun 2007 15:30:31 -0700
> 
> > This patch implement a new syscall sys_socket2(), that accepts an
> > extra "flags" parameter:
> > 
> > int socket2(int domain, int type, int protocol, int flags);
> > 
> > The flags parameter is used to pass extra flags to the kernel, and is
> > at the moment used to select the file descriptor allocations inside
> > the non-sequential area (O_NONSEQFD). The remaining parameters are
> > exactly the same as the ones of sys_socket().
> > The sys_accept() system call has been modified to return a file
> > descriptor inside the non-sequential area, if the listening fd is.
> > The sys_socketcall() system call has been also changed to support
> > a new SYS_SOCKET2 indentifier.
> > 
> > Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
> 
> Since the valid range of "domain" values is quite small,
> we could avoid the new system call by cribbing some of the
> upper bits of the 'domain' argument.
> 
> Valid existing programs pass in valid 'domain' values and
> thus will not set any of the new flags.
> 
> Just an idea.

I have no huge preferences. If not the slight one of using the same flags 
for open() and socket{2}() (O_NONSEQFD). If we overload socket() we may 
need to fight with existing O_* flags. OTOH the current free ones are 
pretty high in bits, so it may be OK too.



- Davide


