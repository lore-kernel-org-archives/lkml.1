Return-Path: <linux-kernel-owner+w=401wt.eu-S1756028Ab0AMQgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab0AMQgL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 11:36:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756009Ab0AMQgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 11:36:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42328 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755974Ab0AMQgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 11:36:09 -0500
Date: Wed, 13 Jan 2010 17:35:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Don Zickus <dzickus@redhat.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
       aris@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: introduce NMI_AUTO as nmi_watchdog option
Message-ID: <20100113163551.GA10643@elte.hu>
References: <20100111191633.GT24885@redhat.com>
 <20100111202729.GI4923@lenovo>
 <20100111203356.GU24885@redhat.com>
 <20100113093240.GC6739@elte.hu>
 <1263388422.4244.214.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263388422.4244.214.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2010-01-13 at 10:32 +0100, Ingo Molnar wrote:
> > other architectures have NMI concepts as well, such as Sparc64. 
> 
> I think both sparc64 and ppc64 fake NMIs by playing games with hw IRQ 
> priorities and partial masks. But yes.
> 
> One interesting 'feature' for the perf-nmi interaction is creating an idle 
> scheduling class for counters, because as long as there is a counter present 
> you can use his NMIs to drive the watchdog, but as soon as there are non 
> left, you need to install one.

Yeah. I'd suggest to not complicate things with that initially - but to simply 
create a standalone event for it and 'waste' a counter on NMI generation. 

Later on it can indeed be a good feature to make the NMI watchdog 'seemless' 
in the sense of it not causing any wasted hw resources - it can piggyback on 
any existing NMI event. (as long as that event is at least ~1 HZ strong or so)

	Ingo
