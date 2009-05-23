Return-Path: <linux-kernel-owner+w=401wt.eu-S1753509AbZEWNHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbZEWNHH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 09:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbZEWNG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 09:06:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:35067 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbZEWNG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 09:06:57 -0400
Subject: Re: [PATCH 2/2] perf_counter: optimize context switch between
 identical inherited contexts
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20090523123828.GA13878@elte.hu>
References: <18966.10075.781053.231153@cargo.ozlabs.ibm.com>
	 <18966.10666.517218.332164@cargo.ozlabs.ibm.com>
	 <1242980169.26820.617.camel@twins>
	 <18966.30400.611789.434936@cargo.ozlabs.ibm.com>
	 <1242986897.26820.638.camel@twins>  <20090523123828.GA13878@elte.hu>
Content-Type: text/plain
Date: Sat, 23 May 2009 15:06:52 +0200
Message-Id: <1243084012.6582.1200.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-05-23 at 14:38 +0200, Ingo Molnar wrote:
> > I'm for all counters you created (ie have a fd for). Being able to 
> > disable counters others created on you just sounds wrong.
> > 
> > If we can settle on a semantic, I'm sure we can implement it :-)
> > 
> > Ingo, Corey, any opinions?
> 
> It indeed doesnt sound correct that we can disable counters others 
> created on us - especially if they are in a different (higher 
> privileged) security context than us.
> 
> OTOH, enabling/disabling counters in specific functions of a library 
> might be a valid use-case. So perhaps make this an attribute: 
> ..transparent or so, with perf stat defaulting on it to be 
> transparent (i.e. not child context disable-able).

I'm not sure that's something we want to do. Furthermore, if we do want
it, the current implementation is not sufficient, because, as Paul
noted, we can attach a new counter right after the disable.

I really think such limitations should come from whatever security
policy there is on attaching counters. Eg. using selinux, label gnupg as
non-countable so that you simply cannot attach (incl inherit) counters
to it.

Allowing such hooks into libraries will destroy transparency for
developers and I don't think that's something we'd want to promote.

I'll implement my suggestion so we can take it from there.

