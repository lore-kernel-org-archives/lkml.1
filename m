Return-Path: <linux-kernel-owner+w=401wt.eu-S1752316AbZJPV5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbZJPV5m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 17:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbZJPV5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 17:57:41 -0400
Received: from anchor-post-2.mail.demon.net ([195.173.77.133]:59641 "EHLO
	anchor-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751070AbZJPV5k convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 17:57:40 -0400
Date: Fri, 16 Oct 2009 22:28:27 +0100
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: Fabio Comolli <fabio.comolli@gmail.com>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org, rjw@sisk.pl,
       linux-wireless@vger.kernel.org
Subject: Re: [Regression] - 2.6.32-rc5 hangs using rfkill on an eeePC
Message-ID: <50B0C1487C%linux@youmustbejoking.demon.co.uk>
In-Reply-To: <b637ec0b0910161423o2a5fdd12u926f50c2e4139bf3@mail.gmail.com>
References: <b637ec0b0910161253y60eb6b4fl3e49e5b9129d81ac@mail.gmail.com> 
 <200910162246.45678.elendil@planet.nl> 
 <b637ec0b0910161423o2a5fdd12u926f50c2e4139bf3@mail.gmail.com>
Mail-Followup-To: Fabio Comolli <fabio.comolli@gmail.com>, Frans Pop 
 <elendil@planet.nl>, linux-kernel@vger.kernel.org, rjw@sisk.pl, 
 linux-wireless@vger.kernel.org, Darren Salt <linux@youmustbejoking.demon.co.uk>
User-Agent: Messenger-Pro/2.60.0.3101 (Qt/4.5.2) (Linux-x86_64)
X-NuLabour-Date: Fri, 9086 Dec 1984 22:28:27 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-SA-Exim-Connect-IP: 192.168.0.5
X-SA-Exim-Mail-From: linux@youmustbejoking.demon.co.uk
X-SA-Exim-Scanned: No (on pentagram.youmustbejoking.demon.co.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I demand that Fabio Comolli may or may not have written...

[snip]
> I already answered my own post in the thread: the culprit is:

> eeepc-laptop: Prevent a panic when disabling RT2860 wireless when
> associated

> Funnily enough, my eeePC has an Atheros card.

We (myself and Corentin Chary) tried to stop that patch once I'd noticed the
problem – I updated the patch, tested (all was fine with the rt2860 card),
upgraded from -rc3 to -rc4, installed an Intel 3945 card, tested, sent the
patch, restored the rt2860 card to its proper place, happened to toggle
wireless, got a panic due to having failed to remember to actually apply the
patch to -rc4... at this point, I rechecked with the Intel card (this time
with a patched kernel), saw a failure (stuck process – hmm, should rfkill be
re-entrant?), reported it, went digging into rt2860sta and produced, tested
and sent the replacement patch, then tried to stop the broken patch from
going upstream.

A reversion patch has been sent by Corentin (shortly after you reported this,
though the commit message says that he's reacted to its being in rc5) and,
earlier today, I directly requested that it be reverted; so hopefully, one
way or another, -rc6 will be fine for Atheros users and anybody else affected
by this, much as -rc5 is for rt2860 users.

Oh well. So much for Linus's "no new regressions". ;-}

-- 
| Darren Salt            | linux at youmustbejoking | nr. Ashington, | Doon
| using Debian GNU/Linux | or ds    ,demon,co,uk    | Northumberland | Army
| + Travel less. Share transport more.           PRODUCE LESS CARBON DIOXIDE.

Look! Over there!... Ha. Made you look.
