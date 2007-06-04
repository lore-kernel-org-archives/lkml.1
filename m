Return-Path: <linux-kernel-owner+w=401wt.eu-S1761832AbXFDT0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761832AbXFDT0g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 15:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759132AbXFDT00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 15:26:26 -0400
Received: from www.osadl.org ([213.239.205.134]:55554 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758829AbXFDT0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 15:26:24 -0400
Subject: Re: iperf: performance regression (was b44 driver problem?)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Ulrich Drepper <drepper@gmail.com>,
       Maximilian Engelhardt <maxi@daemonizer.de>,
       Michael Buesch <mb@bu3sch.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Jeff Garzik <jgarzik@pobox.com>, Gary Zambrano <zambrano@broadcom.com>,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1180983647.4404.38.camel@chaos>
References: <20070525172431.60affaca@freepuppy>
	 <200705281944.05030.maxi@daemonizer.de> <1180380230.3657.3.camel@chaos>
	 <200706031826.06891.maxi@daemonizer.de> <1180939188.4404.5.camel@chaos>
	 <20070604090918.42386fbb@freepuppy> <1180974958.4404.24.camel@chaos>
	 <20070604095924.651d91c8@freepuppy> <1180978368.4404.29.camel@chaos>
	 <20070604105158.31ede1f5@freepuppy>  <1180983647.4404.38.camel@chaos>
Content-Type: text/plain
Date: Mon, 04 Jun 2007 21:26:18 +0200
Message-Id: <1180985178.4404.48.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-04 at 21:00 +0200, Thomas Gleixner wrote:
> > 
> > Yes, the following patch makes iperf work better than ever.
> > But are other broken applications going to have same problem.
> > Sounds like the old "who runs first" fork() problems.
> 
> Not really. The fork() "who runs first" problem is nowhere specified.
> 
> usleep(0) is well defined:
> 
> .... If the value of useconds is 0, then the call has no effect.
> 
> So the call into the kernel has been wrong for quite a time.
> 

Just for clarification: I'm not saying that we should break the (broken)
user space ABI. I'm going to work out a patch which prints out a warning
(limited number per boot) and emulating the old behavior by a call to
yield() along with an entry into (mis)feature-removal.txt.

	tglx


