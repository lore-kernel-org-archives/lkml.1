Return-Path: <linux-kernel-owner+w=401wt.eu-S1754493AbYFOU5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbYFOU5w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 16:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbYFOU5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 16:57:41 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:44309 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752070AbYFOU5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 16:57:40 -0400
Message-ID: <4855823F.40208@davidnewall.com>
Date: Mon, 16 Jun 2008 06:27:35 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: OBATA Noboru <noboru.obata.ar@hitachi.com>,
       "David S. Miller" <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-net@vger.kernel.org
Subject: Feedback on TCP: Make TCP_RTO_MAX a variable
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last year, Obata Noboru sent a patch to permit adjustment of
TCP_RTO_MAX, which I have found useful.  Refer to
http://marc.info/?l=linux-netdev&m=118422471428855 for details.

A customer reported that their internet-connected POS terminals were
regularly "freezing" for extended periods, sometimes for as long as a
few minutes.  My analysis, such as it was, suggested that those
occasions were caused by floods of packets directed towards the internet
link at one end or the other (i.e. POS terminal or central server),
leading to severe packet loss and maximum packet retransmit times during
which no session data could be transmitted.  I believe those floods were
caused by anonymous third parties scanning the internet, and attempting
to break through my client's routers.  I also believe that to be an
unavoidable social quality of the internet; I have to live with it.

Having a "cash register" randomly freeze for minutes at a time is not
acceptable, and neither does it seem necessary.  Using Obata Noboru's
patch, I set TCP_RTO_MAX to 5 seconds at both ends.  The system has been
running thus for five weeks, and I have not been called by my customer
since.  While this change obviously did nothing to solve the underlying
problem of temporary link congestion (it has no solution), it did remove
a frequent, multi-minute pause.  Perhaps surprisingly, I have not heard
of sessions being dropped, which could be expected to occur as a
consequence of the substantially reduced retransmit times.  This might
be luck, and sessions aren't dropping; or it might be insufficiently
important (annoying) for my client to report; the application would
restart quickly.  Either way, apparently my client no longer has a problem.

I acknowledge that this patch must exacerbate an already hopeless
situation: A link is congested and I am causing packets to be sent at
five second intervals instead of 10, 20, 40, 80 or 120.  I am
unconcerned by this because the number of additional packets is
miniscule when compared to the number of packets that caused the problem
in the initial instance.  I do not know how 120 seconds was chosen for
the RTO maximum but I observe that network bandwidth has increased by
orders of magnitude since it was, and feel that a corresponding decrease
in RTO is fair.  I put it to administrators everywhere to consider this
when faced with similar problems.

It's a pity that Obata Noboru's patch was rejected.

Thank you, Noboru.
