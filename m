Return-Path: <linux-kernel-owner+w=401wt.eu-S1757571AbYHLAHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571AbYHLAHx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 20:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753175AbYHLAHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 20:07:45 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:36130 "EHLO
	pd2mo1so-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751826AbYHLAHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 20:07:45 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=faf1xRi31K4FzEFN47wA:9 a=cyYcrFLfW7LMPWNSDt0A:7 a=403rsoUO5f31WH-cwDTjKkHNR4QA:4 a=EtHtKukPCjYA:10 a=9B8GDptcLtsA:10
Message-ID: <48A0D44D.7010305@shaw.ca>
Date: Mon, 11 Aug 2008 18:07:41 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Fabio Coatti <cova@ferrara.linux.it>
CC: linux-kernel@vger.kernel.org
Subject: Re: SATA problems and fs corruption on recent kernels
References: <fa.PZ8V7KpfqpWoxUeVa4Sv6GFtUN0@ifi.uio.no>
In-Reply-To: <fa.PZ8V7KpfqpWoxUeVa4Sv6GFtUN0@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fabio Coatti wrote:
> Hi all,
> I'm facing a quite annoying problem with sata disks. Googling a bit I've seen 
> several references to similar issues, but without any hint on how to solve.
> Short description, details below and on request ;) : on a quite old Pentium 
> IV /IC7G abit mobo, I've started to see sata lockups when moving files of 
> 4~15Mb size. I do this quite often (photo, actually) and prior the 
> 2.6.25.something I can't recall any single problem. On that machine I've 3 
> sata disks, both maxtor and seagate. The lockup caused XFS corruption, and a 
> simple reset is not enough: I've to turn off the power to have the hd drive 
> responding again, otherwise the machine will stop at POST.
> It doesn't matter which HD are involved in file transfer, it can happen moving 
> files on different partition of the same disk, between different disks and 
> between sata and usb disks as well.
> the same configuration worked without a glitch for years, using drivers  
> sata_sil and ata_piix (that mobo has two controllers)
> 
> Since then, I've changed hardware: new mobo (M3N-HT asus), new processor, 
> kernel and even some disks (I've added a new one). Of course new cables and 
> power supply. So I think that a hw culprit can be excluded.
> The driver has changed as well, now I use  ahci mode for sata disks. Tried 
> with 2.6.26.2
> The behaviour is exactly the same: moving files (more or less of the same size 
> as before) causes a HD lockup so bad that it needs a power cycle to recover, 
> otherwise the post will fail ahci detection of the drive (for those used to 
> that controller, it waits  for some seconds with "Port:00" message, then the 
> POST process locks)
> now even a mount of the damaged xfs partition can trigger the freeze: I can 
> only see a that xfs starts the recovery, then the hd stops blinking (always 
> on) and after that even a "ls" on the drive remains stuck. This happens on a 
> brand new 500Mb sata disk.
> so it seems that nor the hardware, nor the 64 or 32 bit of cpu/kernel nor the 
> low level drivers can explain this. I've tried only with xfs, but sounds 
> strange that a fs can lockup a drive.
> the hardware that I'm using is a 9850AMD phenom, m3n-ht mobo, 2.6.26.2 kernel, 
> gentoo 2008.0, sata hd from seagate and maxtor, different sizes and models. 
> AHCI sata drivers.
> working on small size files seems to be fine, as I can compile kernels and 
> I've installed the system without problems.
> Now I will try several things to get more clues, I can donwngrade kernels to 
> see if the situation changes (dunno if the new mobo is compatible with too 
> old kernels...), but if someone can give me some hints about which tests has 
> to be made and wich information I must provide, it will be most welcome
> Thanks for any help.

For things to lock up badly enough that even BIOS POST fails to detect 
the drives or locks up really seems like a hardware problem to me. 
You're still using some of the same disks from the old machine?
