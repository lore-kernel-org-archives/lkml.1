Return-Path: <linux-kernel-owner+w=401wt.eu-S1754138AbXLCKiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbXLCKiu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 05:38:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbXLCKim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 05:38:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36784 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbXLCKim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 05:38:42 -0500
Date: Mon, 3 Dec 2007 11:38:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Radoslaw Szkodzinski <lkml@astralstorm.puszkin.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
Message-ID: <20071203103815.GA2707@elte.hu>
References: <20071202114152.3bf4332d@laptopd505.fenrus.org> <20071202200953.GA23994@one.firstfloor.org> <20071202202602.GA16480@elte.hu> <20071202204725.GA25891@one.firstfloor.org> <20071202144331.6abf1289@laptopd505.fenrus.org> <20071203000741.GB26636@one.firstfloor.org> <20071202165913.3eaebee6@laptopd505.fenrus.org> <20071203095501.GB28560@one.firstfloor.org> <20071203111520.33ed2139@astralstorm.puszkin.org> <20071203102715.GC28560@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071203102715.GC28560@one.firstfloor.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > Kernel waiting 2 minutes on TASK_UNINTERRUPTIBLE is certainly broken.
> 
> What should it do when the NFS server doesn't answer anymore or when 
> the network to the SAN RAID array located a few hundred KM away 
> develops some hickup?  [...]

maybe: if the user does a Ctrl-C (or a kill -9), the kernel should try 
to honor it, instead of staying there stuck for a very long time 
(possibly forever)?

I think you are somehow confusing two issues: this patch in no way 
declares that "long waits are bad" - if the user _choses_ to wait for 
the NFS server (after phoning IT quickly or whatever), he can wait an 
hour. This patch only declares that "long waits _that the user has no 
way to stop_ are quite likely bad".

Do you see the important distinction between the two cases? Please 
reconsider your position (or re-state it differently), it just makes no 
rational sense to me so far.

	Ingo
