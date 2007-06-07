Return-Path: <linux-kernel-owner+w=401wt.eu-S1761513AbXFGOJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761513AbXFGOJJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 10:09:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757283AbXFGOI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 10:08:57 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:60879 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756845AbXFGOI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 10:08:57 -0400
Date: Thu, 7 Jun 2007 09:59:28 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>, Nicholas Miell <nmiell@comcast.net>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: signalfd API issues (was Re: [PATCH/RFC] signal races/bugs, losing TIF_SIGPENDING and other woes)
Message-ID: <20070607135928.GD5613@c2.user-mode-linux.org>
References: <1181087462.2788.8.camel@entropy> <Pine.LNX.4.64.0706051710140.23673@alien.or.mcafeemobile.com> <1181088936.2788.10.camel@entropy> <Pine.LNX.4.64.0706051736120.23673@alien.or.mcafeemobile.com> <1181091523.2788.28.camel@entropy> <1181098204.31677.158.camel@localhost.localdomain> <20070606125259.GA5491@c2.user-mode-linux.org> <18023.14494.889739.567439@cargo.ozlabs.ibm.com> <20070607022002.GA11977@c2.user-mode-linux.org> <1181186963.14818.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181186963.14818.15.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 01:29:23PM +1000, Benjamin Herrenschmidt wrote:
> But you use ptrace and don't steal signals with dequeue_signal() on a
> live other task, which is ok.

True.  However, with an SMP UML running a threaded app (which is also
threads on the host), if the thread on one CPU gets a signal which
will be nullified (SIGTRAP, SIG*ALRM, later SIGSEGV) and the other
thread continues running, does that count as stealing a signal from
another live task?

				Jeff

-- 
Work email - jdike at linux dot intel dot com
