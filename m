Return-Path: <linux-kernel-owner+w=401wt.eu-S1757674AbZGHWOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674AbZGHWOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 18:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755183AbZGHWOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 18:14:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49074 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191AbZGHWOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 18:14:33 -0400
Subject: Re: [patch] perf_counter: Add p6 PMU
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vince@deater.net>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1247089529.16156.27.camel@laptop>
References: <Pine.LNX.4.64.0907071559200.30742@pianoman.cluster.toy>
	 <1247051751.9777.49.camel@twins>
	 <Pine.LNX.4.64.0907081718450.2715@pianoman.cluster.toy>
	 <1247089529.16156.27.camel@laptop>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 09 Jul 2009 00:14:24 +0200
Message-Id: <1247091264.9777.311.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-08 at 23:45 +0200, Peter Zijlstra wrote:
> On Wed, 2009-07-08 at 17:46 -0400, Vince Weaver wrote:
> > On Wed, 8 Jul 2009, Peter Zijlstra wrote:
> > 
> > >   doesn't sound like the right kind of event.. but then, it doesn't
> > >   have anything better either.
> > 
> > Is there a way to specify "invalid event"?  Just setting it to 0 doesn't 
> > work, on the Pentium Pro event 0 returns what looks like essentially
> > random numbers.
> 
> Hmm, bugger. I was assuming writing 0 to the evensel would disable the
> counter. Apparently that only works for eventsel1, which would mean we
> cannot run counter1 without counter0. That means we'd need to do a
> counter swap at times... :/

Ooh, we can instead use a counter that's specified to not count anything
for 'disabling' the counter, like event 0x2E with unit mask 0.


