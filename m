Return-Path: <linux-kernel-owner+w=401wt.eu-S1759341AbYHZR7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759341AbYHZR7L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 13:59:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757678AbYHZR65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 13:58:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59469 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752309AbYHZR64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 13:58:56 -0400
Date: Tue, 26 Aug 2008 10:58:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org, alex.williamson@hp.com,
       Will Newton <will.newton@gmail.com>
Subject: Re: [PATCH] serial 8250: tighten test for using backup timer
Message-Id: <20080826105845.6ddf1107.akpm@linux-foundation.org>
In-Reply-To: <200808261045.34699.david-b@pacbell.net>
References: <200808261045.34699.david-b@pacbell.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2008 10:45:34 -0700
David Brownell <david-b@pacbell.net> wrote:

> > > Also, how serious is the problem which is being fixed here?  It
> > > _sounds_ like it's of the "fatal for people who have that hardware"
> > > variety, in which case we should get this into 2.6.27 and probably
> > > 2.6.26.x.  Not sure about 2.5.26.x though - the patch doesn't apply
> > > there, but I didn't check whether this is due to functional changes.
> >
> > For users of this version of this particular UART IP it is fatal. From
> > looking at the git history it looks like the original patch went into
> > 2.6.26 so it might also affect that kernel.
> 
> Second that:  serial-8250-tighten-test-for-using-backup-timer.patch
> (from MMOTM) in mainline sooner-not-later seems right.

ok, if you think so...

I still have an unanswered question out there about the init_timer()
handling in that area of the driver but afaict this patch didn't make any
of it worse than it already is.

> My own exposure to this is that the UART on DaVinci hardware, which
> TI allegedly derived from its original 16550 logic, has periodically
> gone from working to unusable with the mainline 8250.c ... and back
> and forth a bunch.  Currently it's "unusable", a regression from some
> previous versions.  With this patch from Alex, it's usable.
> 
> Of course there are a bunch of arch/arm/mach-davinci patches needed
> to make that platform more functional in mainline.  I expect they'll
> probably merge in the 2.6.28-rc0 window.  Meanwhile, running out of
> ramdisk with a serial console should at least work right!  :)
> 

