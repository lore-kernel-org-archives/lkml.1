Return-Path: <linux-kernel-owner+w=401wt.eu-S1758175AbXEISSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175AbXEISSQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 14:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757109AbXEISR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 14:17:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50521 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756652AbXEISR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 14:17:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ego@in.ibm.com, Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [patch 128/197] freezer: add try_to_freeze calls to all kernel threads
Date: Wed, 9 May 2007 20:18:15 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, James.Bottomley@steeleye.com,
       aneesh.kumar@gmail.com, drzeus@drzeus.cx, dwmw2@infradead.org,
       greg@kroah.com, mingo@elte.hu, neilb@suse.de, oleg@tv-sign.ru,
       paulmck@linux.vnet.ibm.com, vatsa@in.ibm.com,
       linux-kernel@vger.kernel.org
References: <200705090934.l499YTvX019783@shell0.pdx.osdl.net> <4641CAAF.8060103@s5r6.in-berlin.de> <20070509152913.GA16090@in.ibm.com>
In-Reply-To: <20070509152913.GA16090@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705092018.17116.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 9 May 2007 17:29, Gautham R Shenoy wrote:
> On Wed, May 09, 2007 at 03:20:47PM +0200, Stefan Richter wrote:
> > Gautham R Shenoy wrote:
> > > freezer_exempt() as of now does what its name says. I.e, exempt the
> > > thread from all kinds of freeze chills.
> > > 
> > > But with more subsystems using the process freezer, the exemption needs
> > > to be event specific. There may be threads which should not be frozen 
> > > for say kprobes, should be frozen for cpu-hotplug. This selective
> > > freezing is not yet available. But it will be soon...
> > 
> > Thanks for the (necessary!) clarification.
> > Let me point out that the usual process would be to replace
> > 
> > 	freezer_exempt(current);
> > 	for (;;) {
> > 		...;
> > by
> > 	freezer_exempt_for_io(current);
> > 	for (;;) {
> > 		try_to_freeze();
> > 		...;
> > 
> > when or after freezer_exempt_for_io was implemented.
> >
> 
> Well, a couple of RFC's have already been sent with this regard.
> Most of these recent freezer changes resulted due to the discussions
> that took place over  these RFC's.
> 
> This was the first attempt
> http://lkml.org/lkml/2007/2/14/106
> 
> and a more recent one
> http://lkml.org/lkml/2007/4/2/33
> 
> > But as it was submitted now, we are temporarily left with
> > 
> > 	freezer_exempt(current);
> > 	for (;;) {
> > 		try_to_freeze();  /* useless irritating no-op */
> > 		...;
> > 
> > without any benefit.  (And this explanatory comment ^^^ wasn't even
> > added; we only have the git log as explanation.)

I feel I ought to explain why it's ended up in this state.

This is not a new patch.  It's been in -mm since 2.6.21-rc2-mm1 (at least)
and we hoped to have the selective freezing of the system for different events
done before the 2.6.22 merging window would open.  It didn't happen, mainly
for reasons that we couldn't control, and now we have some patches that
depend on this one and are more urgent, since they're needed to fix some bugs.

> > As subsystem maintainer I have to trust now that "soon" actually means
> > "soon" and not "RSN"; otherwise my responsibility would be to send a NAK.
> 
> Soon actually does mean soon :-) 
> 
> http://lkml.org/lkml/2007/4/27/616 was sent out recently. 
> I am working on the Rafael's suggestions. 
> The only thing holding these patches back is the fact that 
> quite an amount of patches on the freezer/kthread front has gone in 
> recently, which need more review and testing. 
> 
> Will keep you posted on the freezer developments from now on.

Me too.

Greetings,
Rafael
