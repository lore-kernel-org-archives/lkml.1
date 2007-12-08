Return-Path: <linux-kernel-owner+w=401wt.eu-S1753428AbXLHRhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbXLHRhr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 12:37:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbXLHRhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 12:37:39 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44885 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbXLHRhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 12:37:39 -0500
X-Greylist: delayed 1502 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Dec 2007 12:37:38 EST
Subject: Re: lockdep problem conversion semaphore->mutex (dev->sem)
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: Remy Bohmer <linux@bohmer.net>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Dave Chinner <dgc@sgi.com>
In-Reply-To: <1197133577.1568.166.camel@jnielson-xp.ddns.mvista.com>
References: <3efb10970712071502p4db9c58ck623c377172ead4b2@mail.gmail.com>
	 <1197116185.31440.1.camel@twins>
	 <1197132792.1568.162.camel@jnielson-xp.ddns.mvista.com>
	 <1197133910.6353.33.camel@lappy>
	 <1197133577.1568.166.camel@jnielson-xp.ddns.mvista.com>
Content-Type: text/plain
Date: Sat, 08 Dec 2007 18:36:53 +0100
Message-Id: <1197135413.6353.36.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-12-08 at 09:06 -0800, Daniel Walker wrote:
> On Sat, 2007-12-08 at 18:11 +0100, Peter Zijlstra wrote:
> 
> > > It must be the locking in __driver_attach(), taking dev->parent->sem
> > > then taking dev->sem .. Assuming those are different structures, why
> > > does lockdep trigger?
> > 
> > They aren't different, parent is a struct device again.
> 
> It's different memory tho .. I wasn't sure how to term that .. The locks
> are in two different memory location so it couldn't be recursive .. I'm
> only asking for my own understanding .. I don't mind inspecting
> potentially bad locking ..

Yeah, it are different lock instances, however by virtue of sharing the
same lock init site, they belong to the same lock class. Lockdep works
by tracking class dependancies, not instance dependancies.

By generalizing to classes it can detect locking errors before they
actually occur.


