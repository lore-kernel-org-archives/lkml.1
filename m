Return-Path: <linux-kernel-owner+w=401wt.eu-S1752647AbXFDFMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbXFDFMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 01:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbXFDFL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 01:11:59 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:51511 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750792AbXFDFL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 01:11:58 -0400
Date: Sun, 3 Jun 2007 22:11:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
cc: Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 2/2] ufd v1 - use unsequential O(1) fdmap
In-Reply-To: <Pine.LNX.4.64.0706031311490.13247@alien.or.mcafeemobile.com>
Message-ID: <alpine.LFD.0.98.0706032210040.23741@woody.linux-foundation.org>
References: <send-serie.davidel@xmailserver.org.24319.1180825146.2>
 <4663067C.9050002@redhat.com> <Pine.LNX.4.64.0706031127220.13247@alien.or.mcafeemobile.com>
 <466319DB.80800@redhat.com>
 <Pine.LNX.4.64.0706031311490.13247@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 3 Jun 2007, Davide Libenzi wrote:
> 
> Agreed, a new syscall looks less messy. I'll make sys_dup2() to allow 
> installing in the non-sequential area, only if there's an fd already 
> allocated. F_DUPFD will remain unchanged (that is, not allow 
> non-sequential fds allocations).

I actually think that a new system call is _hugely_ messy. It means that 
anybody who wants to use a new feature needs to have a new glibc. Not 
nice, not nice at all. I'd much rather see a totally transparent extension 
that doesn't require any new user space what-so-ever to be used...

		Linus
