Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630Ab0BRUEG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 15:04:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50208 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341Ab0BRUEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 15:04:01 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Subject: Re: s2disk hang update
Date: Thu, 18 Feb 2010 21:04:49 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc8-rjw; KDE/4.3.5; x86_64; ; )
Cc: Mel Gorman <mel@csn.ul.ie>, hugh.dickins@tiscali.co.uk,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <9b2b86521001020703v23152d0cy3ba2c08df88c0a79@mail.gmail.com> <201002172058.04043.rjw@sisk.pl> <9b2b86521002180453l176a83dand809dc239c220c08@mail.gmail.com>
In-Reply-To: <9b2b86521002180453l176a83dand809dc239c220c08@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002182104.49631.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 February 2010, Alan Jenkins wrote:
> On 2/17/10, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Wednesday 17 February 2010, Alan Jenkins wrote:
> >> On 2/16/10, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> > On Tuesday 16 February 2010, Alan Jenkins wrote:
> >> >> On 2/16/10, Alan Jenkins <sourcejedi.lkml@googlemail.com> wrote:
> >> >> > On 2/15/10, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> >> >> On Tuesday 09 February 2010, Alan Jenkins wrote:
> >> >> >>> Perhaps I spoke too soon.  I see the same hang if I run too many
> >> >> >>> applications.  The first hibernation fails with "not enough swap"
> >> >> >>> as
> >> >> >>> expected, but the second or third attempt hangs (with the same
> >> >> >>> backtrace
> >> >> >>> as before).
> >> >> >>>
> >> >> >>> The patch definitely helps though.  Without the patch, I see a hang
> >> >> >>> the
> >> >> >>> first time I try to hibernate with too many applications running.
> >> >> >>
> >> >> >> Well, I have an idea.
> >> >> >>
> >> >> >> Can you try to apply the appended patch in addition and see if that
> >> >> >> helps?
> >> >> >>
> >> >> >> Rafael
> >> >> >
> >> >> > It doesn't seem to help.
> >> >>
> >> >> To be clear: It doesn't stop the hang when I hibernate with too many
> >> >> applications.
> >> >>
> >> >> It does stop the same hang in a different case though.
> >> >>
> >> >> 1. boot with init=/bin/bash
> >> >> 2. run s2disk
> >> >> 3. cancel the s2disk
> >> >> 4. repeat steps 2&3
> >> >>
> >> >> With the patch, I can run 10s of iterations, with no hang.
> >> >> Without the patch, it soon hangs, (in disable_nonboot_cpus(), as
> >> >> always).
> >> >>
> >> >> That's what happens on 2.6.33-rc7.  On 2.6.30, there is no problem.
> >> >> On 2.6.31 and 2.6.32 I don't get a hang, but dmesg shows an allocation
> >> >> failure after a couple of iterations ("kthreadd: page allocation
> >> >> failure. order:1, mode:0xd0").  It looks like it might be the same
> >> >> stop_machine thread allocation failure that causes the hang.
> >> >
> >> > Have you tested it alone or on top of the previous one?  If you've
> >> > tested it
> >> > alone, please apply the appended one in addition to it and retest.
> >> >
> >> > Rafael
> >>
> >> I did test with both patches applied together -
> >>
> >> 1. [Update] MM / PM: Force GFP_NOIO during suspend/hibernation and resume
> >> 2. "reducing the number of pages that we're going to keep preallocated by
> >> 20%"
> >
> > In that case you can try to reduce the number of preallocated pages even
> > more,
> > ie. change "/ 5" to "/ 2" (for example) in the second patch.
> 
> It still hangs if I try to hibernate a couple of times with too many
> applications.

Hmm.  I guess I asked that before, but is this a 32-bit or 64-bit system and
how much RAM is there in the box?

Rafael
