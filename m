Return-Path: <linux-kernel-owner+w=401wt.eu-S1757789AbYDAKCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789AbYDAKCJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 06:02:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756035AbYDAKB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 06:01:58 -0400
Received: from smtp.nokia.com ([192.100.122.230]:23129 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754922AbYDAKB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 06:01:57 -0400
Message-ID: <47F2071A.6010406@yandex.ru>
Date: Tue, 01 Apr 2008 12:57:46 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Tomasz Chmielewski <mangoo@wpkg.org>
CC: LKML <linux-kernel@vger.kernel.org>, penberg@cs.helsinki.fi,
       =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>,
       ext-adrian.hunter@nokia.com, jwboyer@gmail.com
Subject: Re: UBIFS vs Logfs (was [RFC PATCH] UBIFS - new flash file system)
References: <47F1EC20.6050600@wpkg.org> <47F1F644.4060000@yandex.ru> <47F202D9.20405@wpkg.org>
In-Reply-To: <47F202D9.20405@wpkg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 01 Apr 2008 10:01:37.0142 (UTC) FILETIME=[5FA0C160:01C893DF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz Chmielewski wrote:
> Such as?

ext3 for example.

> Flash (also on block devices) is slow and expensive (when compared to 
> modern hard disks) and therefore compression is *very* useful here.
Well, if you are ready to trade performance to compression, then well,
go ahead :-) May be I used too strong wording, but I wanted to say then
use raw flash then. But I'd also consider implementing compression support
for a block based FS. Reiser4 claimed to have it for example.

> Do you mean using hacks like block2mtd? It's hacky, and pretty hard to 
> boot a system this way (need to build own initramfs, with a static 
> block2mtd or loads of libraries - not something an average user would 
> like to do; no distro supports it; updating a kernel would be a pain etc.).
Well, ok, it still sounds strange for me, but you may use JFFS2 and UBIFS
with block2mtd as well if you really want to.

> True.
> Unfortunately, there is no way to access flash directly on flash-based 
> block devices (USB-sticks, IDE-flash disks, SSD disks etc.).
Yeah, that's a pity :-(

> Unfortunately, traditional filesystems were rather designed for rotating 
> media / cheap disks (no transparent compression; tend to accumulate 
> writes in one area of the disk - more on that - below).
Sure.

> Performance is only one factor in the equation. Other factors are: cost 
> and reliability.
> 
> I speak from experience: flash-based block devices tend to have poor 
> wear-levelling (at least Transcend IDE-flash disks).
> To reproduce:
> - format a 2 GB Transcend IDE-flash disk with ext3
> - write a small file (50-100 kB)
> - update that file ~several hundred thousand times - as you finish, 
> IDE-flash disk will have 200-300 badblocks
Yeah, that's bad. But if you have a bad FTL, surely there is not guarantee
a flash FS will help? Isn't it better to use better hardware?

We did some experiments with MMC cards and we were unable to wear them
out with re-writing the same sectors again and again. This suggests there
_is_ better FTL hardware then that USB stick you was using.

Anyway, your original mail said Logfs can work with block devices. My answer -
UBIFS too, but this is very strange to do this IMO. But OK, it might is not
senseless, sorry for the wording. :-)

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
