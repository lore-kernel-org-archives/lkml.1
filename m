Return-Path: <linux-kernel-owner+w=401wt.eu-S934482AbXGQS45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934482AbXGQS45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 14:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758379AbXGQS4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 14:56:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45262 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754404AbXGQS4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 14:56:48 -0400
Date: Tue, 17 Jul 2007 20:56:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Olaf Kirch <olaf.kirch@oracle.com>
Cc: Jarek Poplawski <jarkao2@o2.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Message-ID: <20070717185602.GA25271@elte.hu>
References: <20070716091236.GA10718@elte.hu> <200707172006.11664.olaf.kirch@oracle.com> <20070717181857.GA16918@elte.hu> <200707172034.20581.olaf.kirch@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707172034.20581.olaf.kirch@oracle.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Olaf Kirch <olaf.kirch@oracle.com> wrote:

> On Tuesday 17 July 2007 20:18, Ingo Molnar wrote:
> > (one is HZ=100, the other HZ=1000. HZ=100 produces a hung network just 
> > like HZ=250.)
> > 
> > no 'rx_sched set' messages in either case. Network still hung for 
> > HZ=100, and is working for HZ=1000.
> 
> Is this from dmesg or the netconsole output? I don't see any Tx Unit 
> Hang messages from e1000 or netdev watchdog messages present in your 
> earlier dmesg logs. So maybe these messages are there, but never get 
> logged?

i logged these not via netconsole but via logging on over the console 
and using dmesg, so it should include everything. in the 100hz case the 
following seems to show the anomaly:

  NETDEV WATCHDOG: eth0: transmit timed out

indeed it's not followed by the e1000 messages. (perhaps i didnt wait 
long enough to reboot the box - i zapped it after a minute of uptime)

	Ingo
