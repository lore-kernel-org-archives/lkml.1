Return-Path: <linux-kernel-owner+w=401wt.eu-S934222AbXLQGwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934222AbXLQGwm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 01:52:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760916AbXLQGwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 01:52:32 -0500
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:53070 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758487AbXLQGwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 01:52:32 -0500
Message-ID: <47661CA1.3080808@lwfinger.net>
Date: Sun, 16 Dec 2007 22:52:17 -0800
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: mvtodevnull@gmail.com
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Michael Buesch <mb@bu3sch.de>,
       Daniel Walker <dwalker@mvista.com>, Ray Lee <ray-lk@madrabbit.org>,
       =?ISO-8859-1?Q?Simon_Holm_Th=F8gerse?= =?ISO-8859-1?Q?n?= 
	<odie@cs.aau.dk>,
       matthias.kaehlcke@gmail.com, linux-kernel@vger.kernel.org,
       linux@bohmer.net, Ingo Molnar <mingo@elte.hu>, kjwinchester@gmail.com,
       jonathan@jonmasters.org, akpm@linux-foundation.org,
       bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore
 to mutex
References: <20071213003028.676998182@mvista.com>	 <200712141404.24275.mb@bu3sch.de> <200712150151.49025.rjw@sisk.pl>	 <476326A1.6090404@lwfinger.net>	 <520b60a90712141759h65f1e63ei65ba00887a930d06@mail.gmail.com>	 <47633BAE.6040604@lwfinger.net>	 <520b60a90712142037j14d54de5nf5657ab2927fb3f5@mail.gmail.com>	 <520b60a90712142039t539faeddo68e73816fe1b3237@mail.gmail.com>	 <47637FDA.2030303@lwfinger.net>	 <520b60a90712150438p1f0ae40bt5975b494ab75203c@mail.gmail.com> <520b60a90712161817uaa2d1a8y5dfb13b586ca30ad@mail.gmail.com>
In-Reply-To: <520b60a90712161817uaa2d1a8y5dfb13b586ca30ad@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mvtodevnull@gmail.com wrote:
> On Dec 15, 2007 7:38 AM,  <mvtodevnull@gmail.com> wrote:
>> I'll build latest wireless git without ipv6 late tonight.
> 
> Ok, built and tested, and it's actually faster! Although still not as
> fast as bcm43xx or softmac or whatever the problem is, I was getting a
> steady 200 kB/s (as opposed to 500 kB/s for bcm43xx with the same
> file/server). I'm not sure if it was the absence of ipv6 or the
> commits included in updating my git repository though. Either way, I'm
> fairly happy that I'm out of dial-up speed territory.
> 
> It'd be nice to be able to fully shake loose whatever is causing the
> speed drain - and I call it a drain since sometimes the connection
> starts out much faster, but slowly throttles down to whatever speed
> it'll stick at (used to be 40 kB/s, but now is 200 kB/s). It does seem
> to be like a cap or limit, as in if I download two files, each one
> will download at 100 kB/s.
> 
> If anyone can help I'd really appreciate it. I know that bcm43xx will
> someday be dropped, and when that day comes, it'd be nice if people
> with this hardware have at least similar performance with b43 (myself
> especially).

One major difference between bcm43xx-SoftMAC and b43-mac80211 is that the former always used a fixed
rate; whereas mac80211 tries to adjust the bit rate according to the transmission conditions.
Perhaps it isn't working quite right in your case because of some peculiarity of your AP. IIRC, you
have an 802.11b AP. If so, you will get the same bit speed behavior for mac80211 as for bcdm43xx by
issuing a 'sudo iwconfig eth1 rate 11M' command.

Larry
