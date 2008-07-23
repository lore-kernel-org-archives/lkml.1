Return-Path: <linux-kernel-owner+w=401wt.eu-S1753745AbYGWMOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbYGWMOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 08:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbYGWMN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 08:13:58 -0400
Received: from relay03.mail-hub.dodo.com.au ([123.2.6.238]:44519 "EHLO
	relay03.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750799AbYGWMN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 08:13:57 -0400
From: Grant Coady <grant_lkml@dodo.com.au>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Gene Heskett <gene.heskett@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Floppy access by dd fails for 2.6.26-rc2 to final, possibly even earlier
Date: Wed, 23 Jul 2008 22:13:28 +1000
Organization: http://bugsplatter.mine.nu/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <b18e84p0itk9r2gvl8p04m1dq32ulpp45h@4ax.com>
References: <200807220841.27796.gene.heskett@gmail.com> <20080722164039.GA18079@animx.eu.org> <200807222046.00476.gene.heskett@gmail.com> <48871366.4010707@keyaccess.nl>
In-Reply-To: <48871366.4010707@keyaccess.nl>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jul 2008 13:17:58 +0200, Rene Herman <rene.herman@keyaccess.nl> wrote:

>On 23-07-08 02:46, Gene Heskett wrote:
>
>> On Tuesday 22 July 2008, Wakko Warner wrote:
>>> Gene Heskett wrote:
>>>> I just been advised by private email that I an not the only one who has
>>>> lost the use of his floppy drive via dd.  The corresponder noted that he
>>>> had a copy of DSL with a 2.4.something kernel, and his drive worked
>>>> flawlessly while booted to DSL.
>>>>
>>>> So now there are at least 2 floppy users wandering in the wilderness
>>>> looking for water.  We need it to support 20 year old computers without a
>>>> TCP stack or network cards.
>>> I guess I'll chime in.  I'm not sure this is the same problem or not, but my
>>> Alpha AS1000a (EV56 5/400) has never successfully been able to read the
>>> floppy.  I always get garbage.  The drive does work as I can use the RCU
>>>from floppy from the Arc BIOS.
>>> Linux sees this device as a 2.88mb floppy.  It is a 1.44mb and the
>>> information in the Arc BIOS is set to 1.44mb (I don't think it matters, I
>>> boot from SRM, not sure how to set the floppy there)
>>>
>>> I also do not see any errors or other useful messages in the logs.
>>>
>> Neither do I. It registers as
>> Jul 20 22:56:59 coyote kernel: [   16.297661] Floppy drive(s): fd0 is 1.44M
>> Jul 20 22:56:59 coyote kernel: [   16.312758] FDC 0 is a post-1991 82077
>> 
>> 
>>> Jun  1 15:23:06 narf kernel: [4262383.309846] Floppy drive(s): fd0 is 2.88M
>>> Jun  1 15:23:06 narf kernel: [4262383.324494] FDC 0 is a National
>>> Semiconductor PC87306
>>>
>>> I tried forcing to use a specific type:
>>> Jun  1 16:21:38 narf kernel: [4194206.301784] floppy0: setting CMOS code to
>>> 4 Jun  1 16:21:38 narf kernel: [4194206.301784] Floppy drive(s): fd0 is
>>> 1.44M Jun  1 16:21:38 narf kernel: [4194206.314479] FDC 0 is a National
>>> Semiconductor PC87306
>>>
>>> But that failed even worse with errors on sector 0.  (NOTE the floppy was
>>> good)
>> 
>> Glad to know I'm not the only one, there are 3 of us now.
>
>Am not reproducing on 2.6.26, so it's at least not just everyone. Normal 
>floppy works fine here:
>
>root@7ixe4:~# mkfs.minix /dev/fd0
>480 inodes
>1440 blocks
>Firstdatazone=19 (19)
>Zonesize=1024
>Maxsize=268966912
>
>root@7ixe4:~# mount /dev/fd0 /mnt/floppy
>root@7ixe4:~# echo BAR >/mnt/floppy/FOO
>root@7ixe4:~# umount /mnt/floppy
>root@7ixe4:~# dd if=/dev/fd0 of=floppy.img
>2880+0 records in
>2880+0 records out
>1474560 bytes (1.5 MB) copied, 48.1893 s, 30.6 kB/s
>root@7ixe4:~# mount -o loop floppy.img /mnt/floppy
>root@7ixe4:~# cat /mnt/floppy/FOO
>BAR
>root@7ixe4:~# umount /mnt/floppy
>root@7ixe4:~# dd if=floppy.img of=/dev/fd0
>2880+0 records in
>2880+0 records out
>1474560 bytes (1.5 MB) copied, 99.3359 s, 14.8 kB/s
>root@7ixe4:~# mount /dev/fd0 /mnt/floppy
>root@7ixe4:~# cat /mnt/floppy/FOO
>BAR

Works here for ext2 and msdos, but I'm running on the linux box used to test.

Grant.
>
>Rene.

