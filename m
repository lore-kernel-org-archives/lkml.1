Return-Path: <linux-kernel-owner+w=401wt.eu-S1757930AbYGOXaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930AbYGOXaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 19:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754123AbYGOXaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 19:30:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53836 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753772AbYGOXaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 19:30:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Avuton Olrich" <avuton@gmail.com>
Subject: Re: s2disk: system powers up again after power off
Date: Wed, 16 Jul 2008 01:32:38 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Martin Michlmayr" <tbm@cyrius.com>, linux-kernel@vger.kernel.org
References: <20080715124733.GA4111@deprecation.cyrius.com> <200807160059.54886.rjw@sisk.pl> <3aa654a40807151609m70d6852ex7f85d60c438bb4d7@mail.gmail.com>
In-Reply-To: <3aa654a40807151609m70d6852ex7f85d60c438bb4d7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807160132.38814.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 16 of July 2008, Avuton Olrich wrote:
> On Tue, Jul 15, 2008 at 3:59 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Wednesday, 16 of July 2008, Avuton Olrich wrote:
> >> On Tue, Jul 15, 2008 at 1:24 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> > On Tuesday, 15 of July 2008, Avuton Olrich wrote:
> >> >> On Tue, Jul 15, 2008 at 5:47 AM, Martin Michlmayr <tbm@cyrius.com> wrote:
> >> >> > When I use s2disk to suspend my HP 2510p notebook, it writes
> >> >> > everything to disk, and powers off... but after 2-3 seconds it often
> >> >> > powers on again.  This doesn't happen all the time but quite
> >> >> > frequently (definitely in the majority of cases).
> >> >> >
> >> >> > I believe I've never seen this when I use "halt" to power off the
> >> >> > machine (but I don't use halt very often).
> >> >> >
> >> >> > Any idea?
> >> >>
> >> >> Ugh, this happens here too, this started occuring before 2.6.25 but
> >> >> every time I try to bisect it takes hours and I end up screwing up
> >> >> somewhere along the way, so I haven't had time to bisect this
> >> >> correctly.
> >> >
> >> > Please try to put "shutdown method = shutdown" into the s2disk's configuration
> >> > file and see what happens in that case.
> >>
> >> Anything a little less fancy? I use pm-hibernate, or gnome's Power
> >> Manager to hibernate; I don't even have s2disk installed, sorry I
> >> should have mentioned that.
> >
> > Martin mentioned s2disk in his original post.  Never mind.
> >
> > Please try to do "echo shutdown > /sys/power/disk" before hibernation and
> > see what happens.
> 
> Well, that certainly works (powers off as expected). Should I be
> putting this in my startup scripts or is there something I need to do
> to help fix this problem, kernel-wise?

The problem is probably that in the "platform" mode, which is the default,
some devices are set up for wake-up and they trigger that immediately after
powering off.  I think we can figure out which devices do it and try to provide
a fix, but that will certainly take time.

In the meantime, if there are no adverse effects of using the "shutdown" mode
on your box, I'd recommend putting the "echo ..." into startup or hibernation
scripts.

BTW, is the problem also present in linux-next?

Thanks,
Rafael
