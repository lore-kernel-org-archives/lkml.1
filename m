Return-Path: <linux-kernel-owner+w=401wt.eu-S1754287Ab0AVU6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab0AVU6b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 15:58:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753969Ab0AVU6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 15:58:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40991 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840Ab0AVU63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 15:58:29 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] PM: Force GFP_NOIO during suspend/resume (was: Re: [linux-pm] Memory allocations in .suspend became very unreliable)
Date: Fri, 22 Jan 2010 21:58:46 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, "linux-mm" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20100121091023.3775.A69D9226@jp.fujitsu.com> <201001212121.50272.rjw@sisk.pl> <20100122100155.6C03.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100122100155.6C03.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201001222158.46337.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 January 2010, KOSAKI Motohiro wrote:
> > > Probably we have multiple option. but I don't think GFP_NOIO is good
> > > option. It assume the system have lots non-dirty cache memory and it isn't
> > > guranteed.
> > 
> > Basically nothing is guaranteed in this case.  However, does it actually make
> > things _worse_?  
> 
> Hmm..
> Do you mean we don't need to prevent accidental suspend failure?
> Perhaps, I did misunderstand your intention. If you think your patch solve
> this this issue, I still disagree.

No, I don't.

> but If you think your patch mitigate the pain of this issue, I agree it.

That's what I wanted to say really.

> I don't have any reason to oppose your first patch.

Great!

> > What _exactly_ does happen without the $subject patch if the
> > system doesn't have non-dirty cache memory and someone makes a GFP_KERNEL
> > allocation during suspend?
> 
> Page allocator prefer to spent lots time for reclaimable memory searching than
> returning NULL. IOW, it can spent time few second if it doesn't have
> reclaimable memory.
> In typical case, OOM killer forcely make enough free memory if the system
> don't have any memory. But under suspending time, oom killer is disabled.
> So, if the caller (probably drivers) call alloc >1000times, the system
> spent lots seconds.
> 
> In this case, GFP_NOIO doesn't help. slowness behavior is caused by
> freeable memory search, not slow i/o.
> 
> However, if strange i/o device makes any i/o slowness, GFP_NOIO might help.
> In this case, please don't ask me about i/o thing. I don't know ;)

OK, thanks for the explanation.

Rafael
