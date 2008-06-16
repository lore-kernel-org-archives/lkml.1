Return-Path: <linux-kernel-owner+w=401wt.eu-S1756925AbYFPCwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925AbYFPCwN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 22:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750869AbYFPCv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 22:51:56 -0400
Received: from mail.vyatta.com ([216.93.170.194]:35023 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbYFPCvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 22:51:55 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.017
Date: Sun, 15 Jun 2008 19:51:48 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: David Newall <davidn@davidnewall.com>
Cc: OBATA Noboru <noboru.obata.ar@hitachi.com>,
       "David S. Miller" <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-net@vger.kernel.org
Subject: Re: Feedback on TCP: Make TCP_RTO_MAX a variable
Message-ID: <20080615195148.28c85c36@extreme>
In-Reply-To: <4855823F.40208@davidnewall.com>
References: <4855823F.40208@davidnewall.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2008 06:27:35 +0930
David Newall <davidn@davidnewall.com> wrote:

> Last year, Obata Noboru sent a patch to permit adjustment of
> TCP_RTO_MAX, which I have found useful.  Refer to
> http://marc.info/?l=linux-netdev&m=118422471428855 for details.
> 
> A customer reported that their internet-connected POS terminals were
> regularly "freezing" for extended periods, sometimes for as long as a
> few minutes.  My analysis, such as it was, suggested that those
> occasions were caused by floods of packets directed towards the internet
> link at one end or the other (i.e. POS terminal or central server),
> leading to severe packet loss and maximum packet retransmit times during
> which no session data could be transmitted.  I believe those floods were
> caused by anonymous third parties scanning the internet, and attempting
> to break through my client's routers.  I also believe that to be an
> unavoidable social quality of the internet; I have to live with it.

Why are you letting them through. Use proper firewalling.

> Having a "cash register" randomly freeze for minutes at a time is not
> acceptable, and neither does it seem necessary.  Using Obata Noboru's
> patch, I set TCP_RTO_MAX to 5 seconds at both ends.  The system has been
> running thus for five weeks, and I have not been called by my customer
> since.  While this change obviously did nothing to solve the underlying
> problem of temporary link congestion (it has no solution), it did remove
> a frequent, multi-minute pause.  Perhaps surprisingly, I have not heard
> of sessions being dropped, which could be expected to occur as a
> consequence of the substantially reduced retransmit times.  This might
> be luck, and sessions aren't dropping; or it might be insufficiently
> important (annoying) for my client to report; the application would
> restart quickly.  Either way, apparently my client no longer has a problem.
> 

A real VPN with IPSEC would have stopped the problem.
I wouldn't put a mission critical system exposed directly to the Internet.

> I acknowledge that this patch must exacerbate an already hopeless
> situation: A link is congested and I am causing packets to be sent at
> five second intervals instead of 10, 20, 40, 80 or 120.  I am
> unconcerned by this because the number of additional packets is
> miniscule when compared to the number of packets that caused the problem
> in the initial instance.  I do not know how 120 seconds was chosen for
> the RTO maximum but I observe that network bandwidth has increased by
> orders of magnitude since it was, and feel that a corresponding decrease
> in RTO is fair.  I put it to administrators everywhere to consider this
> when faced with similar problems.
> 
> It's a pity that Obata Noboru's patch was rejected.

Linux already doesn't follow enough RFC's. But it is free software so
you can do what you want. That is the beauty of it.
