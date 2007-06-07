Return-Path: <linux-kernel-owner+w=401wt.eu-S935155AbXFGSju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935155AbXFGSju (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 14:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761619AbXFGSjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 14:39:42 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1065 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756794AbXFGSjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 14:39:41 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 7 Jun 2007 11:39:39 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@redhat.com>
cc: Eric Dumazet <dada1@cosmosbay.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
In-Reply-To: <46684DED.6000907@redhat.com>
Message-ID: <Pine.LNX.4.64.0706071132130.6445@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7>
 <20070606235906.72439d16@the-village.bc.nu>
 <Pine.LNX.4.64.0706061558550.10383@alien.or.mcafeemobile.com>
 <20070607001932.35c9591c@the-village.bc.nu> <466741BD.20106@redhat.com>
 <20070607110432.73be7960@the-village.bc.nu> <4668155B.4020705@redhat.com>
 <20070607195659.c695c87d.dada1@cosmosbay.com> <46684DED.6000907@redhat.com>
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
> Eric Dumazet wrote:
> > eventfd2(int count, int oflags);
> > 
> > signalfd2(int ufd, sigset_t __user *user_mask, size_t sizemask, int oflags);
> > 
> > timerfd2(int ufd, int clockid, int flags,const struct itimerspec __user *utmr, int oflags) ...
> 
> These aren't released yet, so, change them now before it's too late.

Linus, Andrew, would it be OK to change?



> And to add to your list:
> 
> epoll_create().  Important if you think that's the interface people
> should use.

Can't we leave it as is, and use sys_nonseqfd() for those? So basically:

pipe(2)			-> Use sys_nonseqfd
epoll_create(2)		-> Use sys_nonseqfd
accept(2)		-> Inherit the "origin" fd characteristics
open(2)			-> Add O_NONSEQFD
socket(2)		-> Introduce socket2()



- Davide


