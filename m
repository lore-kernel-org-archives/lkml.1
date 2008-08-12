Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736AbYHLWGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbYHLWGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 18:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754750AbYHLWGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 18:06:18 -0400
Received: from smtpi2.ngi.it ([88.149.128.21]:58788 "EHLO smtpi2.ngi.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754341AbYHLWGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 18:06:16 -0400
X-Greylist: delayed 6052 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Aug 2008 18:06:16 EDT
From: Fabio Coatti <cova@ferrara.linux.it>
Organization: FerraraLUG
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: SATA problems and fs corruption on recent kernels
Date: Tue, 12 Aug 2008 22:24:39 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <fa.PZ8V7KpfqpWoxUeVa4Sv6GFtUN0@ifi.uio.no> <48A0D44D.7010305@shaw.ca>
In-Reply-To: <48A0D44D.7010305@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808122224.39863.cova@ferrara.linux.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alle Tuesday 12 August 2008, Robert Hancock ha scritto:
> Fabio Coatti wrote:
> > Hi all,
> > I'm facing a quite annoying problem with sata disks. Googling a bit I've
> > seen several references to similar issues, but without any hint on how to
> > solve. Short description, details below and on request ;) : on a quite
> > old Pentium IV /IC7G abit mobo, I've started to see sata lockups when
> > moving files of 4~15Mb size. I do this quite often (photo, actually) and
> > prior the 2.6.25.something I can't recall any single problem. On that
> > machine I've 3 sata disks, both maxtor and seagate. The lockup caused XFS
> > corruption, and a simple reset is not enough: I've to turn off the power
> > to have the hd drive responding again, otherwise the machine will stop at
> > POST.
> > It doesn't matter which HD are involved in file transfer, it can happen
> > moving files on different partition of the same disk, between different
> > disks and between sata and usb disks as well.
> > the same configuration worked without a glitch for years, using drivers
> > sata_sil and ata_piix (that mobo has two controllers)
> >
> > Since then, I've changed hardware: new mobo (M3N-HT asus), new processor,
> > kernel and even some disks (I've added a new one). Of course new cables
> > and power supply. So I think that a hw culprit can be excluded.
> > The driver has changed as well, now I use  ahci mode for sata disks.
> > Tried with 2.6.26.2
> > The behaviour is exactly the same: moving files (more or less of the same
> > size as before) causes a HD lockup so bad that it needs a power cycle to
> > recover, otherwise the post will fail ahci detection of the drive (for
> > those used to that controller, it waits  for some seconds with "Port:00"
> > message, then the POST process locks)
> > now even a mount of the damaged xfs partition can trigger the freeze: I
> > can only see a that xfs starts the recovery, then the hd stops blinking
> > (always on) and after that even a "ls" on the drive remains stuck. This
> > happens on a brand new 500Mb sata disk.
> > so it seems that nor the hardware, nor the 64 or 32 bit of cpu/kernel nor
> > the low level drivers can explain this. I've tried only with xfs, but
> > sounds strange that a fs can lockup a drive.
> > the hardware that I'm using is a 9850AMD phenom, m3n-ht mobo, 2.6.26.2
> > kernel, gentoo 2008.0, sata hd from seagate and maxtor, different sizes
> > and models. AHCI sata drivers.
> > working on small size files seems to be fine, as I can compile kernels
> > and I've installed the system without problems.
> > Now I will try several things to get more clues, I can donwngrade kernels
> > to see if the situation changes (dunno if the new mobo is compatible with
> > too old kernels...), but if someone can give me some hints about which
> > tests has to be made and wich information I must provide, it will be most
> > welcome Thanks for any help.
>
> For things to lock up badly enough that even BIOS POST fails to detect
> the drives or locks up really seems like a hardware problem to me.
> You're still using some of the same disks from the old machine?

Yes, and the hardware problem is the first thing I thinked of, but I've 
changed MB and cables, as well as bought a new disk. An I still get some I/O 
errors, even on the new one.
So, or I'm a bit unlucky to find several faulty disks in a row (it can be :) ) 
or something unclear is going on. 
The disk that suffers most lockups, after many tries, is the new one, the only 
SATA-II drive.
I'll keep stressing the HD trying to figure out what's going on, I'll even try 
a new sata-II unit, to see if I've really picked a heap of faulty disks.

Thanks for the answer!


-- 
Fabio Coatti       http://members.ferrara.linux.it/cova     
Ferrara Linux Users Group           http://ferrara.linux.it
GnuPG fp:9765 A5B6 6843 17BC A646  BE8C FA56 373A 5374 C703
Old SysOps never die... they simply forget their password.
