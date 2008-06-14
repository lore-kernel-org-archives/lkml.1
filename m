Return-Path: <linux-kernel-owner+w=401wt.eu-S1753689AbYFNISQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689AbYFNISQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 04:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757043AbYFNIRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 04:17:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50426 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754120AbYFNIRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 04:17:12 -0400
Date: Sat, 14 Jun 2008 10:16:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: [GIT]: Networking
Message-ID: <20080614081656.GA27820@elte.hu>
References: <20080612.211959.52937006.davem@davemloft.net> <20080614060320.GA18454@elte.hu> <20080614062758.GA23803@elte.hu> <20080614.001428.26649070.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080614.001428.26649070.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* David Miller <davem@davemloft.net> wrote:

> > just to clarify the bug pattern: the box was still accessible after 
> > the warning. So this is a far less serious problem and i'd suggest 
> > we open up a separate regression entry for it and consider the 
> > hung-TCP problem closed. (i havent seen the hang in the last week, 
> > with either version of the tcp-accept reverts)
> 
> It is a warning that just means the transmitted on the network device 
> stalled for an unusually long period of time.  Is your subnet flooded 
> when these warnings occur?  Is the remove side system wedged or at a 
> very high load when the message triggers?

yes, both the network and the testbox is at relatively high load, it's a 
distcc kernel build over the network. Thousands of such iterations were 
done successfully without this warning ever triggering - it triggered 
for the first time in about 10,000 bootups the moment i applied your 
version of the reverts. When i applied the small diff the warning did 
not come back.

> All of these would be useful points of information to determine if 
> this might be normal or not.
> 
> In theory, if the remove port the device is connected to gets 
> extremely congested, emits a pause frame to your machine, but never 
> releases that pause, this (new) warning could trigger.
> 
> This warning was added by Arjan in 2.6.25 FYI in order to diagnose the 
> not-normal cases better.

ok, should we then remove that warning, if it's spurious? kerneloops.org 
has picked up a few other instances of this warning as well:

  http://www.kerneloops.org/searchfile.php?search=net%2Fsched%2Fsch_generic.c&btnG=Filename+Search

	Ingo
