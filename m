Return-Path: <linux-kernel-owner+w=401wt.eu-S1753841AbXJ2UTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbXJ2UTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 16:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbXJ2UTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 16:19:08 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:52687 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbXJ2UTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 16:19:07 -0400
Date: Mon, 29 Oct 2007 21:19:11 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org
Subject: Re: WANTED: kernel projects for CS students
Message-ID: <20071029201911.GB3537@elf.ucw.cz>
References: <20071014190128.6e3cdb44@bree.surriel.com> <20071028180707.GA6111@ucw.cz> <20071029194820.GC27646@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029194820.GC27646@csclub.uwaterloo.ca>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2007-10-29 15:48:20, Lennart Sorensen wrote:
> On Sun, Oct 28, 2007 at 06:07:07PM +0000, Pavel Machek wrote:
> > Hard stuff:
> > 
> > * network character device -- similar to nbd, but for char devices.
> >   either figure out how to forward ioctls(), or implement
> >   usb-over-network, or...
> > 
> > * openMosix -- they seem to have userspace solution, but not GPLed.
> > 
> > * compression for ext4. Its about time someone did it right. Special
> >   bonus if you can do it in a way that it does not slow down. If cpu
> >   is free, compress, if it is busy, just write it straight to disk.
> 
> So if I decide that the cpu is busy (because something is asking me to
> write the cpu is clearly doing something and hence busy), then I can
> skip compression and just write to disk.  So by that definition ext4
> already does compression.  What a simple project. :)

Tell it to your profesor ;-).

> Did you mean it ought to come back and do the compression later?

Not neccessarily but yes, that would be nice, too.

> Is it possible that for some data compressing it and writing will take
> less time than not compressing it and writing it to disk?

Yes. Typically for all zeros. It will be similar for
highly-compressible data (pictures, timetables, ....)

root@amd:/data/tmp# time ( cat /dev/zero | head -c 100000000 > delme; sync )
0.04user 0.48system 6.52 (0m6.521s) elapsed 7.97%CPU
root@amd:/data/tmp# time ( cat /dev/zero | head -c 100000000 > delme; sync )
0.05user 0.61system 6.33 (0m6.333s) elapsed 10.42%CPU
root@amd:/data/tmp# time ( cat /dev/zero | head -c 100000000 | gzip - > delme; sync )
1.57user 0.32system 1.74 (0m1.749s) elapsed 100.00%CPU
root@amd:/data/tmp# time ( cat /dev/zero | head -c 100000000 | gzip - > delme; sync )
1.61user 0.18system 1.65 (0m1.652s) elapsed 100.00%CPU

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
