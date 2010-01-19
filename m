Return-Path: <linux-kernel-owner+w=401wt.eu-S1754608Ab0ASDUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab0ASDUk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 22:20:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754248Ab0ASDUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 22:20:39 -0500
Received: from gate.crashing.org ([63.228.1.57]:35351 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710Ab0ASDUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 22:20:39 -0500
Subject: Re: [RFC][PATCH] PM: Force GFP_NOIO during suspend/resume (was:
 Re: [linux-pm] Memory allocations in .suspend became very unreliable)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20100119101101.5F2E.A69D9226@jp.fujitsu.com>
References: <20100118110324.AE30.A69D9226@jp.fujitsu.com>
	 <201001182155.09727.rjw@sisk.pl>
	 <20100119101101.5F2E.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jan 2010 14:19:54 +1100
Message-ID: <1263871194.724.520.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-19 at 10:19 +0900, KOSAKI Motohiro wrote:
> I think the race happen itself is bad. memory and I/O subsystem can't solve such race
> elegantly. These doesn't know enough suspend state knowlege. I think the practical 
> solution is that higher level design prevent the race happen.
> 
> 
> > My patch attempts to avoid these two problems as well as the problem with
> > drivers using GFP_KERNEL allocations during suspend which I admit might be
> > solved by reworking the drivers.
> 
> Agreed. In this case, only drivers change can solve the issue. 

As I explained earlier, this is near to impossible since the allocations
are too often burried deep down the call stack or simply because the
driver doesn't know that we started suspending -another- driver...

I don't think trying to solve those problems at the driver level is
realistic to be honest. This is one of those things where we really just
need to make allocators 'just work' from a driver perspective.

It can't be perfect of course, as mentioned earlier, there will be a
problem if too little free memory is really available due to lots of
dirty pages around, but most of this can be somewhat alleviated in
practice, for example by pushing things out a bit at suspend time,
making some more memory free etc... But yeah, nothing replaces proper
error handling in drivers for allocation failures even with
GFP_KERNEL :-)

Cheers,
Ben.






