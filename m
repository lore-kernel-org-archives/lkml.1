Return-Path: <linux-kernel-owner+w=401wt.eu-S1755329AbZG2PyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbZG2PyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 11:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbZG2PyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 11:54:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34585 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753926AbZG2Px7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 11:53:59 -0400
Subject: Re: GFS2: Add LED support to GFS2
From: Steven Whitehouse <swhiteho@redhat.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org, rpurdie@rpsys.net
In-Reply-To: <20090729150844.GJ1534@ucw.cz>
References: <1248260198.3456.4.camel@localhost.localdomain>
	 <20090729150844.GJ1534@ucw.cz>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
 3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
 Street, Windsor, Berkshire, SL4 ITE
Date: Wed, 29 Jul 2009 16:52:12 +0100
Message-Id: <1248882732.3298.142.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2009-07-29 at 17:08 +0200, Pavel Machek wrote:
> On Wed 2009-07-22 11:56:38, Steven Whitehouse wrote:
> > >From e1fac35b9c2af276473db50fae581ef56626240c Mon Sep 17 00:00:00 2001
> > From: Steven Whitehouse <swhiteho@redhat.com>
> > Date: Wed, 22 Jul 2009 11:40:16 +0100
> > Subject: [PATCH] GFS2: Add LED support to GFS2
> > 
> > This adds a standalone module which uses the GFS2 tracepoints
> > as a hook to provide LED trigger events. Events can be sent
> > when glocks change state, when glock demote requests are
> > received (both local and remote events are included) and also
> > when the log is flushed.
> > 
> > The log flush event lights the LED during the duration of the
> > log flush event. The other two triggers light the LED for 1/10th
> > second after the event has occurred.
> > 
> > I've tested this by using GFS2 in "nolock" mode on my laptop
> > by getting it to flash the thinkpad battery LED on the various
> > events and verified that it occurs when expected.
> 
> This looks way too specialized to me. Yes, it will be pretty,
> but... there's about 100000 possible triggers. Where do we draw a
> line? Or do we merge all of them?
> 								Pavel

There might be a lot of possible triggers, but that doesn't mean there
are actually a lot of actual triggers. Surely what makes the LED
subsystem useful is that is can show a wide variety of events?

If there is an issue, then it seems to me, its the way in which we
enumerate the events, not that there are "too many" per se. If you have
a rack of machines in a data center it might be very useful to be able
to instantly check the visual status of an important parameter using the
LEDs. Likewise it would be similarly useful if someone was to use GFS2
in an embedded environment where LEDs are often the sum total of the
user interface.

Whether or not it is merged ought to be down to whether it affects
anything else (which is doesn't as it is self-contained) whether the
code is maintainable, and whether it makes sense as a feature I think.

Steve.


