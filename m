Return-Path: <linux-kernel-owner+w=401wt.eu-S1752717AbZJMFUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbZJMFUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 01:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbZJMFUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 01:20:17 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:23414 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbZJMFUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 01:20:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RqHoz4Y91JGRCYJgMT+aDo5csr0XSf70wZ1ApeuoFMzhxas/fdFWGQenFtO4LvL1Sf
         3fTfxkPr9fKDMRVqfebeT0peCuYZO9YLzBGdpDtuBqvNwFFZeWLCMzlK43SKI5qQRb2q
         2mLrTMGRNFh43L2P1nGBwCJk99Eh3gixK3SPg=
Date: Mon, 12 Oct 2009 22:19:03 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Marin Mitov <mitov@issp.bas.bg>
Cc: Vojtech Pavlik <vojtech@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: Regression?: keyboard state/LED inconsistency in
	2.6.32-rc1/2,3,4
Message-ID: <20091013051903.GE2887@core.coreip.homeip.net>
References: <200910121118.29415.mitov@issp.bas.bg> <20091012085708.GA7403@core.coreip.homeip.net> <20091013030314.GA2887@core.coreip.homeip.net> <200910130755.43510.mitov@issp.bas.bg> <20091013051738.GD2887@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091013051738.GD2887@core.coreip.homeip.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 10:17:38PM -0700, Dmitry Torokhov wrote:
> On Tue, Oct 13, 2009 at 07:55:43AM +0300, Marin Mitov wrote:
> > On Tuesday 13 October 2009 06:03:14 am Dmitry Torokhov wrote:
> > > On Mon, Oct 12, 2009 at 01:57:08AM -0700, Dmitry Torokhov wrote:
> > > > On Mon, Oct 12, 2009 at 10:30:15AM +0200, Vojtech Pavlik wrote:
> > > > > On Mon, Oct 12, 2009 at 11:18:28AM +0300, Marin Mitov wrote:
> > > > > > Hello,
> > > > > > 
> > > > > > I'm testing 2.6.32-rc1/2,3,4 and I'm using 2.6.31.3.
> > > > > > There is a difference in keyboard/LED behavior.
> > > > > > If in BIOS NumLock is set on, when the kernel starts
> > > > > > it puts NumLock off and the LED state is off in 2.6.31.3
> > > > > > (which is consistent), but in 2.6.32-rc1/2,3,4 the LED
> > > > > > stays on (and this is not consistent with keyboard's state).
> > > > > > 
> > > > > > Comparing drivers/input/keyboard/atkbd.c (I'm using it)
> > > > > > in 2.6.31.3 and 2.6.32-rc1/2,3,4 among others changes I
> > > > > > found the following lines (see the patch bellow) deleted,
> > > > > > so I propose either to add them again (this will restore 
> > > > > > keyboard/LED consistency) or revert the patch that has 
> > > > > > deleted them.
> > > > > 
> > > > > Oh, wow, those lines are quite clearly needed, I wonder why they got
> > > > > deleted, and I'm too lazy to find the commit comment ...
> > > > > 
> > > > 
> > > > Hmm, it appears I deleted a bit too much.. At some point I was thinking
> > > > the input core would reset LEDs and repeat rate on newly created device
> > > > but it was wrong idea. Unfortunately I was careless in applying atkbd
> > > > patch removing resume support (which should be handled by the input
> > > > core)...
> > > > 
> > > 
> > > Could you please try the patch below and let me know if it fixes
> > > things?
> > > 
> > > Thanks!
> > > 
> > 
> > Yes, Dmitry, it fixes the problem, thank you.
> > 
> 
> Thank you for testing. Mouse re-initialization is pretty delicate topic,
> may I ask you to test some more just to make sure fix is reliable - a
> few more resumes and cold/warm boots would do...
> 

Oh, wait, scratch that... I mixed up the issues ;) Sorry about the
confusion.

-- 
Dmitry
