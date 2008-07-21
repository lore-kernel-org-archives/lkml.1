Return-Path: <linux-kernel-owner+w=401wt.eu-S1756868AbYGUPYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868AbYGUPYc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 11:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbYGUPYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 11:24:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57073
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752782AbYGUPYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 11:24:20 -0400
Date: Mon, 21 Jul 2008 08:24:19 -0700 (PDT)
Message-Id: <20080721.082419.70392960.davem@davemloft.net>
To: mingo@elte.hu
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: [crash] BUG: unable to handle kernel NULL pointer dereference
 at 0000000000000370
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080721150446.GA17746@elte.hu>
References: <20080721134506.GA27598@elte.hu>
	<20080721143023.GA32451@elte.hu>
	<20080721150446.GA17746@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 21 Jul 2008 17:04:48 +0200

[ Adding linux-wireless CC, again, Ingo please retain it for
  followups, thanks! ]

> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > Pid: 1, comm: swapper Not tainted 2.6.26-tip-00013-g6de15c6-dirty #21290
> > 
> > some more information: find below the same crash with vanilla 
> > linus/master and no extra patches. The crash site is:
> 
> a 32-bit testbox just triggered the same crash too:
> 
>  calling  init_mac80211_hwsim+0x0/0x310
>  mac80211_hwsim: Initializing radio 0
>  phy0: Failed to select rate control algorithm
>  phy0: Failed to initialize rate control algorithm
>  mac80211_hwsim: ieee80211_register_hw failed (-2)
>  BUG: unable to handle kernel NULL pointer dereference at 00000298
>  IP: [<c06efb98>] rollback_registered+0x28/0x120
>  *pdpt = 0000000000bc9001 *pde = 0000000000000000
>  Oops: 0000 [#1] PREEMPT SMP
> 
> and that system has no wireless so i guess it's just some unregister 
> inbalance kind of init/deinit buglet.
> 
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
