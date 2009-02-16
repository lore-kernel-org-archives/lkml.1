Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbZBPXIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbZBPXIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 18:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751018AbZBPXIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 18:08:41 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57953 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbZBPXIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 18:08:41 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Woodruff, Richard" <r-woodruff2@ti.com>
Subject: Re: [RFD] Automatic suspend
Date: Tue, 17 Feb 2009 00:08:27 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Arjan van de Ven <arjan@infradead.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
References: <f73f7ab80902161208h12837d4ex1d28d55d031d5d71@mail.gmail.com> <20090216135204.064f553b@infradead.org> <13B9B4C6EF24D648824FF11BE896716203771DD01B@dlee02.ent.ti.com>
In-Reply-To: <13B9B4C6EF24D648824FF11BE896716203771DD01B@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902170008.31054.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 February 2009, Woodruff, Richard wrote:
> 
> > From: Arjan van de Ven [mailto:arjan@infradead.org]
> > Sent: Monday, February 16, 2009 3:52 PM
> > On Mon, 16 Feb 2009 15:32:06 -0600
> > "Woodruff, Richard" <r-woodruff2@ti.com> wrote:
> > >
> > > - It provides a way to handle overdrive/turbo operating points out of
> > > band from the generically tuned cpufreq governors like ondemand.  The
> > > way we characterize overdrive is stricter then what Intel has talked
> > > about for x86.
> >
> > if you have an improved-for-your-systems governor then I'm sure that is
> > very welcome in the kernel.
> 
> No, the generic governors were not substantially improved. Not every customer is using cpufreq for DVFS. As such we went underneath it. If we had more community presence at the start time we might have also tried that.
> 
> > I think just about all of us agree that the final decision needs to be
> > in the driver (possibly followed by something that gets various device
> > requests and combines it into hw settings); we're just talking about
> > what inputs feed into that decision ;)
> >
> > And for different types of devices that's guaranteed to be different...
> > and sometimes we'll be hampered by existing interfaces, so we might end
> > up with hacky stuff.
> 
> Is there some kind of roadmap which can be plotted which goes from course to more granular control?
> 
> Phase 1 (all or nothing): like wakelocks (minus back light):
> system-auto-suspend-on, system-auto-suspend-off.  The drivers can still veto
> as they do today.
> 
> Phase 2: Subsystem generic tunable, on say latency + bandwidth. Start with
> CPU then move to classes like USB.
> 
> Phase 3: ??? if needed add direct device control, hints on an extended
> fadvise(), and explicit control left to open/close and direct ioctls?
> 
> I don't know that 1,2,3 above even make sense.

I'd like to talk about this. 

Phase 1: I agree that system-auto-suspend-on, system-auto-suspend-off would be
useful, but I don't like the wakelocks interface.  Do you think there is an
alternative way/mechanism of doing this?

Phase 2: I'm not sure.  We may want to introduce such things for various
subsystems in parallel (eg. USB already has such things).

Phase 3: Probably explicit control left to open/close.

> However, the notion of actually plotting out a course with goals does as it
> will take a long time and it is good to get some benefit along the way.

Agreed.

Thanks,
Rafael
