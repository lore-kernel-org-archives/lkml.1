Return-Path: <linux-kernel-owner+w=401wt.eu-S1755504AbYGMXnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504AbYGMXnV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 19:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754378AbYGMXnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 19:43:14 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:51296 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338AbYGMXnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 19:43:13 -0400
X-Greylist: delayed 826 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Jul 2008 19:43:13 EDT
Date: Sun, 13 Jul 2008 18:26:36 -0500
From: David Fries <david@fries.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: Michael Tokarev <mjt@tls.msk.ru>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: hibernate/suspend-to-disk: to turn power or not?
Message-ID: <20080713232636.GA1916@spacedout.fries.net>
References: <47A0CD90.5080208@msgid.tls.msk.ru> <200801302211.10622.rjw@sisk.pl> <47A10886.5050707@msgid.tls.msk.ru> <20080131144030.GC983@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080131144030.GC983@elf.ucw.cz>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Sun, 13 Jul 2008 18:26:42 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 03:40:30PM +0100, Pavel Machek wrote:
> > Back to the original question and a proposed solution.
> > 
> > I'm looking at the uswsusp source (while the kernel compiles),
> > and have a question here.  Is it possible to call some external
> > application (typically a shell script) to do the final work after
> > when the image has been written?  I mean in principle - I
> > understand there are some limitations here, but I don't know
> > which exactly.
> 
> No, you can't exec() anything. That would write mtime back to disk and
> cause badness.

SysRq-U remounts the disks readonly.  Why not make the disks readonly
once the kernel state is in swap, why not let any program run and give
an error to writes?

I know, long dead thread, but I too would like to tell the UPS to turn
off once the system state is resting safely in swap.  Currently my
modified apcupsd scripts tell the UPS to turn off, then tells the
kernel to hibernate, and hopes the kernel finishes in time.  I would
much rather do things the other way, but `echo disk > /sys/power/disk`
doesn't return until power is back on if everything goes well.

-- 
CC me on replies
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)
