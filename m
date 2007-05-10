Return-Path: <linux-kernel-owner+w=401wt.eu-S1762465AbXEJVz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762465AbXEJVz7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 17:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755932AbXEJVzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 17:55:50 -0400
Received: from www.osadl.org ([213.239.205.134]:43351 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755657AbXEJVzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 17:55:49 -0400
Subject: Re: [BUG] local_softirq_pending storm
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Anant Nitya <kernel@prachanda.info>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <d95aa510705100453y666cf310ic9ee4dc609f099f1@mail.gmail.com>
References: <200705091942.22920.kernel@prachanda.hub>
	 <1178728280.3042.504.camel@localhost.localdomain>
	 <d95aa510705100453y666cf310ic9ee4dc609f099f1@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 10 May 2007 23:58:46 +0200
Message-Id: <1178834326.22481.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-10 at 17:23 +0530, Anant Nitya wrote:
> On 5/9/07, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Wed, 2007-05-09 at 19:42 +0530, Anant Nitya wrote:
> > > Hi,
> > > Ever since I upgrade to 2.6.21/.1, system log is filled with following
> > > messages if I enable CONFIG_NO_HZ=y, going through archives it seems ingo
> > > sometime back posted some patch and now it is upstream, but its not helping
> > > here. If I disable NOHZ by kernel command line nohz=off this problem
> > > disappears. This system is P4/2.40GHz/HT with SMP/SMT on in kernel config.
> > > One more thing that I noticed is this problem only arises while using X or
> > > network otherwise plain command line with no network access don't trigger
> > > this with nohz=on.
> >
> > Is this independent of the load on the system ? i.e. : What happens if
> > you only use the console and run a kernel compile with -j4 ?
> Yep, it seems independent of load on the system, to test I compiled
> kernel with make -j8 and to throw some more load same time I also used
> amavisd to clean around 2000 of spam/virus infected mails and same
> time was listening to few radio stream over net in console only login
> mode. Even then there was not a single NOHZ: local_softirq_pending
> message in log. Once kernel got compiled and amavisd finished its job
> and load drops back to around 0.5/2.0 I started X and within few secs
> log starts getting filled with local_softirq_pending messages, (sorry,
> I didn't applied ratelimit patch since I wanted to test is it high
> load on system that causes this or something else). It seems even
> network operation is not causing this. It seems either X is doing
> something terribly wrong or kernel is getting hosed by X.
> If some more information is needed please feel free to ask

Ok, that's consistent with earlier reports. The problem surfaces when
one of the SMT-"cpus" goes idle. The problem goes away when you disable
hyperthreading.

When you apply the ratelimit patch, does the softlockup problem
persist ?

	tglx


