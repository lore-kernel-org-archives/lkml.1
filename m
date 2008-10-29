Return-Path: <linux-kernel-owner+w=401wt.eu-S1753637AbYJ2Juv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637AbYJ2Juv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 05:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbYJ2Jul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 05:50:41 -0400
Received: from intermatrixgroup.ru ([195.178.208.66]:49976 "EHLO
	tservice.net.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbYJ2Juk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 05:50:40 -0400
Date: Wed, 29 Oct 2008 12:50:37 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, David Miller <davem@davemloft.net>,
       alan@lxorguk.ukuu.org.uk, jkosina@suse.cz, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, rjw@sisk.pl, s0mbre@tservice.net.ru,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [tbench regression fixes]: digging out smelly deadmen.
Message-ID: <20081029095037.GA7973@ioremap.net>
References: <20081027113306.5b1d5898@lxorguk.ukuu.org.uk> <20081027183312.GD11494@elte.hu> <20081027193933.GB2590@ioremap.net> <20081027.124848.163119274.davem@davemloft.net> <1225189462.4903.238.camel@marge.simson.net> <20081028103741.GA22319@elte.hu> <20081029091405.GA3780@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081029091405.GA3780@ioremap.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 12:14:05PM +0300, Evgeniy Polyakov (zbr@ioremap.net) wrote:
> vanilla 27	: 347.222
> no TSO/GSO	: 357.331
> no hrticks	: 382.983
> no balance	: 389.802
> 4403b4 commit	: 361.184
> dirty_ratio-50	: 361.086
> no-sched-tweaks	: 361.367
> 
> So, probably, if we revert -tip merge to vanilla .27, add nohrtick patch
> and nobalance tweak _only_, and apply naive TSO patch we could bring
> system to 400 MB/s. Note, that .22 has 479.82 and .23 454.36 MB/s.

And now I have to admit that the very last -top merge did noticebly
improve the situation upto 391.331 MB/s (189 in domains, with tso/gso
off and naive tcp_tso_should_defer() hange).

So we are now essentially at the level of 24-25 trees in my tests.

-- 
	Evgeniy Polyakov
