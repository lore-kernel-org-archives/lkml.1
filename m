Return-Path: <linux-kernel-owner+w=401wt.eu-S1754327AbXGSJJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327AbXGSJJ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 05:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754389AbXGSJJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:09:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58879 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515AbXGSJJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:09:42 -0400
Date: Thu, 19 Jul 2007 11:09:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Olaf Kirch <olaf.kirch@ORACLE.COM>
Cc: Jarek Poplawski <jarkao2@o2.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Message-ID: <20070719090930.GA27765@elte.hu>
References: <20070716091236.GA10718@elte.hu> <200707181404.20458.olaf.kirch@oracle.com> <20070718124856.GB31215@elte.hu> <200707181641.45338.olaf.kirch@oracle.com> <20070718164341.GA6327@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070718164341.GA6327@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


i have your original patch applied to my working tree to be able to 
observe this bug's behavior, and here's another observation: the problem 
seems to go away if i turn on CONFIG_NO_HZ. So it looks timing related 
indeed ...

but when the bug happens, it happens all the time, reboot after reboot. 
When it doesnt happen, networking and netlogging is robust for hours, 
reboot after reboot. That seems atypical for timing problems. I'm 
puzzled.

the e1000 in this laptop is historically pretty robust. The only problem 
i ever had with it were some rx/tx hw-engine latency problems [pings 
from the outside took up to 1 second to propagate] that were quickly 
fixed by the e1000 driver guys. Maybe that's related. (although it never 
caused total inavailability of networking - it was only latency 
problems)

	Ingo
