Return-Path: <linux-kernel-owner+w=401wt.eu-S933026AbXCMLL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933026AbXCMLL2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 07:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933073AbXCMLL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 07:11:28 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:11020 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933026AbXCMLL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 07:11:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=gCkVV5j9nsJ2wTSq8wNl4J2XyEjqI5+rJ5VJSdtzWL8W8SVMXD+1PzLC9lvtZRvDe5gD6h7DrrRoyt9VOvlyHHlLfTCGEwwWQi8um7zvoWrUvy2gri/YJcuuuJEpGA9cSZQ09vhJClABb/VpDUxHQ8gZfvB4kZa9fdvQaNtZNjs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 8187] New: 2.6.20 "PCI: Quirks" patch breaks X11 on I82801
Date: Tue, 13 Mar 2007 12:18:30 +0100
User-Agent: KMail/1.9.6
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       linux-kernel@vger.kernel.org, ktk@bigfoot.com
References: <200703122030.l2CKU5ES022977@fire-2.osdl.org> <20070312221952.691adeea.akpm@linux-foundation.org>
In-Reply-To: <20070312221952.691adeea.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703131218.30906.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 13 March 2007, Andrew Morton wrote:
> > On Mon, 12 Mar 2007 13:30:05 -0700 bugme-daemon@bugzilla.kernel.org wrote:
> > http://bugzilla.kernel.org/show_bug.cgi?id=8187
> > 
> >            Summary: 2.6.20 "PCI: Quirks" patch breaks X11 on I82801
> >     Kernel Version: 2.6.20
> >             Status: NEW
> >           Severity: normal
> >              Owner: greg@kroah.com
> >          Submitter: ktk@bigfoot.com
> > 
> > 
> > Most recent kernel where this bug did *NOT* occur:
> > Any 2.6.20-pre prior to commit 368c73d4f689dae0807d0a2aa74c61fd2b9b075f
> > 
> > Distribution:  Slackware 11.0
> > Hardware Environment:  HP/Compaq dc5000S (P4, 82801, 82865)
> > Software Environment:  Xorg 6.9.0
> > Problem Description:
> > 
> > Alan Cox introduced a "PCI: Quirks" patch (git commit
> > 368c73d4f689dae0807d0a2aa74c61fd2b9b075f) in 2.6.20 that breaks X11 on this
> > I82801 platform.  Specifically, it causes the PCI initialisation to become
> > buggered; Xorg 6.9.0 dumps the following to the console:
> > 	(EE) end of block range 0x177 < begin 0x3f0
> > 	(EE) end of block range 0x177 < begin 0x3f0
> > 	(WW) ****INVALID IO ALLOCATION**** b: 0x14d0 e: 0x14d7 correcting
> > [...]
> > 	Backtrace:
> > 	0: X(xf86SigHandler+0x8a) [0x8088b2a]
> > 	1: [0xb7f2b420]
> > 	2: /usr/X11R6/lib/modules/drivers/i810_drv.so [0xb797f592]
> > 	3: X(InitOutput+0xb83) [0x8072713]
> > 	4: X(main+0x226) [0x80d4496]
> > 	5: /lib/tls/libc.so.6(__libc_start_main+0xd4) [0xb7da7e14]
> > 	6: X [0x806ff61]
> > 
> > 	Fatal server error:
> > 	Caught signal 11.  Server aborting
> > 
> > Steps to reproduce:
> > 
> > Reverting the git commit mentioned above fixes the issue.  Apparently, this may
> > be limited to certain combinations of on-motherboard chipsets, as I haven't seen
> > many bug reports.  Googling shows some people having X11 segfault issues with
> > 2.6.20 (e.g. freedesktop.org bug #9956) but in most of those cases it's due to
> > the evdev driver and not PCI initialisation.
> > 
> > I wrote to Alan (cc'ed Greg as he signed off on the patch) nearly two weeks ago
> > but have heard nothing, so I'm leaving a bug here instead.
> > 
> 
> argh.
> 
> Would we break more machines than we fix if we just revert that?

this should be fixed in 2.6.21-rc3,
commit ed8ccee0918ad063a4741c0656fda783e02df627

Bart
