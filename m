Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab0BUKVq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 05:21:46 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:49749 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755014Ab0BUKVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 05:21:44 -0500
Date: Sun, 21 Feb 2010 11:21:03 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andreas Petlund <apetlund@simula.no>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       Ilpo J?rvinen <ilpo.jarvinen@helsinki.fi>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Arnd Hannemann <hannemann@nets.rwth-aachen.de>,
       LKML <linux-kernel@vger.kernel.org>, shemminger@vyatta.com,
       David Miller <davem@davemloft.net>, william.allen.simpson@gmail.com,
       damian@tvk.rwth-aachen.de, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [net-next PATCH v4 1/3] net: TCP thin-stream detection
Message-ID: <20100221102102.GB1311@ucw.cz>
References: <4B7AAE60.3070305@simula.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B7AAE60.3070305@simula.no>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> +After analysing a large number of time-dependent interactive
> +applications, we have seen that they often produce thin streams
> +and also stay with this traffic pattern throughout its entire
> +lifespan. The combination of time-dependency and the fact that the
> +streams provoke high latencies when using TCP is unfortunate.
> +
> +In order to reduce application-layer latency when packets are lost,
> +a set of mechanisms has been made, which address these latency issues
> +for thin streams. In short, if the kernel detects a thin stream,
> +the retransmission mechanisms are modified in the following manner:
> +
> +1) If the stream is thin, fast retransmit on the first dupACK.
> +2) If the stream is thin, do not apply exponential backoff.

2) seems very dangerous/unfair. If network  congestion is caused just
by thin streams, will the network just fall apart?


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
