Return-Path: <linux-kernel-owner+w=401wt.eu-S1755169AbYEZUmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbYEZUmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 16:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbYEZUmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 16:42:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35234 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859AbYEZUmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 16:42:04 -0400
Date: Mon, 26 May 2008 22:41:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ilpo J?rvinen <ilpo.jarvinen@helsinki.fi>
Cc: LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [bug] stuck localhost TCP connections, v2.6.26-rc3+
Message-ID: <20080526204140.GA13186@elte.hu>
References: <20080526115628.GA31316@elte.hu> <Pine.LNX.4.64.0805261550340.16829@wrl-59.cs.helsinki.fi> <20080526135940.GB24870@elte.hu> <20080526141252.GA31352@elte.hu> <Pine.LNX.4.64.0805261745010.16829@wrl-59.cs.helsinki.fi> <20080526162328.GA9089@elte.hu> <Pine.LNX.4.64.0805261926260.24924@wrl-59.cs.helsinki.fi> <20080526165407.GB24098@elte.hu> <Pine.LNX.4.64.0805261956090.24924@wrl-59.cs.helsinki.fi> <20080526181216.GA12400@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080526181216.GA12400@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > It's well possible that e.g., net namespaces have some bug in 
> > handling of orphaned tcp.
> 
> yes, that would match the symptoms i think. I half-assumed that it's a 
> state machine problem so i didnt even check what the reader does - and 
> in this case it appears to not exist at all anymore ;-)

after ~7 hours of uptime the networking code produced this assertion:

 [25441.140000] KERNEL: assertion (!sk->sk_ack_backlog) failed at 
 net/ipv4/inet_connection_sock.c (642)

no further information in the logs. I kept the failing system booted up 
for 8 hours and will reboot it now.

	Ingo
