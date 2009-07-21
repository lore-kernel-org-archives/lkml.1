Return-Path: <linux-kernel-owner+w=401wt.eu-S1753640AbZGUNT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbZGUNT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 09:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753175AbZGUNT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 09:19:57 -0400
Received: from fn.samba.org ([216.83.154.106]:41699 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431AbZGUNT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 09:19:57 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19045.48361.502946.399660@samba.org>
Date: Tue, 21 Jul 2009 23:04:41 +1000
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Martin Steigerwald <Martin@lichtvoll.de>,
       Jan Engelhardt <jengelh@medozas.de>, Theodore Tso <tytso@mit.edu>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org, torvalds@linux-foundation.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
In-Reply-To: <4A65875D.7030902@panasas.com>
References: <19013.8005.541836.436991@samba.org>
	<alpine.LSU.2.00.0907062221520.27775@fbirervta.pbzchgretzou.qr>
	<19026.38137.63807.427511@samba.org>
	<200907072356.51553.Martin@lichtvoll.de>
	<19028.3736.892828.352905@samba.org>
	<20090708110451.1092afa7@lxorguk.ukuu.org.uk>
	<1247066878.4159.153.camel@mulgrave.site>
	<20090708163736.0f98e7e0@lxorguk.ukuu.org.uk>
	<1247069202.4159.212.camel@mulgrave.site>
	<20090708171848.21633768@lxorguk.ukuu.org.uk>
	<873a96a23x.fsf@devron.myhome.or.jp>
	<87hbxhwv0j.fsf@devron.myhome.or.jp>
	<19045.14307.658887.752950@samba.org>
	<4A65875D.7030902@panasas.com>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boaz,

 > I guess you tried putting a zero at first char and it breaks everybody?

It works with some devices, but with many it doesn't. A space followed
by a nul works with quite a lot of devices, but not enough (the last
patch used a space followed by a nul).

I went to a large electronics store and told them I wanted to buy
devices that didn't work with my computer. They were very helpful, and
as a result I was able to test a lot of devices. That is what led to
the design of this patch (plus the feedback from people like Jan and
his IOneIt MP3 player).

 > I guess (35^6)*8*7 is not that bad

yes, but luckily For the WinXP bluescreen the probability of the crash
is actually much lower than that figure would give. With the same
modelling assumptions of WinXP memory slots for 8.3 entries that Paul
used for the last patch, it comes out as less than a 1 in 10k chance
for a full directory (ie. 32767 long filenames). For 100 files in a
directory it is around 1 chance in 10^11. I'm sure Paul will do the
full expansion and modelling if anyone wants more precise numbers.

For the chkdsk rename, the probability is much easier to calculate as
it is just the usual birthday expansion (see wikipedia for simple
formula for that). That is what gives 0.5% for 32767 files in a
directory, and 4.8x10^-8 for for 100 files.

Basically it won't happen very often. In each case the probability is
rougly 75x less than it was for the last patch.

 > What if we had a user mode utility that does these short-names
 > renames that a user can optionally run after umount? since it
 > only writes the (random) short-names it's also safe.

While I will defer to John Lanza if you want a more complete legal
view on this, I think it is likely that separating the steps of the
patent between programs within one system is not a safe enough legal
strategy to be used.

Please do keep thinking about it though. There could well be some
simple combination which is legally safe and also technically
completely satisfactory. If you think you have hit on a winner, you
may wish to discuss it with John Lanza in private first though, so it
can be fine tuned before being presented publicly.

Cheers, Tridge
