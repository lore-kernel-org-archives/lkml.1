Return-Path: <linux-kernel-owner+w=401wt.eu-S1758689AbXFJCk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689AbXFJCk7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 22:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754042AbXFJCkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 22:40:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39921 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbXFJCkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 22:40:51 -0400
Date: Sun, 10 Jun 2007 03:40:44 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Ulrich Drepper <drepper@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
Message-ID: <20070610024044.GB21478@ftp.linux.org.uk>
References: <20070609003622.GB4095@ftp.linux.org.uk> <466A0020.50406@redhat.com> <20070609014140.GC4095@ftp.linux.org.uk> <466A0BFB.3070908@redhat.com> <20070609151521.GD4095@ftp.linux.org.uk> <466AD4BA.80407@redhat.com> <20070609165454.GE4095@ftp.linux.org.uk> <466ADEAB.7080202@redhat.com> <20070609172429.GF4095@ftp.linux.org.uk> <2E51520E-EC73-457F-809A-4749ED9A3C97@mac.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2E51520E-EC73-457F-809A-4749ED9A3C97@mac.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 09, 2007 at 03:27:43PM -0400, Kyle Moffett wrote:
> SCENARIO 1:
> 
> Program Thread:   Library Thread:
>                   fd = socket(AF_*, SOCK_*, 0);
> fork();
>                   int x = FD_CLOEXEC;
>                   fcntl(fd, F_SETFD, &x);

BTW, regardless of anything else, in such situation this "library
thread" would be better off by just having independent descriptors.
We _can_ do that just fine.

That is, if library code using such stuff would be OK with being a thread.
Any specific examples one way or another?
