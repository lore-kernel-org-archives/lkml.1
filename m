Return-Path: <linux-kernel-owner+w=401wt.eu-S1755965AbYEZOA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbYEZOA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 10:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbYEZOAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 10:00:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44438 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbYEZOAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 10:00:13 -0400
Date: Mon, 26 May 2008 15:59:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [bug] stuck localhost TCP connections, v2.6.26-rc3+
Message-ID: <20080526135940.GB24870@elte.hu>
References: <20080526115628.GA31316@elte.hu> <Pine.LNX.4.64.0805261550340.16829@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0805261550340.16829@wrl-59.cs.helsinki.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ilpo Järvinen <ilpo.jarvinen@helsinki.fi> wrote:

> > in terms of debugging there's not much i can do i'm afraid. It's not 
> > possible to get a tcpdump of this incident, given the extreme amount 
> > of load these testboxes handle.
> 
> ...but you can still tcpdump that particular flow once the situation 
> is discovered to see if TCP still tries to do something, no? One needs 
> to tcpdump couple of minutes at minimum. Also please get /proc/net/tcp 
> for that flow around the same time.

ok, will try those.

> > One clue (which might or might not matter) is that distcc is one of 
> > the very few applications that makes use of sendfile().
> 
> Can you please try with /proc/sys/net/ipv4/tcp_frto set to zero though 
> recv-q symptom seems weird would it be related to that (but there were 
> some recent fixes to FRTO and retrans_stamp change could have some 
> significance here)?
> 
> Other than that, nothing since -rc1 seems suspicious to me (though I 
> hardly understand every part of networking).

ok, i will first wait for it to trigger on a box and will do the tcpdump 
session (and /proc/net/tcp output), then i'll continue the tests with 
this done in the rc.local:

  echo 0 > /proc/sys/net/ipv4/tcp_frto

and will see whether the hung connections still occur. The cycle of 
testing will be very slow i suspect.

	Ingo
