Return-Path: <linux-kernel-owner+w=401wt.eu-S1755576AbZDUNvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbZDUNvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 09:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753617AbZDUNvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 09:51:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49898 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbZDUNvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 09:51:38 -0400
Date: Tue, 21 Apr 2009 15:50:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: David VomLehn <dvomlehn@cisco.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Wait for console to become available, v3.2
Message-ID: <20090421135034.GA30114@elte.hu>
References: <20090420234006.GA1958@cuplxvomd02.corp.sa.net> <20090421064346.GB8020@elte.hu> <20090421063549.3b71881d@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090421063549.3b71881d@infradead.org>
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> On Tue, 21 Apr 2009 08:43:46 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > The proper approach would be to use one of the async_synchronize*() 
> > facilities in kernel/async.c to properly order the opening of the 
> > console with device init.
> 
> Unfortunately this is not the answer.
> 
> First of all, USB does not use the async_* infrastructure, so it does
> not do anything.

[ Of course it does not. Two kernel cycles ago nothing had any async 
  infrastructure ;-) We barely have any use of it today. But cases 
  like this are the way to extend its use. ]

> But more importantly... USB *CANNOT* do this fundamental 
> operation. USB does not have the capability to know when you have 
> seen all devices that are connected. Devices just show up a random 
> amount of time after you turn the power on for the bus.... there's 
> no "and now we've seen all" operation.

Yes - and this is fundamentally true of any hotplug bus design.

Nevertheless the wish has been expressed to wait for such a device 
to become available, in this very thread we are discussing.

What i'm saying is: instead of "wait 2000 msecs, maybe it works out" 
hack, there should be a proper sleep+event based approach to the 
same. With perhaps a _timeout_ for the "no console arrived" negative 
case as well. (which timeout can be set to zero in the "I _know_ 
there's no console around".)

Do you see the fundamental design difference between the two 
solutions?

	Ingo
