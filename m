Return-Path: <linux-kernel-owner+w=401wt.eu-S934609AbXFGSDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934609AbXFGSDY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 14:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757842AbXFGSDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 14:03:17 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:3857 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756647AbXFGSDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 14:03:16 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 7 Jun 2007 11:03:13 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Ulrich Drepper <drepper@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
In-Reply-To: <20070607195659.c695c87d.dada1@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0706071059140.6445@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7>
 <20070606235906.72439d16@the-village.bc.nu>
 <Pine.LNX.4.64.0706061558550.10383@alien.or.mcafeemobile.com>
 <20070607001932.35c9591c@the-village.bc.nu> <466741BD.20106@redhat.com>
 <20070607110432.73be7960@the-village.bc.nu> <4668155B.4020705@redhat.com>
 <20070607195659.c695c87d.dada1@cosmosbay.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007, Eric Dumazet wrote:

> accept2(int fd, ...)

I don't see any reason to not have it inherit the non-sequential 
characteristics of "fd".



> pipe2(int *fds, int oflags);

I think pipe+sys_nonseqfd should be OK for those.



> eventfd2(int count, int oflags);
> signalfd2(int ufd, sigset_t __user *user_mask, size_t sizemask, int oflags);
> timerfd2(int ufd, int clockid, int flags,const struct itimerspec __user *utmr, int oflags) ...

Those I think we're still in time to change the interface. No?
Even if not, those are not perf-critical, so I think that 
syscall+sys_nonseqfd is still fine.



- Davide


