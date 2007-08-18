Return-Path: <linux-kernel-owner+w=401wt.eu-S1757708AbXHRRot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757708AbXHRRot (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 13:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754440AbXHRRoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 13:44:39 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:53208 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072AbXHRRoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 13:44:38 -0400
X-Originating-Ip: 72.143.66.27
Date: Sat, 18 Aug 2007 13:35:33 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: tracking MAINTAINERS versus tracking SUBSYSTEMS
Message-ID: <Pine.LNX.4.64.0708181311490.10387@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  this latest project of cramming the full definition of each kernel
subsystem into the MAINTAINERS file has been bothering me, and i've
finally figured out why.  it's because the MAINTAINERS file is being
asked to now be the source of reference information that just doesn't
match its name.  it's the "MAINTAINERS" file so it seems that all it
should be keeping track of is the maintainer of each subsystem, and
that's all.

  what people are clearly after is a way to match any part of the
kernel source to a subsystem and, henceforth, to a maintainer, but
there's nothing that says all of that has to be crammed into *that*
file.

  why not add a new script to the kernel source tree that, given a
file or directory name as an argument, returns its corresponding
"subsystem" that can be cross-referenced against the MAINTAINERS file?
something like:

  $ show_subsystem drivers/bluetooth/bpa10x.c
  BLUETOOTH

there would seem to be a number of advantages to this approach:

1) it reduces the MAINTAINERS file back to what it should be in the
first place -- a simple reference list of each kernel subsystem, and
who's responsible for it, so that constant reshuffling of files or
directories in a particular subsystem doesn't require constant
updating of the MAINTAINERS file.

2) you could extend the show_subsystem() routine to, once it found the
subsystem, quickly cross-reference the MAINTAINERS file and print out
the corresponding maintainer.  i believe the word "trivial" applies
here.

3) by making this a feature separate from the MAINTAINERS file, it can
be mocked up and hacked separately and finally patched in when it's
ready to go, rather than applying 5 bazillion patches to the poor
MAINTAINERS file.

4) finally, a feature like this could be used as a sanity check on the
kernel subsystem structure.  every once in a while, it could be
invoked for every single file and directory in the tree, just to see
if all of those appear to belong to at least one subsystem.  if not,
print a warning:  "Whoa, file /fubar/snafu doesn't belong to a
subsystem.  Deal with it."

  the actual implementation would seem to be easy -- perhaps a simple
text file that defines each subsystem and every file and directory
that's part of it:

FIREWIRE:drivers/firewire/,include/linux/firewire.h,... etc ...

i mean, it doesn't get a whole lot simpler than that, and it would
seem to be *way* easier to read.

  thoughts?

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
