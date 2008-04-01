Return-Path: <linux-kernel-owner+w=401wt.eu-S1757107AbYDAJkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107AbYDAJkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 05:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756921AbYDAJjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 05:39:51 -0400
Received: from mail.syneticon.net ([213.239.212.131]:53732 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756069AbYDAJju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 05:39:50 -0400
Message-ID: <47F202D9.20405@wpkg.org>
Date: Tue, 01 Apr 2008 11:39:37 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Artem Bityutskiy <dedekind@yandex.ru>
Cc: LKML <linux-kernel@vger.kernel.org>, penberg@cs.helsinki.fi,
       =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>,
       ext-adrian.hunter@nokia.com, jwboyer@gmail.com
Subject: Re: UBIFS vs Logfs (was [RFC PATCH] UBIFS - new flash file system)
References: <47F1EC20.6050600@wpkg.org> <47F1F644.4060000@yandex.ru>
In-Reply-To: <47F1F644.4060000@yandex.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy schrieb:

> Tomasz Chmielewski wrote:
>> For me, the motivators to wait for LogFS are mainly the facts that it
>> can work on traditional block devices, and not only on pure flash:
> 
> Sorry Thomasz, for me this makes zero sense. There are _much_ better file
> systems for block devices.

Such as?
Flash (also on block devices) is slow and expensive (when compared to 
modern hard disks) and therefore compression is *very* useful here.
Not only it can potentially save you money; reads and writes will be 
smaller/faster (unless you're editing music and videos, where one won't 
use flash anyway), flash will wear out slower etc.

Is there a filesystem for Linux which can provide transparent 
compression and works for block devices (other than user-space NTFS or 
some outdated ext2 patches)? I don't think so.


> UBIFS may work on top of a block device as
> well (just needs few hacks to make it possible) - it is not a problem
> at all, it is just _senseless_.

Do you mean using hacks like block2mtd? It's hacky, and pretty hard to 
boot a system this way (need to build own initramfs, with a static 
block2mtd or loads of libraries - not something an average user would 
like to do; no distro supports it; updating a kernel would be a pain etc.).


> JFFS2/UBIFS/LogFS is a separate _class_ of file-systems. The are designed
> for _flash_, which has completely different work model then block device.
> They are _native_ flash file systems.
> Here are more details: 
> http://www.linux-mtd.infradead.org/faq/general.html#L_mtd_vs_hdd

It's a good comparison, but it doesn't show disadvantages of using 
traditional filesystems on flash-based block devices.

I just mentioned the reasons why a filesystem like LogFS would be useful 
on block devices: there are valid reasons to do it.


(...)

> The whole _point_ of this separate class of FSes is because we believe
> we may do much _better_ job if we use flash _natively_, instead of using
> FTL. FTL is the place where you loose performance, reliability, and so on.

True.
Unfortunately, there is no way to access flash directly on flash-based 
block devices (USB-sticks, IDE-flash disks, SSD disks etc.).

Therefore, could an answer be: use a traditional filesystem?

Unfortunately, traditional filesystems were rather designed for rotating 
media / cheap disks (no transparent compression; tend to accumulate 
writes in one area of the disk - more on that - below).


> And you are saying about using a native flash FS on top of a block device
> like an SD card. This is just not sane: SD card first emulates a block 
> device
> for you, looses performance at this point, then you again emulate a flash
> on top of this, and suffer from this again.

Performance is only one factor in the equation. Other factors are: cost 
and reliability.

I speak from experience: flash-based block devices tend to have poor 
wear-levelling (at least Transcend IDE-flash disks).
To reproduce:
- format a 2 GB Transcend IDE-flash disk with ext3
- write a small file (50-100 kB)
- update that file ~several hundred thousand times - as you finish, 
IDE-flash disk will have 200-300 badblocks

If wear-levelling on the underlying IDE-flash device was any decent, 
writes would be spread on the whole ~2GB surface, totalling in many more 
successful writes.


Again: this is my experience, although it may contradict the theory 
underlined in the link you gave earlier.
You have much more experience with flash file systems: correct me where 
I'm wrong.


-- 
Tomasz Chmielewski
http://wpkg.org

