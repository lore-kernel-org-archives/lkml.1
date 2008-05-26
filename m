Return-Path: <linux-kernel-owner+w=401wt.eu-S1755728AbYEZQYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728AbYEZQYK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 12:24:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbYEZQXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 12:23:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51366 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753712AbYEZQXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 12:23:52 -0400
Date: Mon, 26 May 2008 18:23:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [bug] stuck localhost TCP connections, v2.6.26-rc3+
Message-ID: <20080526162328.GA9089@elte.hu>
References: <20080526115628.GA31316@elte.hu> <Pine.LNX.4.64.0805261550340.16829@wrl-59.cs.helsinki.fi> <20080526135940.GB24870@elte.hu> <20080526141252.GA31352@elte.hu> <Pine.LNX.4.64.0805261745010.16829@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0805261745010.16829@wrl-59.cs.helsinki.fi>
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

> On Mon, 26 May 2008, Ingo Molnar wrote:
> 
> > there's a hung distcc task on the system, waiting for socket action 
> > forever:
> > 
> >   [root@europe ~]# strace -fp 19578
> >   Process 19578 attached - interrupt to quit
> >   select(5, NULL, [4], [4], {82, 90000} <unfinished ...>
> 
> Hmm, readfds is NULL isn't it?!? Are you sure you straced the right 
> process?

yes, i'm stracing the task that is hung unexpectedly.

> > disturbing that task via strace did not change the state of the 
> > socket - and that's not unexpected as it's a select(). [TCP state 
> > might be affected if strace impacted a recvmsg or a sendmsg wait 
> > directly.]
> 
> I fail to understand this paragraph due to excessive negation... :-)

i mean, sometimes a TCP connection can get 'unstuck' if you strace a 
task - that is because the TCP related syscall the task sits in gets 
interrupted. But in this case it's select() which doesnt explicitly take 
the socket, doesnt do any tcp_push_pending_frames() processing, etc. - 
it just its on the socket waitqueue AFAICS. And that's expected.

	Ingo
