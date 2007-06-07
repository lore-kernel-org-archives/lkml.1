Return-Path: <linux-kernel-owner+w=401wt.eu-S932693AbXFGR5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693AbXFGR5Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 13:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758480AbXFGR5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 13:57:03 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:46450 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755147AbXFGR5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 13:57:02 -0400
Date: Thu, 7 Jun 2007 19:56:59 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
Message-Id: <20070607195659.c695c87d.dada1@cosmosbay.com>
In-Reply-To: <4668155B.4020705@redhat.com>
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7>
	<20070606235906.72439d16@the-village.bc.nu>
	<Pine.LNX.4.64.0706061558550.10383@alien.or.mcafeemobile.com>
	<20070607001932.35c9591c@the-village.bc.nu>
	<466741BD.20106@redhat.com>
	<20070607110432.73be7960@the-village.bc.nu>
	<4668155B.4020705@redhat.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Jun 2007 07:25:31 -0700
Ulrich Drepper <drepper@redhat.com> wrote:

> I don't say the current proposed code is the answer but iff
> Davide's unified code does not perform worse than the current code I
> don't see the harm since, for instance, extending socket() is in any
> case necessary.  I mentioned that close_on_exit must be set on open,
> else leaks are risked.  This will come naturally with a flags parameter
> which already takes O_NONSEQFD.

Yes, and for completeness :

accept2(int fd, ...)

pipe2(int *fds, int oflags);

eventfd2(int count, int oflags);

signalfd2(int ufd, sigset_t __user *user_mask, size_t sizemask, int oflags);

timerfd2(int ufd, int clockid, int flags,const struct itimerspec __user *utmr, int oflags) ...

We probably should name those with a better sufix than "2", it is ugly.

