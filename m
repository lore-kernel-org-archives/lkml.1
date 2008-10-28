Return-Path: <linux-kernel-owner+w=401wt.eu-S1752713AbYJ1DmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbYJ1DmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 23:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbYJ1Dlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 23:41:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37462 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751372AbYJ1Dlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 23:41:51 -0400
Date: Mon, 27 Oct 2008 20:41:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       linux-api@vger.kernel.org
Subject: Re: [PATCH] reintroduce accept4
Message-Id: <20081027204135.a139704e.akpm@linux-foundation.org>
In-Reply-To: <200810261641.m9QGfotr024285@hs20-bc2-1.build.redhat.com>
References: <200810261641.m9QGfotr024285@hs20-bc2-1.build.redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc linux-api)

(cc linux-arch)

On Sun, 26 Oct 2008 12:41:50 -0400 Ulrich Drepper <drepper@redhat.com> wrote:

> This patch reintroduces accept4, replacing paccept.  It's easy to see that
> the patch only removes code and then redirects existing code away from the
> removed functions.  Since the paccept code sans signal handling was never
> in question I think there is no reason to quarantine the patch first.

I'll confess to not having a clue what's going on here.

What is accept4() and why do I want one?  Sigh.  Hopefully others have
been following more closely and have some context.

> I've updated the test program which now looks as follows:

> 
> #include <fcntl.h>
> #include <pthread.h>
> #include <stdio.h>
> #include <unistd.h>
> #include <netinet/in.h>
> #include <sys/socket.h>
> #include <sys/syscall.h>
> 
> #ifdef __x86_64__
> #define __NR_accept4 288
> #define SOCK_CLOEXEC O_CLOEXEC
> #elif __i386__
> #define SYS_ACCEPT4     18
> #define USE_SOCKETCALL 1
> #define SOCK_CLOEXEC O_CLOEXEC
> #else

Well.  This doesn't actually agree with the kernel patch.

>
> ...
>
>  arch/x86/include/asm/unistd_64.h |    4 -
>  include/linux/net.h              |    6 --
>  include/linux/syscalls.h         |    3 -
>  kernel/sys_ni.c                  |    2 
>  net/compat.c                     |   50 ++----------------------
>  net/socket.c                     |   80 ++++-----------------------------------

I'd suggest that i386 is sufficiently common to warrant its inclusion
in the initial patch.

