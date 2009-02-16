Return-Path: <linux-kernel-owner+w=401wt.eu-S1755516AbZBPXUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbZBPXUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 18:20:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbZBPXUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 18:20:25 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58015 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbZBPXUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 18:20:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFD] Automatic suspend
Date: Tue, 17 Feb 2009 00:19:38 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: "Woodruff, Richard" <r-woodruff2@ti.com>,
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
References: <f73f7ab80902161208h12837d4ex1d28d55d031d5d71@mail.gmail.com> <13B9B4C6EF24D648824FF11BE896716203771DD01B@dlee02.ent.ti.com> <20090216145948.6fea81c3@infradead.org>
In-Reply-To: <20090216145948.6fea81c3@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902170019.40599.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 February 2009, Arjan van de Ven wrote:
> On Mon, 16 Feb 2009 16:36:43 -0600
> "Woodruff, Richard" <r-woodruff2@ti.com> wrote:
> 
> > 
> > > From: Arjan van de Ven [mailto:arjan@infradead.org]
> > > Sent: Monday, February 16, 2009 3:52 PM
> > > On Mon, 16 Feb 2009 15:32:06 -0600
> > > "Woodruff, Richard" <r-woodruff2@ti.com> wrote:
> > > >
> > > > - It provides a way to handle overdrive/turbo operating points
> > > > out of band from the generically tuned cpufreq governors like
> > > > ondemand.  The way we characterize overdrive is stricter then
> > > > what Intel has talked about for x86.
> > >
> > > if you have an improved-for-your-systems governor then I'm sure
> > > that is very welcome in the kernel.
> > 
> > No, the generic governors were not substantially improved. Not every
> > customer is using cpufreq for DVFS. As such we went underneath it. If
> > we had more community presence at the start time we might have also
> > tried that.
> > 
> > > I think just about all of us agree that the final decision needs to
> > > be in the driver (possibly followed by something that gets various
> > > device requests and combines it into hw settings); we're just
> > > talking about what inputs feed into that decision ;)
> > >
> > > And for different types of devices that's guaranteed to be
> > > different... and sometimes we'll be hampered by existing
> > > interfaces, so we might end up with hacky stuff.
> > 
> > Is there some kind of roadmap which can be plotted which goes from
> > course to more granular control?
> > 
> > Phase 1 (all or nothing): like wakelocks (minus back light):
> > system-auto-suspend-on, system-auto-suspend-off.  The drivers can
> > still veto as they do today.
> > 
> > Phase 2: Subsystem generic tunable, on say latency + bandwidth. Start
> > with CPU then move to classes like USB.
> 
> I think your phases are the wrong way around.
> Phase 2 is already in progress and many of the "good" drivers and
> subsystems already do them.
> 
> 
> Whole system suspend is a much more drastic thing; I don't see that
> happen generically in 2009 to be honest (not to mention how fragile
> linux suspend is).

This applies to x86/ACPI mostly, IMO.  Embedded platforms appear to be much
more controllable and tend to work better w/ system-wide sleep states.

> In addition, in hardware there does seem to be the trend where idle and
> suspend are converging (just look at the OLPC)...   with chipsets powering
> down all unused pieces, and cpus in idle taking basically no power, there
> no longer is much of a difference in reality between suspend and good-idle...

This, again, seems to be a bit x86-centric. :-)  The Android people are telling
us that on the hardware they deal with it does make sense to put the entire
system to sleep even for relatively short periods of time, since the latencies
involved are not too bad.

While I agree that on a PC it would probably make more sense to go towards
fine-grained run-time power management, maybe even without using system-wide
suspend at all (I don't see this happen any time soon, though), I'm not sure
about the other platforms.

Thanks,
Rafael
