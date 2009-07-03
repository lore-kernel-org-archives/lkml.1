Return-Path: <linux-kernel-owner+w=401wt.eu-S1755562AbZGCB04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbZGCB04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 21:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbZGCB0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 21:26:46 -0400
Received: from mail.samba.org ([66.70.73.150]:50810 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380AbZGCB0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 21:26:45 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19021.24134.319252.776778@samba.org>
Date: Fri, 3 Jul 2009 11:26:30 +1000
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regression
In-Reply-To: <alpine.LSU.2.00.0907030254180.22039@fbirervta.pbzchgretzou.qr>
References: <19013.8005.541836.436991@samba.org>
	<20090630063102.GB1351@ucw.cz>
	<200907012019.53932.rusty@rustcorp.com.au>
	<20090701122558.3a7c80d3@lxorguk.ukuu.org.uk>
	<20090701140503.GA21185@mit.edu>
	<alpine.LSU.2.00.0907030056210.17183@fbirervta.pbzchgretzou.qr>
	<19021.17576.808138.476600@samba.org>
	<alpine.LSU.2.00.0907030149020.17183@fbirervta.pbzchgretzou.qr>
	<19021.20449.732095.210252@samba.org>
	<alpine.LSU.2.00.0907030254180.22039@fbirervta.pbzchgretzou.qr>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

 > The mount(8) manpage becomes pretty ambiguous with the dualnames
 > patch.

yes, the man page will need an update certainly. 

 > Making WINNT the default would cause many a `ls` output to just
 > scream at me in uppercaps because there are programs that
 > create long names with all-uppers.

well, you could also argue that having WINNT in effect does the
'correct' thing. It causes ls to display the name that is actually in
the filesystem. 

I think the current default for VFAT on Linux is rather misleading. It
always displays 8.3 names as lowercase, so MAIL.dat, foo.TXT and other
combinations always display as lowercase, regardless of what the
application that created the file chose for the name.

With the winnt option the names are shown as the application that
created them chose. That is also what all current versions of Windows
do as far as I know.

yes, this means that for a digital camera card, where the camera is
always choosing all uppercase for the filenames, it can look like
'shouting' on a Linux system where lowercase is more usual. It is
however an accurate representation and maximises compatibility.

I think the current defaults were chosen a long time ago, when Win95
was more the norm, and 16 bit apps that weren't written for case
preserving filesystems were common. That era is long gone.

 > shortname really needs to be split into "shortname that is applied
 > during creation" and "shortname that is applied upon readdir".

perhaps, but I think (as you discovered!) the current VFAT options are
already too complex, and very few people set them correctly. Adding
more options to get yet more varients to the case handling behaviour
doesn't seem like a good move to me.

Other OSes with FAT implementations just choose a sane default (which
probably matches our shortname=winnt pretty closely) and the user
never gets to choose. Choice isn't always a good thing!

I should also point out that if we followed Alan's reasoning then we'd
have to actually make all these options separate filesystems, and we'd
only be able to call the shortname=winnt one "VFAT" as that is the
only one that matches Windows behaviour. The others all treat the
filesystem differently to what Windows does. (no, I'm not seriously
proposing this, just pointing out that the "it has to be a different
filesystem name" has not been always applied previously).

I wonder if Pavel still thinks that VFAT was perfect before I came
along :-)

Cheers, Tridge
