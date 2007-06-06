Return-Path: <linux-kernel-owner+w=401wt.eu-S965448AbXFFW4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965448AbXFFW4F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764852AbXFFWzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:55:53 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51533 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S934844AbXFFWzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:55:52 -0400
Date: Wed, 6 Jun 2007 23:59:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
Message-ID: <20070606235906.72439d16@the-village.bc.nu>
In-Reply-To: <send-serie.davidel@xmailserver.org.4625.1181169040.7>
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The sys_accept() system call has been modified to return a file
> descriptor inside the non-sequential area, if the listening fd is.
> The sys_socketcall() system call has been also changed to support
> a new SYS_SOCKET2 indentifier.

This still all seems really really ugly. Is there anything wrong with
throwing all these extra cases out and replacing the entire lot with

	prctl(PR_SPARSEFD, 1);

to turn on sparse fd allocation for a process ?

Anyone needing to deal with certain special fds will use dup2() anyway so
a task global switch seems to be cleaner and make the behaviour simply to
flip on, with no extra calls (and you need to submit man pages for them
all too), and also more importantly no new glibc stuff should be needed,
and a process can try to set sparsefd, fail and carry on so its more
portable and back portable.

Alan
