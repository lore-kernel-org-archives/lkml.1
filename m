Return-Path: <linux-kernel-owner+w=401wt.eu-S1755607AbYFNUYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607AbYFNUYi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 16:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754509AbYFNUYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 16:24:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50097 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754458AbYFNUYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 16:24:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "werner" <werner@sys-linux.yi.org>
Subject: Re: Regressions in the last kernels
Date: Sat, 14 Jun 2008 22:25:12 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
References: <1213467969.31034@sys-linux.yi.org>
In-Reply-To: <1213467969.31034@sys-linux.yi.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806142225.12889.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 14 of June 2008, werner wrote:
> During preparation and own testing for my distro; installation on computers
> for neighbours, by reclamations by users, I learned about the following
> problems of 2.6.26-rcX :  
> 
> 1) When compiling for i486,  one cannot select/configurate more memory than
> 4 GB, menuconfig don't show items with higher values.  My own computer/server
> has 8 GB, but when I compile the kernel with 4 GB and i486 then 'free' shows
> only 3.2 GB (no shared grafics, the grafic card has its own memory) ...   

I've just created the Bugzilla entry at:
http://bugzilla.kernel.org/show_bug.cgi?id=10912
for this problem.  Please add yourself to the CC list in there and please file
a separate bug for the CD issue.

> 2) On some laptops, especially IBM/Centrinho laptops, 2.6.26-rcX dont find
> the CD devices, nor that from what was booted.   This problem is independend
> on the edd problem.  It wasn't present at the 2.6.25-rc9 kernel or earliers
> (i didn't test it on 2.6.25 defin.), but it's present at 2.6.26-rc4 and -rc5
> (-rc6 i didnt test).  Just because of this problem it wasnt possible to
> install something on this kind laptop, and I had yesterday to make a new
> Install .iso with an older kernel as alternative:
> ftp://ftp.uni-siegen.de/pub/sys-linux/SYS_Linux-0.23-rc3.iso           
> 
> Exactly happens the following:   BIOS finds correctly the CD drive for
> booting and boots, but later Linux dont find it (only older kernels), on some
> laptops.             I insert in the drive the Install DVD:  It boots, loads
> the kernel and the initrd correctly.   This is the small install / rescue
> system.  However, although everything present in /dev, inclusive the device
> nodes /dev/hdb  etc (but empty),  Linux don't find /dev/hdb f.ex. for mount
> it or calling with hdparm or anyhow else. Thus, also the system installation
> fails, because the packages or lzma-zipped system cannot be readed from the
> same CD what was used for boot and what BIOS found/managed ...     With
> exactly the same system/initrd, configuration etc everything the same but
> just change to an older kernel, everything works normally; thus this is a
> kernel regression           

This looks like it might have been fixed already.  Which -rc kernels have you
tried so far?

> *** At this point, I want to suggest, that Linux should have a special devide
> node /dev/<anyname> on what one can mount ANYWAY and ANYHOW that boot device
> what BIOS used and understood to boot from, even when the hardware detection
> of Linux fails completely.   When bios managed it to read that device and to
> load the kernel and the initrd , then Linux should manage it too, to read
> from the same CD other files.  This is necessary in order to perform the
> installation anyway, even when Linux dont find hardware or the boot CD. ***        

You can use the /dev/disk/by-id/* things for that I think.

Thanks,
Rafael
