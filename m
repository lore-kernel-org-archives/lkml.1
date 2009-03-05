Return-Path: <linux-kernel-owner+w=401wt.eu-S1755175AbZCELzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbZCELzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 06:55:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbZCELzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 06:55:25 -0500
Received: from alcalazamora.dti2.net ([81.24.162.8]:2995 "EHLO
	alcalazamora.dti2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbZCELzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 06:55:24 -0500
X-Spam-Processed: alcalazamora.dti2.net, Thu, 05 Mar 2009 12:55:20 +0100
	(not processed: message from valid local sender)
X-MDOP-RefID: str=0001.0A0B0203.49AFBDA7.019A,ss=1,fgs=0 (_st=1 _vt=0 _iwf=0)
X-Authenticated-Sender: jorge@dti2.net
X-MDRemoteIP: 81.24.161.20
X-Return-Path: jorge@dti2.net
X-Envelope-From: jorge@dti2.net
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Message-ID: <49AFBD79.1020008@dti2.net>
Date: Thu, 05 Mar 2009 12:54:33 +0100
From: "Jorge Boncompte [DTI2]" <jorge@dti2.net>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: npiggin@suse.de
CC: ext-adrian.hunter@nokia.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Error testing ext3 on brd ramdisk
References: <491D7C4C.3090907@nokia.com> <49A82C2E.4030903@dti2.net> <20090228055809.GC28496@wotan.suse.de> <49AC1A7A.1070108@dti2.net> <20090305065529.GB11916@wotan.suse.de> <49AF9932.2040301@dti2.net> <20090305104523.GC17815@wotan.suse.de>
In-Reply-To: <20090305104523.GC17815@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Reply-To: jorge@dti2.net
X-MDAV-Processed: alcalazamora.dti2.net, Thu, 05 Mar 2009 12:55:21 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin escribió:
> On Thu, Mar 05, 2009 at 10:19:46AM +0100, Jorge Boncompte [DTI2] wrote:
>> -----------
>> umount /etc (/etc is what is mounted from /dev/ram0)
>> dd if=/dev/zero of=/dev/ram0 bs=1k count=1000
>> mount /dev/ram0 /etc -t minix -o rw
>> -----------
>> ...succeds and mounts a corrupted filesystem with the old content. Doing 
>> the same with the all ramdisk driver fails on mount with "no filesystem 
>> found".
>>
>> If I do...
>> -----------
>> umount /etc (/etc is what is mounted from /dev/ram0)
>> echo 3 > /proc/sys/vm/drop_caches
>> dd if=/dev/zero of=/dev/ram0 bs=1k count=1000
>> mount /dev/ram0 /etc -t minix -o rw
>> ----------
>> ... then the mount fails with no filesystem found as it should.
> 
> I can't reproduce this. Is the filesystem definitely being
> unmounted and nothing else is holding the bdev inode open?

	I don't know about the bdev inode :-( but I am sure that in 
/proc/mounts does not appear as listed.

> I can only imagine something like this happening if the fs
> is still mounted, in which case it will write back some
> superblock over the zeroed bdev, possibly allowing it to mount
> again, or if the zeroed writes somehow get lost, which would
> seem like a problem with the buffer cache.
> 
> Actually, the 2nd scenario is more likely, because you wouldn't
> see it with the old rd driver because it never allows the buffer
> cache to be freed.
> 
> Are you getting any errors in your dmesg or anything like that?

	No until I try to mount the filesystem again, then minix starts to 
complain.
-----------------
minix_free_block (ram0:38): bit already cleared
init_special_inode: bogus i_mode (0)
init_special_inode: bogus i_mode (0)
init_special_inode: bogus i_mode (0)
init_special_inode: bogus i_mode (0)
init_special_inode: bogus i_mode (0)
.........
-----------------

> What happens when you run the following patch? Can you run the
> test case then when you reproduce the problem, see if anything is
> in dmesg?

After a successful save
------------------
Mar  5 13:34:34 system: configuration save requested by user=root
Mar  5 13:34:34 kernel: syncing bdev
Mar  5 13:34:34 kernel: syncing bdev
Mar  5 13:34:34 kernel: syncing bdev
Mar  5 13:34:34 kernel: syncing bdev
Mar  5 13:34:34 kernel: killing bdev
Mar  5 13:34:34 kernel: syncing bdev
Mar  5 13:34:34 kernel: truncated bdev
Mar  5 13:34:34 kernel: killing bdev
Mar  5 13:34:34 kernel: syncing bdev
Mar  5 13:34:34 kernel: truncated bdev
Mar  5 13:34:34 kernel: killing bdev
Mar  5 13:34:34 kernel: syncing bdev
Mar  5 13:34:34 kernel: truncated bdev
Mar  5 13:34:34 kernel: killing bdev
Mar  5 13:34:34 kernel: syncing bdev
Mar  5 13:34:34 kernel: truncated bdev
Mar  5 13:34:34 kernel: killing bdev
Mar  5 13:34:34 kernel: syncing bdev
Mar  5 13:34:34 kernel: truncated bdev
Mar  5 13:34:34 kernel: killing bdev
Mar  5 13:34:34 kernel: syncing bdev
Mar  5 13:34:35 kernel: truncated bdev
Mar  5 13:34:35 kernel: killing bdev
Mar  5 13:34:35 kernel: syncing bdev
Mar  5 13:34:35 kernel: truncated bdev
Mar  5 13:34:35 kernel: killing bdev
Mar  5 13:34:35 kernel: syncing bdev
Mar  5 13:34:35 kernel: truncated bdev
------------------

rm -f <some archives>

------------------
Mar  5 13:35:00 system: configuration save requested by user=root
Mar  5 13:35:00 kernel: syncing bdev
Mar  5 13:35:00 kernel: syncing bdev
Mar  5 13:35:00 kernel: syncing bdev
Mar  5 13:35:00 kernel: syncing bdev
------------------

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

