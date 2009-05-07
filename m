Return-Path: <linux-kernel-owner+w=401wt.eu-S1763305AbZEGUwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763305AbZEGUwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 16:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbZEGUwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 16:52:15 -0400
Received: from mail.crca.org.au ([67.207.131.56]:40427 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154AbZEGUwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 16:52:14 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [RFC][PATCH 4/5] PM/Hibernate: Rework shrinking of memory
From: Nigel Cunningham <nigel@tuxonice.net>
Reply-To: nigel@tuxonice.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
In-Reply-To: <200905072200.30777.rjw@sisk.pl>
References: <200905070040.08561.rjw@sisk.pl>
	 <1241652436.19600.176.camel@nigel-laptop> <200905071418.05035.rjw@sisk.pl>
	 <200905072200.30777.rjw@sisk.pl>
Content-Type: text/plain
Date: Fri, 08 May 2009 06:53:14 +1000
Message-Id: <1241729594.19600.219.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Thu, 2009-05-07 at 22:00 +0200, Rafael J. Wysocki wrote:
> On Thursday 07 May 2009, Rafael J. Wysocki wrote:
> > On Thursday 07 May 2009, Nigel Cunningham wrote:
> > > Hi.
> > 
> > Hi,
> > 
> > > On Thu, 2009-05-07 at 00:44 +0200, Rafael J. Wysocki wrote:
> > > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > > 
> > > > Rework swsusp_shrink_memory() so that it calls shrink_all_memory()
> > > > just once to make some room for the image and then allocates memory
> > > > to apply more pressure to the memory management subsystem, if
> > > > necessary.
> > > > 
> > > > Unfortunately, we don't seem to be able to drop shrink_all_memory()
> > > > entirely just yet, because that would lead to huge performance
> > > > regressions in some test cases.
> > > 
> > > I know it doesn't fit with your current way of doing things, but have
> > > you considered trying larger order allocations as a means of getting
> > > memory freed?
> > 
> > Actually, I was thinking about that.  What's your experience with this
> > approach?
> > 
> > > I have code in tuxonice_prepare_image.c (look for extra_pages_allocated) that
> > > might be helpful for this purpose.
> > 
> > OK, thanks.  I'll have a look at it.
> 
> I have tried it, but the results are even worse than with 0-order allocations
> only.
> 
> So far, I have got the best results with shrink_all_memory() called once and
> followed by allocating as much memory as we want to be free using 0-order
> allocations.  Like in this patch. :-)

Hmm. That's surprising. It would be interesting to look at what's going
on. Unfortunately, I just don't have the time at the moment to help.

Regards,

Nigel

