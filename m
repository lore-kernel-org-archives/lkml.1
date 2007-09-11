Return-Path: <linux-kernel-owner+w=401wt.eu-S966395AbXIKHBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966395AbXIKHBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 03:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760904AbXIKHB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 03:01:26 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49355 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760959AbXIKHBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 03:01:25 -0400
Date: Tue, 11 Sep 2007 00:00:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: clockevents: fix resume logic
Message-Id: <20070911000001.30f8590b.akpm@linux-foundation.org>
In-Reply-To: <1189492636.25767.62.camel@chaos>
References: <200707220159.l6M1xBgH001236@hera.kernel.org>
	<20070910144740.4eba2fda.akpm@linux-foundation.org>
	<1189492636.25767.62.camel@chaos>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2007 08:37:16 +0200 Thomas Gleixner <tglx@linutronix.de> wrote:

> On Mon, 2007-09-10 at 14:47 -0700, Andrew Morton wrote:
> > > 
> > >     clockevents: fix resume logic
> > >     
> > >     We need to make sure, that the clockevent devices are resumed, before
> > >     the tick is resumed. The current resume logic does not guarantee this.
> > >     
> > >     Add CLOCK_EVT_MODE_RESUME and call the set mode functions of the clock
> > >     event devices before resuming the tick / oneshot functionality.
> > >     
> > >     Fixup the existing users.
> > >     
> > >     Thanks to Nigel Cunningham for tracking down a long standing thinko,
> > >     which affected the jinxed VAIO.
> > >     
> > 
> > This patch broke the jinxed vaio.
> > 
> > Which is a bit odd, considering that I must have tested it at the time. 
> > But I bisected it right down to this commit, and the below revert patch
> > fixed it up.
> 
> I just looked up, that you confirmed earlier that the patch does _not_
> break the VAIO. 
> 
> I think, that some other suspend/resume/ACPI or whatever change went in
> before this patch got merged into Linus tree. Sigh. That's pretty hard
> to find out.
> 

I tried just 18de5bc4c1f1f1fa5e14f354a7603bd6e9d4e3b6 on top of 2.6.22
(threw away the lguest and xen hunks).  The same problem occurs.  2.6.22 is
OK.

I went back to the original patch which I sent to Linus and it matches
18de5bc4c1f1f1fa5e14f354a7603bd6e9d4e3b6.  So all I can think is that there
must have been something else in the tree which I tested which fixed the
bug which 18de5bc4c1f1f1fa5e14f354a7603bd6e9d4e3b6 introduced.  argh.

Can you think what would cause the symptoms which I described?  
