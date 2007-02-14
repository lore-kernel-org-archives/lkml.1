Return-Path: <linux-kernel-owner+w=401wt.eu-S932164AbXBNJLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164AbXBNJLb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 04:11:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932172AbXBNJLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 04:11:31 -0500
Received: from mpemail.mpe.mpg.de ([130.183.137.110]:49297 "EHLO
	mpemail.mpe.mpg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164AbXBNJL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 04:11:29 -0500
From: "Martin A. Fink" <fink@mpe.mpg.de>
Organization: MPE
To: linux-kernel@vger.kernel.org
Subject: SATA-performance part 2
Date: Wed, 14 Feb 2007 10:11:20 +0100
User-Agent: KMail/1.8
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702141011.20832.fink@mpe.mpg.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

now I installed oprofile as suggested, and very interesting things happend:

System: OpenSuSE 10.2 with AHCI on, disk: Solid State Disk (Flash Disk)
Test: Write blocks of 1MB. Do fsync() every 1GB. Measure time for each GB.

before installation of oprofile:
test						OpenSuSE 10.2			FreeBSD 6.2
write to raw device  25GB		26+/-1 MB/s at 4-10% CPU	48+/-0 MB/s at 1% CPU
write to ext3 2GB			39+/-5 MB/s at 10-15% CPU

after installation of oprofile:
test						OpenSuSE 10.2			FreeBSD 6.2
write to raw device  25GB		48+/-0.5 MB/s at 4-10% CPU	49+/-0 MB/s at 1% CPU
write to ext3 (writeback) 2GB	40+/-5 MB/s at 10-15% CPU

after deinstallation of oprofile and only soft reboots (no hardware power off) 
these values STAYED (linux 48 MB/s) !! even for a brand new installation of 
OpenSuSE 10.2 to another partition!
After a hardware power off everything was again like before (26 MB/s).

So now the interesting questions to me are:

1. What is oprofile doing with my system ?? Especially what is been changed 
that remains a reboot ??

2. Buffers: All those that told me, that linux raw devices are totally 
unbuffered and thus are slower than devices with filesystems. Are you sure? 
If yes, where do you think comes this increase of speed (26 to 48) ??

3. Advices using ext3 with writeback option: I do not see an increase of 
performance with that.

Thanks,

Martin
