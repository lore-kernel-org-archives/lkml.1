Return-Path: <linux-kernel-owner+w=401wt.eu-S1755916AbYGNFnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbYGNFnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 01:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbYGNFnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 01:43:15 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51625 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbYGNFnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 01:43:15 -0400
Date: Mon, 14 Jul 2008 07:43:52 +0200
From: Pavel Machek <pavel@suse.cz>
To: David Fries <david@fries.net>
Cc: Michael Tokarev <mjt@tls.msk.ru>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: hibernate/suspend-to-disk: to turn power or not?
Message-ID: <20080714054351.GB20258@elf.ucw.cz>
References: <47A0CD90.5080208@msgid.tls.msk.ru> <200801302211.10622.rjw@sisk.pl> <47A10886.5050707@msgid.tls.msk.ru> <20080131144030.GC983@elf.ucw.cz> <20080713232636.GA1916@spacedout.fries.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080713232636.GA1916@spacedout.fries.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-07-13 18:26:36, David Fries wrote:
> On Thu, Jan 31, 2008 at 03:40:30PM +0100, Pavel Machek wrote:
> > > Back to the original question and a proposed solution.
> > > 
> > > I'm looking at the uswsusp source (while the kernel compiles),
> > > and have a question here.  Is it possible to call some external
> > > application (typically a shell script) to do the final work after
> > > when the image has been written?  I mean in principle - I
> > > understand there are some limitations here, but I don't know
> > > which exactly.
> > 
> > No, you can't exec() anything. That would write mtime back to disk and
> > cause badness.
> 
> SysRq-U remounts the disks readonly.  Why not make the disks readonly
> once the kernel state is in swap, why not let any program run and give
> an error to writes?

IIRC sysrq-U does not contain all the locking that's neccessary to
make it completely safe. OTOH, it tends to work...

> I know, long dead thread, but I too would like to tell the UPS to turn
> off once the system state is resting safely in swap.  Currently my
> modified apcupsd scripts tell the UPS to turn off, then tells the
> kernel to hibernate, and hopes the kernel finishes in time.  I would
> much rather do things the other way, but `echo disk > /sys/power/disk`
> doesn't return until power is back on if everything goes well.

If you use s2disk, you can execute C code at the point you want...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
