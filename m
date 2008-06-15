Return-Path: <linux-kernel-owner+w=401wt.eu-S1757457AbYFOKVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457AbYFOKVA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 06:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757013AbYFOKUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 06:20:50 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:33839 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756945AbYFOKUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 06:20:50 -0400
Date: Sun, 15 Jun 2008 14:22:52 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jarek Poplawski <jarkao2@o2.pl>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] workqueues: implement flush_work()
Message-ID: <20080615102252.GB156@tv-sign.ru>
References: <20080613142801.GA9165@tv-sign.ru> <20080614091339.GA2466@ami.dom.local> <20080614135951.GA4502@tv-sign.ru> <20080614185107.GA2470@ami.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080614185107.GA2470@ami.dom.local>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14, Jarek Poplawski wrote:
>
> On Sat, Jun 14, 2008 at 05:59:51PM +0400, Oleg Nesterov wrote:
> > On 06/14, Jarek Poplawski wrote:
> ...
> > > Another question is if schedule_on_each_cpu() is really such a good
> > > example here: it seems these "xxx && yyy" examples could be faster,
> > > but I've lost track of this earlier thread.
> > 
> > schedule_on_each_cpu() can't use cancel_ + ->func(), the code should
> > be executed on the remote CPU.
> 
> ???
> Actually I meant this "xxx && yyy" schedule_on_each_cpu():
> 
> http://marc.info/?l=linux-kernel&m=121329259203187&w=2

Ah, sorry, I misunderstood.

Yes, "xxx && yyy" needs only 1 wakeup, so it needs less CPU. But it also
more complex, and it is not easy to generalize this.

Oleg.

