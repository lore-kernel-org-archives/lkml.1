Return-Path: <linux-kernel-owner+w=401wt.eu-S1755655AbZHYVxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655AbZHYVxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 17:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753860AbZHYVxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 17:53:54 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:59569 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487AbZHYVxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 17:53:53 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 25 Aug 2009 14:53:54 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Eric Blake <ebb9@byu.net>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bug-coreutils@gnu.org, bug-gnulib@gnu.org,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] open: introduce O_NOSTD
In-Reply-To: <1251202593-3676-1-git-send-email-ebb9@byu.net>
Message-ID: <alpine.DEB.2.00.0908251420190.18518@makko.or.mcafeemobile.com>
References: <4A9285FC.8000606@byu.net> <1251202593-3676-1-git-send-email-ebb9@byu.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Aug 2009, Eric Blake wrote:

> Another solution is for the application to sanitize all newly-created
> fds: GNU coreutils provides a wrapper open_safer, which does nothing
> extra in the common case that open() returned 3 or larger, but calls
> fcntl(n,F_DUPFD,3)/close(n) before returning if n was less than 3.
> However, this leads to triple the syscall cost for every open() call
> if the process starts life with a std fd closed; and if O_CLOEXEC is
> not used, still leaves a window of time where the fd can be leaked
> through another thread's use of fork/exec.

I think we can say that the vast majority of the software is not going to 
notice the proposed open_safer(), performance-wise, since the first three 
fds are always filled. So IMO the performance impact argument is a weak one.
If CLOEXEC semantics are needed in the open operation, F_DUPFD_CLOEXEC can 
be used to match it.
While the patch is simple, IMO this is something that can be easily taken 
care in glibc layers w/out huge drawbacks.


- Davide


