Return-Path: <linux-kernel-owner+w=401wt.eu-S1760110AbZD0TH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760110AbZD0TH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 15:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759681AbZD0THY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 15:07:24 -0400
Received: from mail.tmr.com ([64.65.253.246]:39646 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759646AbZD0THX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 15:07:23 -0400
Message-ID: <49F60260.9080602@tmr.com>
Date: Mon, 27 Apr 2009 15:07:12 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090328 Fedora/1.1.15-3.fc9 SeaMonkey/1.1.15
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>
CC: adi@hexapodia.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6.30-rc2] CD-R: wodim intermittent failures: [sr0] Add. Sense:
 Logical block address out of range, sector 0
References: <49f07fa8.UFHStOXJD5eYq3ER%Joerg.Schilling@fokus.fraunhofer.de>
In-Reply-To: <49f07fa8.UFHStOXJD5eYq3ER%Joerg.Schilling@fokus.fraunhofer.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Schilling wrote:
> I see two possible problems that should be first resolved.
> 
> 1)	You are using "wodim" instead of cdrecord.
> 	"wodim" is a very old version (4+ years) of cdrecord with
> 	additional bugs. Due to Copyright & GPL violations, it cannot
> 	even be legally distributed.
> 
> 2)	You may be using the linux hald version
> 
> I recommend to first get a recent original cdrtools package from
> 
> ftp://ftp.berlios.de/pub/cdrecord/alpha/
> 
> and to try with this after running "make install" as root.
> As Linux requires root privileges for many SCSI commands, you need to 
> install cdreord suid root which is automatically done via "make install"
> as root.
> 
> If your problem persists, try to kill hald. Hald on Linux has many problems:
> 
> -	It looks for the wrong state transitions on the CD drive 
> 	and thus distrurbes CD/DVD/BD writing. It may e.g. try to mount a CD 
> 	that has not yet been fully written.
> 
Appears to be true, but that's not a kernel problem, it's a hald problem, the 
fix belongs there.

> -	The O_EXCL metod it believes on just cannot ever work correctly:
> 
> 	-	You would not be able to read out written media CD-DA or CD-ROM
> 
> 	-	You would not be able to deal with multi-session media
> 
I don't quite see how these two follow from using O-EXCL, assuming the device is 
released after writing, but see next:

> 	-	As Linux offers to access CD/DVD/BD-drives vie more than one
> 		device driver and as these device drivers don't know each other
> 		O_EXCL cannot work anyway.
> 
And that is a kernel problem, allowing multiple access paths which don't share 
exclusion is a dubious design decision. O_EXCL really should work.

> If your problem still persists, you may have a Linux kernel problem.
> 
The usual solution is to tell hald and your window manager of choice not to 
mount things automatically, or at least not while they are opened. But that's a 
fudge, not a fix, O_EXCL should positively prevent this problem.

> BTW: please keep me on CC:
> 
> Jörg
> 


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

