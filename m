Return-Path: <linux-kernel-owner+w=401wt.eu-S1755352AbZDYIQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbZDYIQX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 04:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbZDYIQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 04:16:10 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42327 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbZDYIQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 04:16:08 -0400
Date: Thu, 23 Apr 2009 06:42:29 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Lameter <cl@linux.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: Scheduler regression: Too frequent timer interrupts(?)
Message-ID: <20090423044228.GA2428@ucw.cz>
References: <alpine.DEB.1.10.0904161539130.23632@qirst.com> <1239951613.23397.4107.camel@laptop> <alpine.DEB.1.10.0904170941020.11877@qirst.com> <1239977776.23397.4590.camel@laptop> <alpine.DEB.1.10.0904171021360.20239@qirst.com> <1239979901.23397.4638.camel@laptop> <alpine.DEB.1.10.0904171100510.21575@qirst.com> <1239982137.23397.4684.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239982137.23397.4684.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-04-17 17:28:57, Peter Zijlstra wrote:
> On Fri, 2009-04-17 at 11:04 -0400, Christoph Lameter wrote:
> > On Fri, 17 Apr 2009, Peter Zijlstra wrote:
> > 
> > > And a random 1us cutoff, is well, random.
> > 
> > Its got to be somewhere.
> 
> No it doesn't, a cutoff is useless. If I steal cputime at units below
> the cutoff I can, in the limit, steal up to 100% cpu time and you'd not
> notice.

Are you sure cutoff is useless?

Irq entry/exit is sure to take > 1usec, right?

> > > So 5 <1us interruption are not at all accounted, whereas a single 1>us
> > > interruption is. I'd rather get rid of those 5 than try and shave a bit
> > > of the one, if you get what I mean.
> > 
> > Ok. We can set the threshold lower and see how that goes.
> 
> Pointless. See above.

I'd say that taking interrupt and returning in below 1000nsec is
impossible, even on very fast hw.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
