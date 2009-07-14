Return-Path: <linux-kernel-owner+w=401wt.eu-S1752971AbZGNCZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971AbZGNCZr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 22:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbZGNCZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 22:25:46 -0400
Received: from mail.deathmatch.net ([72.66.92.28]:1285 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbZGNCZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 22:25:45 -0400
Date: Mon, 13 Jul 2009 22:24:58 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
Message-ID: <20090714022458.GB28490@hash.localnet>
References: <20090320131437.GA30120@hash.localnet> <20090329142432.GA15578@sucs.org> <20090329151401.GA26510@hash.localnet> <20090331083041.GA19657@sucs.org> <20090513214416.GA4492@sucs.org> <20090515040904.GA32357@hash.localnet> <20090518100540.GB21150@sucs.org> <20090522093930.GA15375@sucs.org> <20090526211029.GA2011@sucs.org> <20090628202329.GB1546@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090628202329.GB1546@sucs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 28, 2009 at 09:23:29PM +0100, Sitsofe Wheeler wrote:
> OK I'm still trying to follow this. I forwarded your patch to 2.6.31-rc1
> but this time I have kmemleak enabled. I left it streaming radio for the
> past few hours and the following appeared in the logs:
> 
> Jun 28 17:01:34 eeepc kernel: [  744.083787] kmemleak: unreferenced object 0xf5845770 (size 64):
> Jun 28 17:01:34 eeepc kernel: [  744.083795] kmemleak:   comm "swapper", pid 1, jiffies 4294673468
> Jun 28 17:01:34 eeepc kernel: [  744.083799] kmemleak:   backtrace:
> Jun 28 17:01:34 eeepc kernel: [  744.083811] kmemleak:     [<c01a749d>] kmemleak_alloc+0x11d/0x2a0
> Jun 28 17:01:34 eeepc kernel: [  744.083818] kmemleak:     [<c01a4376>] __kmalloc+0x136/0x210
> Jun 28 17:01:34 eeepc kernel: [  744.083828] kmemleak:     [<c043f923>] ieee80211_register_hw+0x83/0x4b0
[snip]


> There were quite a few leaks before this. I dunno if kmemleak is
> spurious or not. As always, any ideas?

I can't seem to boot a kmemleak kernel myself.  But there were a number
of fixes to kmemleak recently to track memory allocated in
ieee80211_register_hw, IIRC -- so it would be good to know if this
persists with all the latest fixes.

As always, no ideas :(  I'm guessing nothing in .31-rc has magically
fixed any problems?  I still say it's some kind of race condition
made worse by the eeepc performance, but unless I can find one or
replicate it with introduced load, I'm afraid I'm stumped.  

(Well, I guess we can always go off and rewrite the rx loop without
the circular terminator and see how well that works on your HW.)

-- 
Bob Copeland %% www.bobcopeland.com

