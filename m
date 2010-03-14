Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab0CNFtj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 00:49:39 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51704 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750796Ab0CNFtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 00:49:36 -0500
Date: Sat, 13 Mar 2010 21:46:46 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Jiri Kosina <jkosina@suse.cz>, Larry Finger <Larry.Finger@lwfinger.net>,
       WANG Cong <xiyou.wangcong@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Tejun Heo <tj@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] base firmware: Fix BUG from sysfs attributes change in
 commit a2db6842873c8e5a70652f278d469128cb52db70
In-Reply-To: <m1fx43zhbd.fsf@fess.ebiederm.org>
Message-ID: <alpine.LFD.2.00.1003132131470.3719@i5.linux-foundation.org>
References: <4b9be956.x5+yAHXGDfXer810%Larry.Finger@lwfinger.net> <alpine.LFD.2.00.1003131426480.3719@i5.linux-foundation.org> <alpine.LRH.2.00.1003132336380.12517@twin.jikos.cz> <alpine.LFD.2.00.1003131455420.3719@i5.linux-foundation.org>
 <m1fx43zhbd.fsf@fess.ebiederm.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 13 Mar 2010, Eric W. Biederman wrote:
> 
> It also only affects those fairly rare lockdep users as well, and the only
> affect is to throw a nasty warning message.  Isn't lockdep all about throwing
> nasty warning messages?

Hmm. The report has that "BUG: " message in it (and in the subject line), 
but you're right - it ends up being just a warning, not actually a real 
BUG() (which is a machine killer).

So yeah - it's not as bad as I thought. Sorry.

[ And that "BUG:" in turn seems to be due to Ingo for some reason wanting 
  to confuse BUG_ON() messages (which have that "BUG: " prefix thing) with 
  whatever warning conditions he adds.

  Our warnings used to have that bug too (see commit 8f53b6fcc4: "Don't 
  call a warnign a bug. It's a warning.").

  Ingo: can we agree to not put "BUG: " messages in warnings, ok? It may 
  be a bug (lower-case) that triggers them, but that whole "BUG()" thing 
  has it's own semantics with rather more serious consequences than some 
  warning that lets things continue.

  So I - and I suspect others - react rather more strongly to "BUG:" than 
  to "WARNING:" or to just some regular innocuous message without the
  associations of the machine likely being dead as a result. ]

				Linus
