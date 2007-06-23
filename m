Return-Path: <linux-kernel-owner+w=401wt.eu-S1752032AbXFWBU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbXFWBU7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 21:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750815AbXFWBUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 21:20:51 -0400
Received: from rwcrmhc13.comcast.net ([216.148.227.153]:45475 "EHLO
	rwcrmhc13.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbXFWBUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 21:20:50 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Jun 2007 21:20:50 EDT
Subject: Re: Fix signalfd interaction with thread-private signals
From: Nicholas Miell <nmiell@comcast.net>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706221710150.3880@alien.or.mcafeemobile.com>
References: <20070620111415.GA91@tv-sign.ru>
	 <alpine.LFD.0.98.0706201035030.3593@woody.linux-foundation.org>
	 <20070621082509.GA88@tv-sign.ru>
	 <alpine.LFD.0.98.0706211100200.3593@woody.linux-foundation.org>
	 <20070621182340.GA92@tv-sign.ru>
	 <alpine.LFD.0.98.0706211133350.3593@woody.linux-foundation.org>
	 <20070621185856.GA153@tv-sign.ru>
	 <1182468604.24740.22.camel@localhost.localdomain>
	 <20070622084034.GA134@tv-sign.ru>
	 <1182512473.24740.54.camel@localhost.localdomain>
	 <20070622160405.GA189@tv-sign.ru>
	 <1182551618.24740.79.camel@localhost.localdomain>
	 <alpine.LFD.0.98.0706221540430.3593@woody.linux-foundation.org>
	 <1182554190.24740.84.camel@localhost.localdomain>
	 <1182554371.24740.87.camel@localhost.localdomain>
	 <1182555727.2735.3.camel@entropy>
	 <Pine.LNX.4.64.0706221710150.3880@alien.or.mcafeemobile.com>
Content-Type: text/plain
Date: Fri, 22 Jun 2007 18:15:47 -0700
Message-Id: <1182561347.2735.14.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.0.njm.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-22 at 17:12 -0700, Davide Libenzi wrote:
> On Fri, 22 Jun 2007, Nicholas Miell wrote:
> 
> > You could just get rid of the process/sighand/whatever reference
> > entirely and just make reads on a signalfd always dequeue signals for
> > the current thread.
> 
> Duh?! ...
> 
> > You'd lose the ability to pass signalfds around to other processes, but
> > I'm not convinced that is even useful. (But I'm sure somebody smarter
> > than me has a valid use case and would love to share :-)
> 
> Wasn't it you that bitched (just a few days ago) because multiple threads 
> could not use the same signalfd and they (by your initial thought) had to 
> create one per thread?

Nevermind, I wasn't entirely clear on the reason why signalfd_ctx had a
tsk pointer. (I wrongly thought it was a vestige of the mechanism for
the original delivery semantics.)

-- 
Nicholas Miell <nmiell@comcast.net>

