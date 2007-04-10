Return-Path: <linux-kernel-owner+w=401wt.eu-S965028AbXDJMEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965028AbXDJMEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 08:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965042AbXDJMEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 08:04:55 -0400
Received: from mail.gmx.net ([213.165.64.20]:44212 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S965028AbXDJMEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 08:04:54 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19dYh8Ukz9domHHgkBa0XIkeLkf2Oap9JVWG9Wgrw
	DkRs3YqqEUqYp9
Subject: Re: Ten percent test
From: Mike Galbraith <efault@gmx.de>
To: Ed Tomlinson <edt@aei.ca>
Cc: LKML <linux-kernel@vger.kernel.org>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       ck list <ck@vds.kolivas.org>
In-Reply-To: <200704100723.33414.edt@aei.ca>
References: <200703290237.38777.kernel@kolivas.org>
	 <1176097101.6355.89.camel@Homer.simpson.net>
	 <1176172745.6943.58.camel@Homer.simpson.net>
	 <200704100723.33414.edt@aei.ca>
Content-Type: text/plain
Date: Tue, 10 Apr 2007 14:04:49 +0200
Message-Id: <1176206689.8878.9.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-10 at 07:23 -0400, Ed Tomlinson wrote:
> On Monday 09 April 2007 22:39, Mike Galbraith wrote:
> > On Mon, 2007-04-09 at 07:38 +0200, Mike Galbraith wrote:
> > 
> > > I don't think you can have very much effect on latency using nice with
> > > SD once the CPU is fully utilized.  See below.
> > > 
> > > /*
> > >  * This contains a bitmap for each dynamic priority level with empty slots
> > >  * for the valid priorities each different nice level can have. It allows
> > >  * us to stagger the slots where differing priorities run in a way that
> > >  * keeps latency differences between different nice levels at a minimum.
> > >  * ie, where 0 means a slot for that priority, priority running from left to
> > >  * right:
> > >  * nice -20 0000000000000000000000000000000000000000
> > >  * nice -10 1001000100100010001001000100010010001000
> > >  * nice   0 0101010101010101010101010101010101010101
> > >  * nice   5 1101011010110101101011010110101101011011
> > >  * nice  10 0110111011011101110110111011101101110111
> > >  * nice  15 0111110111111011111101111101111110111111
> > >  * nice  19 1111111111111111111011111111111111111111
> > >  */
> > > 
> > > Nice allocates bandwidth, but as long as the CPU is busy, tasks always
> > > proceed downward in priority until they hit the expired array.  That's
> > > the design.
> > 
> > There's another aspect of this that may require some thought - kernel
> > threads.  As load increases, so does rotation length.  Would you really
> > want CPU hogs routinely preempting house-keepers under load?
> 
> SD has a schedule batch nice level.  This is good for tasks that want lots
> of cpu when they can get it.  If you overload your cpu I expect the box
> to slow down - including kernel threads.  If really required they can be
> started with a higher priority...

Sure.  Anything that is latency sensitive, and those kernel threads that
are necessary for system function can be made RT to bypass the designed
in latency.  It's just another thing that should be considered before
integration.  Now if burst loads (only one of which it the desktop)
would just cease to exist...

	-Mike

