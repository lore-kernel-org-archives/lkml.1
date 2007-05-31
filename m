Return-Path: <linux-kernel-owner+w=401wt.eu-S1762016AbXEaTDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762016AbXEaTDY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 15:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761949AbXEaTDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 15:03:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758571AbXEaTDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 15:03:14 -0400
Date: Thu, 31 May 2007 15:02:35 -0400
From: Jakub Jelinek <jakub@redhat.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Introduce O_CLOEXEC (take >2)
Message-ID: <20070531190235.GY4033@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <200705311809.l4VI9F9X009556@devserv.devel.redhat.com> <Pine.LNX.4.64.0705311123370.30485@alien.or.mcafeemobile.com> <465F170B.3070603@redhat.com> <Pine.LNX.4.64.0705311144290.30485@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705311144290.30485@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2007 at 11:46:31AM -0700, Davide Libenzi wrote:
> On Thu, 31 May 2007, Ulrich Drepper wrote:
> > Davide Libenzi wrote:
> > > Isn't this better be a global process flag? Default should be, for legacy
> > > reasons,
> > 
> > No.  Policies are always wrong since it means code that cannot change
> > the policy (e.g, all runtime libraries) have no access to the
> > functionality.  I cannot set the policy to default to close-on-exit in
> > glibc all the while the application assumes this is not the case.
> 
> I was talking for a broader usage, not only glibc centric. Most ppl 
> writing MT+exec apps wants all but (eventually) and handfull of files 
> leaking across the exec boundary.

If open (and all other syscalls that create fds) have O_CLOEXEC (and
something similar for other syscalls), then such a policy can be easily
implemented on the userland, if desired.

	Jakub
