Return-Path: <linux-kernel-owner+w=401wt.eu-S1758593AbZDWOyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593AbZDWOyW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 10:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbZDWOyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 10:54:08 -0400
Received: from relay03-haj2.antispameurope.com ([83.246.65.53]:39070 "EHLO
	relay03-haj2.antispameurope.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752250AbZDWOyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 10:54:07 -0400
X-Greylist: delayed 352 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Apr 2009 10:54:06 EDT
Date: Thu, 23 Apr 2009 16:48:08 +0200
From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
To: adi@hexapodia.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6.30-rc2] CD-R: wodim intermittent failures: [sr0] Add. Sense: Logical block address out of range, sector 0
Message-ID: <49f07fa8.UFHStOXJD5eYq3ER%Joerg.Schilling@fokus.fraunhofer.de>
User-Agent: nail 11.22 3/20/05
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 23 Apr 2009 14:48:08.0673 (UTC) FILETIME=[84717510:01C9C422]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see two possible problems that should be first resolved.

1)	You are using "wodim" instead of cdrecord.
	"wodim" is a very old version (4+ years) of cdrecord with
	additional bugs. Due to Copyright & GPL violations, it cannot
	even be legally distributed.

2)	You may be using the linux hald version

I recommend to first get a recent original cdrtools package from

ftp://ftp.berlios.de/pub/cdrecord/alpha/

and to try with this after running "make install" as root.
As Linux requires root privileges for many SCSI commands, you need to 
install cdreord suid root which is automatically done via "make install"
as root.

If your problem persists, try to kill hald. Hald on Linux has many problems:

-	It looks for the wrong state transitions on the CD drive 
	and thus distrurbes CD/DVD/BD writing. It may e.g. try to mount a CD 
	that has not yet been fully written.

-	The O_EXCL metod it believes on just cannot ever work correctly:

	-	You would not be able to read out written media CD-DA or CD-ROM

	-	You would not be able to deal with multi-session media

	-	As Linux offers to access CD/DVD/BD-drives vie more than one
		device driver and as these device drivers don't know each other
		O_EXCL cannot work anyway.

If your problem still persists, you may have a Linux kernel problem.

BTW: please keep me on CC:

Jörg

-- 
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) Jörg Schilling D-13353 Berlin
       js@cs.tu-berlin.de                (uni)  
       joerg.schilling@fokus.fraunhofer.de (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.berlios.de/private/ ftp://ftp.berlios.de/pub/schily
