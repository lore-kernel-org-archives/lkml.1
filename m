Return-Path: <linux-kernel-owner+w=401wt.eu-S1762858AbYBLK3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762858AbYBLK3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 05:29:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761653AbYBLK3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 05:29:31 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39597 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761395AbYBLK3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 05:29:30 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
X-Fcc: ~/Mail/linus
Cc: Ingo Molnar <mingo@elte.hu>, "Frank Ch. Eigler" <fche@redhat.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] kgdb-light -v9
In-Reply-To: Andi Kleen's message of  Tuesday, 12 February 2008 11:03:27 +0100 <20080212100327.GA30873@one.firstfloor.org>
References: <20080211015321.GA27376@one.firstfloor.org>
	<y0mhcgf4ig1.fsf@ton.toronto.redhat.com>
	<20080211162141.GA31434@elte.hu>
	<20080211171039.GA20446@one.firstfloor.org>
	<20080211230335.GA16102@elte.hu>
	<20080212100327.GA30873@one.firstfloor.org>
X-Windows: form follows malfunction.
Message-Id: <20080212102636.02715270192@magilla.localdomain>
Date: Tue, 12 Feb 2008 02:26:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You silently overwrite any user ptrace hw breakpoints right? To do it cleanly 
> would still require a reservation frame work.

There was work underway on that before (hw_breakpoint).  I'm not entirely
sure you want to use fancy stuff like that in kgdb.  It's nice for kgdb to
be as self-contained as possible, so you can debug everything else with it.
If you're going to rely on lots of higher-level infrastructure, it could be
using kprobes for its software breakpoint handling, too.

At any rate, I think it would be good if the hw breakpoint support in kgdb
were chopped out into a separate patch.  First make kgdb work with no code
touching debug registers at all.  Then a second patch can add the hw
breakpoint support.  The latter one can be mulled over or replaced with a
hw_breakpoint merge or just put off for a while because it's a big can of
worms to multiplex the use of the debug registers.


Thanks,
Roland
