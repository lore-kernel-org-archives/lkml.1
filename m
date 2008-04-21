Return-Path: <linux-kernel-owner+w=401wt.eu-S1754740AbYDUVbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbYDUVbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 17:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbYDUVbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 17:31:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362AbYDUVbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 17:31:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: "Jan Beulich" <jbeulich@novell.com>
X-Fcc: ~/Mail/linus
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: prevent unconditional writes to DebugCtl MSR
In-Reply-To: Jan Beulich's message of  Monday, 21 April 2008 17:34:19 +0100 <480CDE2B.76E4.0078.0@novell.com>
References: <20080418194334.7483627037C@magilla.localdomain>
	<20080421155534.GA1284@elte.hu>
	<480CDE2B.76E4.0078.0@novell.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20080421213030.ECD0926F8F0@magilla.localdomain>
Date: Mon, 21 Apr 2008 14:30:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >agreed. Jan, wanna send a fix for this?
> 
> Hmm, without knowing the context here I'd say the way it's done in
> .25 is quite reasonable; a BUG_ON() here would seem quite rude to
> me. I thought it really should be the call sites ensuring this doesn't
> get called, and the silent ignoring is just to prevent bringing the
> system down. A WARN_ON() (or perhaps even WARN_ON_ONCE()) would
> be the most I'd be inclined to add there.

Like I said, the call sites already do ensure that it doesn't get called.
If there were any such bug, then the 2.6.25 behavior of silently being
broken is inordinately rude.  Since we think there is no such bug now, the
BUG_ON would not be hit, and if it is then it's deservedly so.  I don't
care whether it's a BUG_ON or a WARN_ON, since the point is that it never
happen.  What I object to is the change you made in 2.6.25, which ensures
that extra cycles at low level will be spent on every call, to guarantee
that any such bug in the future is maximally confusing.  That is not helping.


Thanks,
Roland
