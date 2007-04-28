Return-Path: <linux-kernel-owner+w=401wt.eu-S965818AbXD1NOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965818AbXD1NOA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 09:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030766AbXD1NOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 09:14:00 -0400
Received: from dtp.xs4all.nl ([80.126.206.180]:32652 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S965818AbXD1NNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 09:13:45 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Apr 2007 09:13:44 EDT
Date: Sat, 28 Apr 2007 15:07:02 +0200
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: linux-kernel@vger.kernel.org
Subject: nbd hangs in 2.6.21
Message-ID: <20070428130702.GA23589@bitwizard.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: BitWizard.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I've been doing some work with nbd-servers, but it seems they are
a bit unreliable right now. It seems to be the kernel side that
is locking up. 

Doing things like 

dd if=/dev/zero of=filesys bs=1k count=1 seek=1024000
nbd-server 1234 `pwd`/filesys 

and then 

nbd-client othersystem 1234 /dev/nd0 
mke2fs /dev/nd0
mount /dev/nd0 /mnt
cp -r /usr/src/linux/ /mnt/test1
cp -r /usr/src/linux/ /mnt/test2
sync

will usually do the trick: The sync will hang in disk-wait and never
come out of it. 

In my case "othersystem" is running 2.6.20. I don't think it is
causing the problems: the nbd-server is simply waiting for the next
request. I also tried a different codebase: nbdsvr. Same thing. 

Anybody else see this?

	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
