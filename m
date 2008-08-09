Return-Path: <linux-kernel-owner+w=401wt.eu-S1760605AbYHIJ3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760605AbYHIJ3Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 05:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbYHIJ3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 05:29:03 -0400
Received: from cadalboia.ferrara.linux.it ([195.110.122.101]:47547 "EHLO
	cadalboia.ferrara.linux.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752499AbYHIJ3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 05:29:00 -0400
X-Greylist: delayed 630 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Aug 2008 05:29:00 EDT
From: Fabio Coatti <cova@ferrara.linux.it>
Organization: FerraraLUG
To: linux-kernel@vger.kernel.org
Subject: SATA problems and fs corruption on recent kernels
Date: Sat, 9 Aug 2008 09:18:29 +0000
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808090918.29645.cova@ferrara.linux.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
I'm facing a quite annoying problem with sata disks. Googling a bit I've seen 
several references to similar issues, but without any hint on how to solve.
Short description, details below and on request ;) : on a quite old Pentium 
IV /IC7G abit mobo, I've started to see sata lockups when moving files of 
4~15Mb size. I do this quite often (photo, actually) and prior the 
2.6.25.something I can't recall any single problem. On that machine I've 3 
sata disks, both maxtor and seagate. The lockup caused XFS corruption, and a 
simple reset is not enough: I've to turn off the power to have the hd drive 
responding again, otherwise the machine will stop at POST.
It doesn't matter which HD are involved in file transfer, it can happen moving 
files on different partition of the same disk, between different disks and 
between sata and usb disks as well.
the same configuration worked without a glitch for years, using drivers  
sata_sil and ata_piix (that mobo has two controllers)

Since then, I've changed hardware: new mobo (M3N-HT asus), new processor, 
kernel and even some disks (I've added a new one). Of course new cables and 
power supply. So I think that a hw culprit can be excluded.
The driver has changed as well, now I use  ahci mode for sata disks. Tried 
with 2.6.26.2
The behaviour is exactly the same: moving files (more or less of the same size 
as before) causes a HD lockup so bad that it needs a power cycle to recover, 
otherwise the post will fail ahci detection of the drive (for those used to 
that controller, it waits  for some seconds with "Port:00" message, then the 
POST process locks)
now even a mount of the damaged xfs partition can trigger the freeze: I can 
only see a that xfs starts the recovery, then the hd stops blinking (always 
on) and after that even a "ls" on the drive remains stuck. This happens on a 
brand new 500Mb sata disk.
so it seems that nor the hardware, nor the 64 or 32 bit of cpu/kernel nor the 
low level drivers can explain this. I've tried only with xfs, but sounds 
strange that a fs can lockup a drive.
the hardware that I'm using is a 9850AMD phenom, m3n-ht mobo, 2.6.26.2 kernel, 
gentoo 2008.0, sata hd from seagate and maxtor, different sizes and models. 
AHCI sata drivers.
working on small size files seems to be fine, as I can compile kernels and 
I've installed the system without problems.
Now I will try several things to get more clues, I can donwngrade kernels to 
see if the situation changes (dunno if the new mobo is compatible with too 
old kernels...), but if someone can give me some hints about which tests has 
to be made and wich information I must provide, it will be most welcome
Thanks for any help.

