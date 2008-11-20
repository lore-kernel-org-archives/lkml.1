Return-Path: <linux-kernel-owner+w=401wt.eu-S1753149AbYKTJSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbYKTJSz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 04:18:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753455AbYKTJSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 04:18:39 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305AbYKTJSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 04:18:37 -0500
Date: Thu, 20 Nov 2008 04:18:17 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, rml@tech9.net, Alasdair G Kergon <agk@redhat.com>,
       Milan Broz <mbroz@redhat.com>
Subject: Re: Active waiting with yield()
In-Reply-To: <20081118212652.46d36da5@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.64.0811200414100.17455@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0811141327100.22830@hs20-bc2-1.build.redhat.com>
 <20081114190616.30dd273e@lxorguk.ukuu.org.uk>
 <Pine.LNX.4.64.0811141412290.12992@hs20-bc2-1.build.redhat.com>
 <1226696221.7685.8148.camel@twins> <Pine.LNX.4.64.0811141630590.6783@hs20-bc2-1.build.redhat.com>
 <1226789714.8172.0.camel@lappy.programming.kicks-ass.net>
 <Pine.LNX.4.64.0811171228500.4019@hs20-bc2-1.build.redhat.com>
 <20081117180149.7a48d2e9@lxorguk.ukuu.org.uk>
 <Pine.LNX.4.64.0811180921450.12274@hs20-bc2-1.build.redhat.com>
 <20081118144053.0072d54c@lxorguk.ukuu.org.uk>
 <Pine.LNX.4.64.0811181157260.13418@hs20-bc2-1.build.redhat.com>
 <20081118212652.46d36da5@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 18 Nov 2008, Alan Cox wrote:

> > This makes a code branch that is very rarely tested and a potential bug. 
> > Every such rarely executed branch is a danger and even a silly typo in the 
> > code can hide there for many years without being noticed.
> 
> Learn to use a debugger. You want an unusual timing to occur you
> breakpoint the relevant task and suspend it for a bit.
> 
> > So, I say msleep(1) instead of yield(). What are the counterarguments to 
> > msleep?
> 
> msleep isn't particularly a problem. You are giving up the CPU and not
> wasting so much power and you won't deadlock in realtime. Assuming you
> only expect one or two msleep cycles its fine.

So msleep(1) should be OK. I can't think of a case when it could break.

> And if you think virtualisation and power management and correctness
> (as Ingo noted) are a "bad reason" you need to wake up to the real world.

If the involved cases are:
- a race condition that never happened to a user, only seen during 
artifical testing
- a race condition that existed for 5 years and just one user hit it

--- then yes, considering power management is a bad reason.

Mikulas

> Alan
> 
