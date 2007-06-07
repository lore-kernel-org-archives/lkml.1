Return-Path: <linux-kernel-owner+w=401wt.eu-S965092AbXFGS54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965092AbXFGS54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 14:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932687AbXFGS5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 14:57:46 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:52219 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932745AbXFGS5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 14:57:45 -0400
Message-ID: <46685508.2070805@cosmosbay.com>
Date: Thu, 07 Jun 2007 20:57:12 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Ulrich Drepper <drepper@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7> <20070606235906.72439d16@the-village.bc.nu> <Pine.LNX.4.64.0706061558550.10383@alien.or.mcafeemobile.com> <20070607001932.35c9591c@the-village.bc.nu> <466741BD.20106@redhat.com> <20070607110432.73be7960@the-village.bc.nu> <4668155B.4020705@redhat.com> <20070607195659.c695c87d.dada1@cosmosbay.com> <Pine.LNX.4.64.0706071059140.6445@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0706071059140.6445@alien.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Thu, 07 Jun 2007 20:57:18 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi a écrit :
> On Thu, 7 Jun 2007, Eric Dumazet wrote:
> 
>> accept2(int fd, ...)
> 
> I don't see any reason to not have it inherit the non-sequential 
> characteristics of "fd".
> 
> 
> 
>> pipe2(int *fds, int oflags);
> 
> I think pipe+sys_nonseqfd should be OK for those.

yes, but O_CLOEXEC/O_CLOFORK ?

I was refering to Uli wanting to close races on multi-threading apps doing a 
fork() while a thread is doing :

fd = open()
<----  race here  if another thread does a fork() ---->
fcntl( CLOEXEC)

> 
> 
> 
>> eventfd2(int count, int oflags);
>> signalfd2(int ufd, sigset_t __user *user_mask, size_t sizemask, int oflags);
>> timerfd2(int ufd, int clockid, int flags,const struct itimerspec __user *utmr, int oflags) ...
> 
> Those I think we're still in time to change the interface. No?
> Even if not, those are not perf-critical, so I think that 
> syscall+sys_nonseqfd is still fine.

Same point here, non a nonseqfd problem.


