Return-Path: <linux-kernel-owner+w=401wt.eu-S1761627AbXGLXGC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761627AbXGLXGC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 19:06:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757448AbXGLXFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 19:05:55 -0400
Received: from ns2.g-housing.de ([81.169.133.75]:55221 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755955AbXGLXFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 19:05:55 -0400
X-Greylist: delayed 1716 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Jul 2007 19:05:54 EDT
Date: Fri, 13 Jul 2007 00:37:10 +0200 (CEST)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: linux-kernel@vger.kernel.org
cc: linuxppc-dev@ozlabs.org
Subject: Weird oopses with 2.6.22-rc7
Message-ID: <alpine.DEB.0.99.0707130016270.18512@sheep.housecafe.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

Since a few days I'm experiencing weird oopses on my iBook/G4 with 
ubuntu's 2.6.22-7-powerpc and also with a vanilla 2.6.22-rc7-git8.

Now for the "weird" part: The oops happens when doing "make install" for 
a piece of software (xine-ui media player) as *root*. No kidding, it 
does NOT happen when I compile the software and do "make install" as a 
normal user. This is 100% reproducible, here're some technical infos 
before I go on describing whe I did:

 	http://nerdbynature.de/bits/2.6.22-rc7-git8/

I've compiled this software earlier, numerous times, always doing 
"make" as a user and "sudo make install" afterwards to install to 
/opt/xine. So when I now tried "make install" as a user I had to chown 
/opt/xine to the user of course.

Even funnier: the dmesg output was captured when I was in 
runlevel 1 - here "make install" (as root) did produce an oops too, but 
the system did NOT panic. I typed "make install" a few times - always an 
oops, but no panic (in runlevel 1).

The netconsole.log captured the panics as well, but the output is kinda 
messy (as always), I'll try to reformat the logfile a bit...

When the Oopses started I checked memory (no memtest86 for ppc, but 
userspace memtest found nothing) and the harddisk (dd'ing from the whole 
disk) and fsck'ed the ext3 - not a single error. Also, all other 
applications are running fine (X11, music, video and stuff),
the system is stable as usual.

I even moved the old target-directory (make install...) out of the way 
and created a new one (new inode, new luck or so) - but to no avail. 
"fsck.ext3 -D" to reindex the directories, still the Oopses just won't 
go away. Searching the net for "Unrecoverable FP Unavailable Exception" 
did not return much :(

Any ideas which magic syscall could cause these oopses?

Thanks,
Christian.
-- 
BOFH excuse #409:

The vulcan-death-grip ping has been applied.
