Return-Path: <linux-kernel-owner+w=401wt.eu-S934112AbXGLNNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934112AbXGLNNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 09:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763840AbXGLNNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 09:13:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55207 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763205AbXGLNNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 09:13:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Al Boldi <a1426z@gawab.com>
Subject: Re: Hibernation Redesign
Date: Thu, 12 Jul 2007 15:20:49 +0200
User-Agent: KMail/1.9.5
Cc: Mark Lord <lkml@rtr.ca>, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Miklos Szeredi <miklos@szeredi.hu>, jeremy@goop.org, pavel@ucw.cz,
       nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <200707081737.21932.a1426z@gawab.com> <200707120034.14201.rjw@sisk.pl> <200707120212.24072.a1426z@gawab.com>
In-Reply-To: <200707120212.24072.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707121520.51250.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 12 July 2007 01:12, Al Boldi wrote:
> Rafael J. Wysocki wrote:
> > On Thursday, 12 July 2007 00:17, Al Boldi wrote:
> > > Mark Lord wrote:
> > > > Jeremy Maitin-Shepard wrote:
> > > > > I'll certainly admit the kexec idea is vaporware currently,
> > >
> > > Your idea is starting to become a reality with this thread:
> > > "[PATCH 0/2] Kexec jump: The first step to kexec base hibernation"
> > >
> > > > > but it does
> > > > > differ in a significant way from freezer-based approaches, such that
> > > > > I don't think it should be referred to as just another
> > > > > implementation of a freezer.  Specifically, it doesn't require that
> > > > > the "old kernel" be in a "consistent" state to a greater extent than
> > > > > suspend to ram; it is the case that all of the devices must be
> > > > > quiesced or shut down to some extent, but doing this without races
> > > > > and deadlocks (and without the freezer) is certainly very, very
> > > > > similar to what needs to be done for suspend to ram, which will need
> > > > > to be solved anyway.  Unlike the existing hibernate approaches,
> > > > > however, it will not be necessary to use any of the driver
> > > > > infrastructure once switched to the "save image" kernel, and thus it
> > > > > will not matter what locks are held, for instance.
> > > >
> > > > I really doubt that kexec(a special kernel) is going to solve anything
> > > > here. The new kernel will have to initialize, probe for devices, etc.
> > > > Which will take time.
> > > > Which will slow down hibernate to an unacceptable degree.
> > > > Right now, it (TuxOnIce) is *very* fast.
> > > > Adding 10 seconds or so for reprobing/resetting/reiniting devices
> > > > is not going to be useful.
> > > > And modifying all of the drivers to *not* do their usual probe
> > > > sequence sounds rather intrusive and is likely also a non-starter
> > > > here.
> > > >
> > > > Or is it?
> > >
> > > Well, it's definitely less intrusive than readying drivers for the
> > > freezer.
> >
> > There's nothing like this!
> 
> Are you sure?
> 
> # grep -i freeze drivers/*/* | wc -l
> 
> gives:  297
> 
> Maybe you can clarify?

Yes, I can.  For example, please have a look at 'struct ata_port_operations'. :-)

The only direct relationship between the freezer and drivers is that some of
them use kernel threads that call try_to_freeze() (and other freezer-related
functions).

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
