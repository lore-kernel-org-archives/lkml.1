Return-Path: <linux-kernel-owner+w=401wt.eu-S1757482AbZJDRAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbZJDRAg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 13:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757116AbZJDRAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 13:00:35 -0400
Received: from www.tglx.de ([62.245.132.106]:37783 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756877AbZJDRAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 13:00:35 -0400
Date: Sun, 4 Oct 2009 18:59:46 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Anirban Sinha <ani@anirban.org>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Darren Hart <dvhltc@us.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Kaz Kylheku <kaz@zeugmasystems.com>,
       Anirban Sinha <asinha@zeugmasystems.com>
Subject: Re: futex question
In-Reply-To: <4AC8CF32.8060108@anirban.org>
Message-ID: <alpine.LFD.2.00.0910041853180.2646@localhost.localdomain>
References: <DDFD17CC94A9BD49A82147DDF7D545C501FD7F97@exchange.ZeugmaSystems.local> <20091001092218.GH15345@elte.hu> <DDFD17CC94A9BD49A82147DDF7D545C501FD8409@exchange.ZeugmaSystems.local> <4AC68F13.8050601@us.ibm.com> <alpine.LFD.2.00.0910041031330.2646@localhost.localdomain>
 <DDFD17CC94A9BD49A82147DDF7D545C501F457C5@exchange.ZeugmaSystems.local> <4AC8CF32.8060108@anirban.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Oct 2009, Anirban Sinha wrote:

> >> 1) What caused you to instrument this path in the first place?  Were you
> >> seeing some unexpected behavior?
> >>
> >> 2) I wonder why we would need to clear the robust list, but I don't see other
> >> things like pi_blocked_on, etc. in execve being cleared.  I'm looking into
> >> this now (perhaps we don't do the same cleanup, need to check).... have to get
> >> on the plane...
> > 
> > Hmm, just setting the robust list pointer to NULL fixes the problem at
> > hand, but I wonder whether we need to call exit_robust_list() as
> > well. 
 
> hmm. That is an interesting thought. But I wonder if acquiring a
> lock and then exec()ing in the critical section is a legal thing to

It's definitely legal. There is no law which forbids to do that. :)

> do. It does not feel right. Currently, with or without my change,
> such a thing would indefinitely block other waiters on the same
> futex.

Right. Which completely defeats the purpose of the robust list. Will
have a look tomorrow.

Thanks,

	tglx
