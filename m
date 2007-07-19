Return-Path: <linux-kernel-owner+w=401wt.eu-S937681AbXGSPI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937681AbXGSPI0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 11:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763252AbXGSPIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 11:08:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35904 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761491AbXGSPIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 11:08:14 -0400
Date: Thu, 19 Jul 2007 17:07:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Olaf Kirch <olaf.kirch@oracle.com>
Cc: Jarek Poplawski <jarkao2@o2.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, davem@davemloft.net,
       Auke Kok <auke-jan.h.kok@intel.com>
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Message-ID: <20070719150728.GA17000@elte.hu>
References: <20070716091236.GA10718@elte.hu> <200707191144.24434.olaf.kirch@oracle.com> <20070719100135.GA2986@elte.hu> <200707191237.56455.olaf.kirch@oracle.com> <20070719104756.GA13769@elte.hu> <20070719105816.GA15852@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719105816.GA15852@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


ugh. Something really weird happened with this e1000 problem.

i crashed the laptop in a weird way and had to power-cycle it in an 
unusual fashion. After that i wanted to try your latest BUG_ON() theory 
but the network hang went away!

For 3 hours i tried to reproduce the hang (i went back to the original 
git tree and the .config under which i found it, i power cycled it 
again, i unplugged the power cord to make it go off battery, unplugged 
the ethernet, recreated a completely new tree, etc. etc.) but with no 
success! Total Heisenbug - and the really annoying thing is that you 
just had a good theory about what might be happening. I'm now at kernel 
build iteration #75 in this tree ...

maybe it's not the power-cycling that somehow brought the e1000 out of 
its weird state but the ethtool ops (and the related firmware readouts, 
etc.)?

(i have your BUG_ON() applied (as a WARN_ON()), but it doesnt trigger. 
Not that this means anything under these circumstances ...)

	Ingo
