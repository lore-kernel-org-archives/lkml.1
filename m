Return-Path: <linux-kernel-owner+w=401wt.eu-S1762394AbYBAX3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762394AbYBAX3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 18:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761631AbYBAX3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 18:29:03 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33292 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761588AbYBAX3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 18:29:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
Subject: Re: [Regression] 2.6.24-git3: Major annoyance during suspend/hibernation on x86-64 (bisected)
Date: Sat, 2 Feb 2008 00:26:53 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Ingo Molnar" <mingo@elte.hu>, "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Steven Rostedt" <srostedt@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200801272229.48955.rjw@sisk.pl> <20080201224852.GA16700@elte.hu> <b647ffbd0802011522y3d4d779ambaf1a21f368ef74a@mail.gmail.com>
In-Reply-To: <b647ffbd0802011522y3d4d779ambaf1a21f368ef74a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802020026.55427.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 2 of February 2008, Dmitry Adamushko wrote:
> On 01/02/2008, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:
> >
> > > > I've observed delays from ~3 s. up to ~8 s. (out of ~20 tests) so
> > > > the 10s. delay of msleep_interruptible() might be related but I'm
> > > > still looking for the reason why this fix helps (and what goes wrong
> > > > with the current code).
> > >
> > > heh... it's pretty obvious indeed. What's msleep_interruptible() is
> > > all about? :-)
> > >
> > > "sleep waiting for signals"
> > >
> > > so the 'watchdog' thread gets woken up
> > >
> > > [ as a result of cpu_callback(action = CPU_DEAD) --> kthread_stop() ]
> > >
> > > just to be immediately scheduled out again for as long as the
> > > remaining timeout > 0.
> > >
> > > So it should work if we substitute msleep_interruptible() with
> > > schedule_timeout_interruptible().
> >
> > Doh. Could someone with ths problem please test the patch below, does it
> > do the trick?
> 
> yeah, I was already on a half-way to check it out.
> 
> It does fix a problem for me.
> 
> Don't forget to take along these 2 fixes from Peter's patch:
> 
> - fix break usage in do_each_thread() { } while_each_thread().
> - fix the hotplug switch stmt, a fall-through case was broken.
> 
> 
> Rafael, does your system still hangs? I'd expect, yes -- as
> effectively this fix is not that different from Peter's one when it
> comes to suspend-case.

I haven't tested it yet, but I don't expect it to hang, as the Peter's patch
started to work for me.  I'm going to test it in a while.

Thanks,
Rafael
