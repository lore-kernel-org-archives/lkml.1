Return-Path: <linux-kernel-owner+w=401wt.eu-S1758297AbZB0SOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758297AbZB0SOV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 13:14:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754294AbZB0SOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 13:14:12 -0500
Received: from alcalazamora.dti2.net ([81.24.162.8]:3663 "EHLO
	alcalazamora.dti2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610AbZB0SOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 13:14:11 -0500
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Feb 2009 13:14:10 EST
X-Spam-Processed: alcalazamora.dti2.net, Fri, 27 Feb 2009 19:09:02 +0100
	(not processed: message from valid local sender)
X-MDOP-RefID: str=0001.0A0B0202.49A82C3B.021C,ss=1,fgs=0 (_st=1 _vt=0 _iwf=0)
X-Authenticated-Sender: jorge@dti2.net
X-MDRemoteIP: 81.24.161.20
X-Return-Path: jorge@dti2.net
X-Envelope-From: jorge@dti2.net
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Message-ID: <49A82C2E.4030903@dti2.net>
Date: Fri, 27 Feb 2009 19:08:46 +0100
From: "Jorge Boncompte [DTI2]" <jorge@dti2.net>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: ext-adrian.hunter@nokia.com
CC: LKML <linux-kernel@vger.kernel.org>, npiggin@suse.de
Subject: Re: Error testing ext3 on brd ramdisk
References: <491D7C4C.3090907@nokia.com>
In-Reply-To: <491D7C4C.3090907@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Reply-To: jorge@dti2.net
X-MDAV-Processed: alcalazamora.dti2.net, Fri, 27 Feb 2009 19:09:04 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Hunter escribió:
> Hi
> 
> I am trying to test EXT3 on a ramdisk and after some number of mounts
> (anywhere from 7 to 603 so far), I get errors from e2fsck like this:
> 
> /dev/ram0: HTREE directory inode 137 has an invalid root node.
> HTREE INDEX CLEARED.
> /dev/ram0: Entry 'f1770' in /work/p0/da/d1c61 (137) has deleted/unused 
> inode 692.  CLEARED.
> /dev/ram0: Entry 'fa37' in /work/p0/da/d1c61 (137) has deleted/unused 
> inode 799.  CLEARED.
> /dev/ram0: Entry 'c1686' in /work/p0/da/d1c61 (137) has deleted/unused 
> inode 470.  CLEARED.
> /dev/ram0: Entry 'c19b8' in /work/p0/da/d1c61 (137) has an incorrect 
> filetype (was 3, should be 1).
> 
> /dev/ram0: UNEXPECTED INCONSISTENCY; RUN fsck MANUALLY.
>       (i.e., without -a or -p options)
> 
> 
> This is what I do:
> 
> 
> modprobe brd rd_nr=1 rd_size=4096
> mkfs.ext3 /dev/ram0
> dmesg -n8
> i=0
> while (true); do
>     i=`expr $i + 1`
>     echo -------------------------------------------------------------
>     echo Cycle $i
>     date
>     echo Mounting
>     sleep 1
>     mount -t ext3 /dev/ram0 /mnt/test_file_system || exit 1
>     echo Removing old fsstress data
>     rm -rf /mnt/test_file_system/work
>     mkdir /mnt/test_file_system/work || exit 1
>     echo Starting fsstress
>     fsstress -d /mnt/test_file_system/work -p 3 -l 0 -n 100000000 &
>     echo Sleeping 30 seconds
>     sleep 30
>     echo Stopping fsstress
>     while (ps -e | grep fsstress);do
>         pkill fsstress
>         sleep 1
>     done
>     echo Unmounting
>     umount /mnt/test_file_system || exit 1
>     echo Checking
>     sleep 1
>     e2fsck -fvp /dev/ram0 || exit 1
> done
> 
> 
> It seems to happen ever since the introduction of brd (Feb '08).
> 
> Does anyone know what is going on?
> 
	Hi,

	I have added Nick Piggin to the CC: as maintainer of the brd driver.

	After switching an embedded distribution that /etc on a ramdisk based 
minix filesystem from 2.6.23.17 to 2.6.29-rcX i am too getting errors 
ant the filesystem is corrupted. Does not happen always. The visible 
effect with text files after reboot is getting the old version of the 
file and "\0"'s at the end.

	Did you found a solution?

	Regards,

	Jorge
-- 
==============================================================
Jorge Boncompte - Ingenieria y Gestion de RED
DTI2 - Desarrollo de la Tecnologia de las Comunicaciones
--------------------------------------------------------------
C/ Abogado Enriquez Barrios, 5   14004 CORDOBA (SPAIN)
Tlf: +34 957 761395 / FAX: +34 957 450380
==============================================================
- Sin pistachos no hay Rock & Roll...
- Without wicker a basket cannot be made.
==============================================================

