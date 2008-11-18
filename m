Return-Path: <linux-kernel-owner+w=401wt.eu-S1753330AbYKROel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330AbYKROel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 09:34:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbYKROed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 09:34:33 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147AbYKROed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 09:34:33 -0500
Date: Tue, 18 Nov 2008 09:34:16 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, rml@tech9.net, Alasdair G Kergon <agk@redhat.com>,
       Milan Broz <mbroz@redhat.com>
Subject: Re: Active waiting with yield()
In-Reply-To: <20081117180149.7a48d2e9@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.64.0811180921450.12274@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0811141327100.22830@hs20-bc2-1.build.redhat.com>
 <20081114190616.30dd273e@lxorguk.ukuu.org.uk>
 <Pine.LNX.4.64.0811141412290.12992@hs20-bc2-1.build.redhat.com>
 <1226696221.7685.8148.camel@twins> <Pine.LNX.4.64.0811141630590.6783@hs20-bc2-1.build.redhat.com>
 <1226789714.8172.0.camel@lappy.programming.kicks-ass.net>
 <Pine.LNX.4.64.0811171228500.4019@hs20-bc2-1.build.redhat.com>
 <20081117180149.7a48d2e9@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2008, Alan Cox wrote:

> > --- so if the driver processes more than 100000 requests between reboots, 
> > wait queues actually slow things down.
> 
> Versus power consumption and virtualisation considerations. Plus your
> numbers are wrong. You seem terribly keen to ignore the fact that the
> true cost is a predicted branch and usually a predicted branch of a
> cached variable and you'll only touch the wait queue in rare cases.

You will touch the wait queue always when finishing the last pending 
request --- just to find out that there is no one waiting on it.

And besides cache line, there is coding and testing overhead with wait 
queues. If the programmer forgets to decrement the number of pending 
requests, he finds it out pretty quickly (the driver won't unload). If he 
forgets to wake the queue up, the code can run with this bug long without 
anyone noticing it --- unless someone tries to unload the driver at a 
specific point --- I have seen this too.

> I'd also note as an aside modern drivers usually run off krefs so
> destruction and thus closedown is refcounted and comes off the last kref
> destruct.
> 
> Alan

So what are the reasons why you (and others) are against active waiting? 
All you are saying is that my reasons are wrong, but you haven't single 
example when active waiting causes trouble. If there is a workload when 
waiting 1ms-to-10ms with mdelay(1) on driver unload would cause discomfort 
to the user, describe it.

Mikulas
