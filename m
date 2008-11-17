Return-Path: <linux-kernel-owner+w=401wt.eu-S1754646AbYKQRjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbYKQRjo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 12:39:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752497AbYKQRjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 12:39:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753499AbYKQRjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 12:39:32 -0500
Date: Mon, 17 Nov 2008 12:39:10 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, rml@tech9.net, Alasdair G Kergon <agk@redhat.com>,
       Milan Broz <mbroz@redhat.com>
Subject: Re: Active waiting with yield()
In-Reply-To: <1226789714.8172.0.camel@lappy.programming.kicks-ass.net>
Message-ID: <Pine.LNX.4.64.0811171228500.4019@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0811141327100.22830@hs20-bc2-1.build.redhat.com>
  <20081114190616.30dd273e@lxorguk.ukuu.org.uk> 
 <Pine.LNX.4.64.0811141412290.12992@hs20-bc2-1.build.redhat.com> 
 <1226696221.7685.8148.camel@twins>  <Pine.LNX.4.64.0811141630590.6783@hs20-bc2-1.build.redhat.com>
 <1226789714.8172.0.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Nov 2008, Peter Zijlstra wrote:

> On Fri, 2008-11-14 at 16:41 -0500, Mikulas Patocka wrote:
> 
> > So, use msleep(1) instead of yield() ?
> 
> wait_event() of course!

Why? Why developes don't like active waiting when terminating a driver?
Is there any real workload when 1ms delay on driver unload would be 
problematic? Or don't they like it because of coding style?

L1 cache miss --- 10ns --- on every request, when using wait queues
msleep latency --- 1ms --- on driver termination, when using msleep
--- so if the driver processes more than 100000 requests between reboots, 
wait queues actually slow things down.

Mikulas
