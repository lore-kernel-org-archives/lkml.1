Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab0BUWg5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 17:36:57 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:56672 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab0BUWgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 17:36:55 -0500
Date: Mon, 22 Feb 2010 00:36:54 +0200 (EET)
From: "=?ISO-8859-15?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@melkinpaasi.cs.helsinki.fi
To: Alexander Zimmermann <zimmermann@nets.rwth-aachen.de>
cc: Pavel Machek <pavel@ucw.cz>, Andreas Petlund <apetlund@simula.no>,
       lars.eggert@nokia.com, Netdev <netdev@vger.kernel.org>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Arnd Hannemann <Arnd.Hannemann@nets.rwth-aachen.de>,
       LKML <linux-kernel@vger.kernel.org>, shemminger@vyatta.com,
       David Miller <davem@davemloft.net>, william.allen.simpson@gmail.com,
       Lukowski Damian <damian@tvk.rwth-aachen.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [net-next PATCH v4 1/3] net: TCP thin-stream detection
In-Reply-To: <D40945A6-301D-485D-BB8C-826D2EB68DA4@nets.rwth-aachen.de>
Message-ID: <alpine.DEB.2.00.1002220033360.23201@melkinpaasi.cs.helsinki.fi>
References: <4B7AAE60.3070305@simula.no> <20100221102102.GB1311@ucw.cz> <D40945A6-301D-485D-BB8C-826D2EB68DA4@nets.rwth-aachen.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Feb 2010, Alexander Zimmermann wrote:

> 
> Am 21.02.2010 um 11:21 schrieb Pavel Machek:
> 
> > Hi!
> > 
> >> +After analysing a large number of time-dependent interactive
> >> +applications, we have seen that they often produce thin streams
> >> +and also stay with this traffic pattern throughout its entire
> >> +lifespan. The combination of time-dependency and the fact that the
> >> +streams provoke high latencies when using TCP is unfortunate.
> >> +
> >> +In order to reduce application-layer latency when packets are lost,
> >> +a set of mechanisms has been made, which address these latency issues
> >> +for thin streams. In short, if the kernel detects a thin stream,
> >> +the retransmission mechanisms are modified in the following manner:
> >> +
> >> +1) If the stream is thin, fast retransmit on the first dupACK.
> >> +2) If the stream is thin, do not apply exponential backoff.
> > 
> > 2) seems very dangerous/unfair. If network  congestion is caused just
> > by thin streams, will the network just fall apart?
> 
> and 1) can also be dangerous if we have reordering on the path.
> 
> I strongly suggest that we discuss Andreas' idea on IETF TCPM *before*
> we integrate it in the kernel and enable it for everyone

What difference you see with 1) and early rexmit when cwnd = 2, the latter 
being afaict "discussed already" on TCPM?

-- 
 i.
