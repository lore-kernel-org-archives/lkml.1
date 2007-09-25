Return-Path: <linux-kernel-owner+w=401wt.eu-S1757010AbXIYA77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010AbXIYA77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 20:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbXIYA7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 20:59:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528AbXIYA7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 20:59:50 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
X-Fcc: ~/Mail/linus
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       David Woodhouse <dwmw2@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] powerpc: ptrace CHECK_FULL_REGS
In-Reply-To: Benjamin Herrenschmidt's message of  Tuesday, 25 September 2007 10:33:26 +1000 <1190680406.12382.9.camel@localhost.localdomain>
References: <20070924235052.5AFC24D04B7@magilla.localdomain>
	<1190680406.12382.9.camel@localhost.localdomain>
X-Windows: never had it, never will.
Message-Id: <20070925005945.02E924D04B7@magilla.localdomain>
Date: Mon, 24 Sep 2007 17:59:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Yup, I think I ditched most of them.. for some reason I decided it
> couldn't happen, but maybe I'm wrong ?

Well, it's a BUG_ON.  It's supposed to be for something that "can't happen".
That's why it's a sanity check, not a wild assertion. ;-)

The 2/2 patch is an example of a bug that CHECK_FULL_REGS catches.
In the status quo, using PTRACE_PEEKUSR in a bug case crashes while using
PTRACE_GETREGS in the same place might get bogus data.  (In the actual bug
thus found, the data is not bogus and only the bit that FULL_REGS checks is.)


Thanks,
Roland
