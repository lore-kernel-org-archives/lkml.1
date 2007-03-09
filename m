Return-Path: <linux-kernel-owner+w=401wt.eu-S2993140AbXCIVOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993140AbXCIVOf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 16:14:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993137AbXCIVOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 16:14:35 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3422 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965819AbXCIVOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 16:14:34 -0500
Date: Fri, 9 Mar 2007 21:13:31 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Johnson <ajohnson@intrinsyc.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Software Suspend: Fix suspend when console is in VT_AUTO/KD_GRAPHICS mode
Message-ID: <20070309211330.GC6374@ucw.cz>
References: <1173394485.28589.17.camel@localhost.localdomain> <20070309090805.GA5822@atrey.karlin.mff.cuni.cz> <20070309153456.GA28664@srcf.ucam.org> <DBC923D919FAB345973A94E6E194E849043808E0@yvrmail01.itc.intrinsyc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DBC923D919FAB345973A94E6E194E849043808E0@yvrmail01.itc.intrinsyc.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > So... if current console is graphical, we leave X accessing the
> > > console... That's bad, because video state is not going to be
> > > restored...?
> > 
> > A graphical console is not necessarily X. Is there any requirement for
> > there to be a single VT that isn't in text mode? The vt switching is
> > a hack, we shouldn't make life difficult for people who have their own
> > userspace code that's entirely capable of restoring video state on its
> > own.
> 
> The problem actually comes about when using Qtopia Phone Edition (QPE)
> on a PXA270. QPE puts the console into VT_AUTO+KD_GRAPHICS mode and
> writes directly to the framebuffer from then on.  In this mode the
> kernel correctly disallows a console change, as QPE is not getting
> notification of a console change and thus does not know when to repaint
> the screen. 

Fix qpe to use vt_process, instead?

...how does qpe know when to repaint the screen, anyway?

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
