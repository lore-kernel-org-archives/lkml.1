Return-Path: <linux-kernel-owner+w=401wt.eu-S965937AbXFGC3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965937AbXFGC3I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 22:29:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935753AbXFGC2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 22:28:55 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:58638 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935757AbXFGC2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 22:28:55 -0400
Date: Wed, 6 Jun 2007 22:20:02 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Nicholas Miell <nmiell@comcast.net>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: signalfd API issues (was Re: [PATCH/RFC] signal races/bugs, losing TIF_SIGPENDING and other woes)
Message-ID: <20070607022002.GA11977@c2.user-mode-linux.org>
References: <1181023787.2785.14.camel@entropy> <1181028453.31677.127.camel@localhost.localdomain> <1181087462.2788.8.camel@entropy> <Pine.LNX.4.64.0706051710140.23673@alien.or.mcafeemobile.com> <1181088936.2788.10.camel@entropy> <Pine.LNX.4.64.0706051736120.23673@alien.or.mcafeemobile.com> <1181091523.2788.28.camel@entropy> <1181098204.31677.158.camel@localhost.localdomain> <20070606125259.GA5491@c2.user-mode-linux.org> <18023.14494.889739.567439@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18023.14494.889739.567439@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 08:43:42AM +1000, Paul Mackerras wrote:
> What Ben was talking about was stealing a synchronous SEGV from a task
> without stopping it, and as Ben says that makes no sense.
> Intercepting a signal and stopping the task is reasonable, and that is
> what ptrace does, and I assume also UML.

It is, but I can also see UML stealing the SEGV from the child.  The
UML skas does this - a ptrace extension, PTRACE_FAULTINFO, is used to
extract page fault information from the child, and other pieces of the
patch are used to fix the fault without the child continuing until
it's fixed.  So, in this case, the child never sees the SEGV.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
