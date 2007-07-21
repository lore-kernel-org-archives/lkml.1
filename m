Return-Path: <linux-kernel-owner+w=401wt.eu-S939189AbXGUAiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939189AbXGUAiI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 20:38:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762691AbXGUAh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 20:37:56 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:35868
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762874AbXGUAhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 20:37:55 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Greg KH <greg@kroah.com>
Subject: Re: Documentation for sysfs, hotplug, and firmware loading.
Date: Fri, 20 Jul 2007 20:37:48 -0400
User-Agent: KMail/1.9.6
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org,
       Michael-Luke Jones <mlj28@cam.ac.uk>, Krzysztof Halasa <khc@pm.waw.pl>,
       Rod Whitby <rod@whitby.id.au>, Russell King <rmk@arm.linux.org.uk>,
       david@lang.hm
References: <200707171703.31340.rob@landley.net> <200707181339.54192.rob@landley.net> <20070718234020.GA5971@kroah.com>
In-Reply-To: <20070718234020.GA5971@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707202037.48871.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 July 2007 7:40:20 pm Greg KH wrote:
> On Wed, Jul 18, 2007 at 01:39:53PM -0400, Rob Landley wrote:
> > PICK ONE!  JUST #*%(&#%& PICK ONE!  AAAAAAAAHHHHHHH!!!!!!!!!
> >
> > I don't care where it is.  Just put it somewhere I can find it, and keep
> > it there.  All this gratuitous moving stuff around serves NO PURPOSE
> > other than to break userspace.  I'm trying to document this so that the
> > next time you go "oh wait, it should be at "/sys/tarantula/fruitbat" I
> > can show that you're breaking an existing documented userspace API.
> >
> > There's a kernel config option to make symlinks from the old
> > location.  /sys/block makes as much sense as any other location, and it's
> > what's there now.
>
> Read the sysfs documentation file we just added, it describes how this
> is all documented and should be used.  So well that I do not think you
> need to try to document it again.

I'm not trying to document all of sysfs, I'm trying to document hotplug.  I 
realize now I should have been more clear about that.

I've been working on the document I just posted on and off since may,  
(Possibly longer but I lost a lot of data in the hard drive crash on my 
laptop last month.  For example, I can't find a copy of my 
half-finished "history of hotplug" document and will probably need to start 
over, although I've still got a few places to look to see if I backed up a 
copy...)

This document has been sitting mostly unchanged on my hard drive since OLS, 
until I finally tracked down example code to do the netlink bit so I could 
finish it.  I tried to bounce a copy of the "everything but netlink" version 
off of kay by replying to his email with notes from OLS, and that's when I 
bumped into the "he's spam-blocking me" issue.  It got lost in the shuffle of 
OLS, and I just got back to it at the start of this thread.

Earlier today I read (and commented on, in the message to Cornelia Huck) the 
copy of Documentation/sysfs-rules.txt.  (Ah, darn it.  I have too many open 
windows on my desktop.  Hits "send" on message to Cornelia huck I _wrote_ 
earlier today.)

Documentation/sysfs-rules.txt doesn't talk about /sbin/hotplug or netlink 
hotplug.  It doesn't say how to distinguish a char device from a block 
device.  It mostly talks about finding stuff under the "/sys/devices" 
directory, most of which isn't relevant to populating /dev.  It doesn't 
clearly distinguish where you can find information in current kernels (2.6.22 
and earlier) from stuff that hasn't gone into any existing release.  Ideally 
I'd like to identify a subset of that information which is not only present 
in current kernels but should remain findable at that location in future 
kernels.  Over half the document is about what _not_ to do, and consists of 
warnings about "buggy apps", despite the assumption that anything _not_ 
explicitly documented is forbidden because most of the things sysfs exports 
are considered unmaintainable.

I've read the stuff under Documentation/ABI/{stable,testing}, and would be 
happy to refer to it rather than duplicating if I could get the info I needed 
out of it.  Documentation/filesystems/sysfs.txt is still from Patrick Mochel 
in 2003 and mostly about the kernel side rather than an API exported to 
userspace, and sysfs-pci.txt in that directory is similar.  Is there more I 
missed?

> thanks,
>
> greg k-h

Sorry, I'm not trying to be a pain.  I'm trying to document something I had to 
figure out for myself experimentally in 2005, which has been broken for me by 
kernel changes twice since then (when the "device" symlink went in back 
around 2.6.14, and when subdirs turned to symlinks recently), and I'm told is 
changing again with the additon of /sys/class/block (which means /sys/class/* 
no longer contains just char devices).

Ideally I'd like to come up with documentation that allows somebody to write 
one program that works on existing AND on new kernels, hence "stable API".

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
