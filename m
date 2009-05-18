Return-Path: <linux-kernel-owner+w=401wt.eu-S1754245AbZERRSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245AbZERRSu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 13:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbZERRSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 13:18:42 -0400
Received: from smtp.cs.aau.dk ([130.225.194.6]:53135 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338AbZERRSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 13:18:42 -0400
X-Greylist: delayed 3881 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 May 2009 13:18:41 EDT
Subject: Re: Houston, we have a problem: big file copying, USB, external
 disks
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: John Zupfel <jzupfel@yahoo.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
In-Reply-To: <223602.79528.qm@web26101.mail.ukl.yahoo.com>
References: <223602.79528.qm@web26101.mail.ukl.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 May 2009 18:14:35 +0200
Message-Id: <1242663275.15127.265.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

man, 18 05 2009 kl. 13:47 +0000, skrev John Zupfel:
> --- On Mon, 18/5/09, Ralf Hildebrandt <Ralf.Hildebrandt@charite.de> wrote:
> > Does this happen AFTER a suspend/hibernate or ALL THE TIME?
> 
> All the time. And according to most of the reports, the slowdown
> usually starts after the first several hundred MiBs have been copied.

Please use the reply button in your email client to avoid breaking
threading.

The bug you link to

> https://bugs.launchpad.net/ubuntu/+source/gvfs/+bug/197762?comments=all

is unfortunately a complete mess and not really helpful. There are 20
different people involved and they mostly pop in with a message or two
with next to nothing of real substance with regard to solving the
problem. As far as I can tell there are people experiencing all of the
following "problems" (indiviually, not at the same time)
 - their hardware is in USB 1.1 and not 2.0 mode,
 - the file copy writes into the page cache that is in memory and the
   writing to disk does not start until the cache is full or
   pdflush initiates writing to disk (the GUI shows a fast transfer rate
   at the beginning of the transfer and then slows down to the real
   bandwidth of the underlying device)
 - performance is slower when disk is mounted sync and not async,
 - the underlying device cannot sustain an even write rate over longer
   periods (possible for flash based devices), or
 - excessive dmesg output (to the point it could even slow the copy
   down?)

Then there is the genuine possibility of a bug in
 - mmc/sdhci driver or layer,
 - usb driver or layer, or
 - somewhere else.

It is also unclear how the users determine that a given transfer rate is
bad. Again, everything along the lines of the following
 - Linux does worse than Windows XP,
 - version 2.6.27.9 is worse than 2.6.27.7,
 - the 64 bit version is worse than the 32 bit version of the same
   kernel version, 
 - the transfer rate is ridiculous slow (< 100 kB/s), or
 - using the sync mount option is worse than using async.

Now if some users can narrow it down to somewhere between 2.6.27.7
and .9 then get them to bisect the patches that went in between the two
minor releases. Or possibly inspect the patches to see if there is an
obvious candidate that can be tried out right away.

Generally, if they can provide another version of Ubuntu (and thus the
kernel) that works better it should be relatively easy to make some
progress.

If some users can tell a significant difference between a 32 vs. 64 bit
version go investigate further, starting with the output of dmesg, lspci
and lsusb for both versions.

If transfer rate is ridiculous slow then check dmesg, lspci and lsusb
with the driver or subsystem author of the device (after checking for
obvious signs of something odd in dmesg and having tested the latest
release candidate of the upstream kernel).

If transfer rate is in the ~1 MB/s area then check that the device is
really running in 2.0 mode. Then check that another operating system
really have better performance (remembering to properly wait for all
data to hit disk before stopping the clock). Or better yet, find another
version of Linux that have better performance.

If sync is somewhat slower than async it is probably what can be
expected. A large difference for big files should probably taken up with
the kernel developers. Again, check with the latest upstream version
before reporting though.

And how come the Ubuntu folks mark bugs as duplicates without having any
evidence that the cause is the same. How on earth can a bug be marked as
a duplicate of another when there is absolute no idea what the course of
the latter is?

Now, Leann Ogasawara actually already told people to report in separate
bugs and provide various info. Few others actually did. How about you do
something useful and make it happen that the people provide useful
information in separate bugs such that it is parsable without having to
spent literally hours trying to figure how a report from X is (possibly
not) related to the one from Y?



Simon Holm Thøgersen

