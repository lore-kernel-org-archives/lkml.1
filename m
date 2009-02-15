Return-Path: <linux-kernel-owner+w=401wt.eu-S1755248AbZBONrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbZBONrs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 08:47:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754011AbZBONri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 08:47:38 -0500
Received: from mail.deathmatch.net ([70.167.247.36]:1490 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827AbZBONrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 08:47:37 -0500
Date: Sun, 15 Feb 2009 08:47:02 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Dhaval Giani <dhaval.lists@thegianis.in>
Cc: Jiri Slaby <jirislaby@gmail.com>, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       linville@tuxdriver.com, davem@davemloft.net,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ath5k: fix hw rate index condition
Message-ID: <20090215134702.GA10180@hash.localnet>
References: <1231336282-22283-1-git-send-email-jirislaby@gmail.com> <1231338965-796-1-git-send-email-jirislaby@gmail.com> <20090107152208.GB4207@linux.vnet.ibm.com> <4964CAAA.3040801@gmail.com> <25891f3e0902012357n21e7bc2fmc59fb2a842631651@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25891f3e0902012357n21e7bc2fmc59fb2a842631651@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 02, 2009 at 01:27:39PM +0530, Dhaval Giani wrote:
> So I finally managed to hit this on 2.6.29-rc3. It is hard to
> reproduce, so I hope so much information is enough to give you a good
> guess. This time it hit while trying to connect to an open network at
> the airport.

> WARNING: at net/mac80211/rx.c:2236 __ieee80211_rx+0x96/0x571 [mac80211]()
> Hardware name: 2007CS3
> RATE=255, BAND=8

band is supposed to be sc->curband?  8 is way wrong.  rate could be 255
if, for some reason, the hardware rate wasn't in the rate table.

> Pid: 2634, comm: X Not tainted 2.6.29-rc3 #18
> Call Trace:
>  [<c0430636>] warn_slowpath+0x76/0xad
>  [<c04508d7>] ? __lock_acquire+0xb36/0xb45
>  [<f7dd0205>] __ieee80211_rx+0x96/0x571 [mac80211]
>  [<f7e37976>] ath5k_tasklet_rx+0x4fb/0x53d [ath5k]
>  [<c06fa5c3>] ? _spin_unlock_irq+0x27/0x34
>  [<c0434f91>] tasklet_action+0x85/0xf0

Interestingly I hit this just the other day -- I was debugging something
else and had a serial console hooked up, otherwise I wouldn't have
noticed at all.  It happened at some point during a suspend-to-ram
sequence, which makes at least my version sound like a race condition
of some sort.



