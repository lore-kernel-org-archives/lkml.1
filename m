Return-Path: <linux-kernel-owner+w=401wt.eu-S1753933AbYGUPFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbYGUPFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 11:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753117AbYGUPFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 11:05:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33839 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402AbYGUPFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 11:05:01 -0400
Date: Mon, 21 Jul 2008 17:04:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [crash] BUG: unable to handle kernel NULL pointer dereference
	at 0000000000000370
Message-ID: <20080721150446.GA17746@elte.hu>
References: <20080720.104411.81744468.davem@davemloft.net> <20080721133059.GA30637@elte.hu> <20080721134506.GA27598@elte.hu> <20080721143023.GA32451@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080721143023.GA32451@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > Pid: 1, comm: swapper Not tainted 2.6.26-tip-00013-g6de15c6-dirty #21290
> 
> some more information: find below the same crash with vanilla 
> linus/master and no extra patches. The crash site is:

a 32-bit testbox just triggered the same crash too:

 calling  init_mac80211_hwsim+0x0/0x310
 mac80211_hwsim: Initializing radio 0
 phy0: Failed to select rate control algorithm
 phy0: Failed to initialize rate control algorithm
 mac80211_hwsim: ieee80211_register_hw failed (-2)
 BUG: unable to handle kernel NULL pointer dereference at 00000298
 IP: [<c06efb98>] rollback_registered+0x28/0x120
 *pdpt = 0000000000bc9001 *pde = 0000000000000000
 Oops: 0000 [#1] PREEMPT SMP

and that system has no wireless so i guess it's just some unregister 
inbalance kind of init/deinit buglet.

	Ingo
