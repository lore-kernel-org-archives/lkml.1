Return-Path: <linux-kernel-owner+w=401wt.eu-S1752113AbZG1FM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbZG1FM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 01:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbZG1FM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 01:12:27 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:43171 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbZG1FM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 01:12:27 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       Pavel Machek <pavel@ucw.cz>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] Add function to convert between calendar time and broken-down time for universal use
References: <4A5C3BC0.6020701@cn.fujitsu.com>
	<20090714151040.b7b3b26d.akpm@linux-foundation.org>
	<20090718115019.GH1433@ucw.cz>
	<04e101ca08e5$be078fa0$808410ac@zhaoleiwin>
	<20090719202018.497f7ec1.akpm@linux-foundation.org>
	<4A643EFE.7090103@cn.fujitsu.com> <4A643F36.5090200@cn.fujitsu.com>
	<87ocr9mi8h.fsf@devron.myhome.or.jp> <4A6D1BCF.1030109@cn.fujitsu.com>
	<87k51u8xwa.fsf@devron.myhome.or.jp> <4A6E6ADD.6090602@cn.fujitsu.com>
Date: Tue, 28 Jul 2009 14:12:24 +0900
In-Reply-To: <4A6E6ADD.6090602@cn.fujitsu.com> (zhaolei@cn.fujitsu.com's
	message of "Tue, 28 Jul 2009 11:05:01 +0800")
Message-ID: <87vdld9yrr.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhaolei <zhaolei@cn.fujitsu.com> writes:

> There is no users of printk("%pf"), why not remove this?

IMO, because it doesn't make slow thing.

> And at least, I found one: drivers/char/efirtc.c
> If I continue searching, maybe more.

If there is a user, I think it's ok.

> IHMO, user of these functions should understand what these functions is and
> use these functions for right way.
> If we give user a cdrom, it is user's responsibility not using is as cup stand.
>
> At least, there function can make following source a fairy:
> fs/ncpfs/dir.c
> fs/smbfs/proc.c
> fs/fat/misc.c
> fs/udf/udftime.c
> fs/cifs/netmisc.c
> net/netfilter/xt_time.c
> drivers/scsi/ips.c
> ...
>
> It is different with user-land just because it lakes of large-complex locale
> database.

Yes, and I'm understanding FAT has the bug, and there is actual bug
report (bug FAT requires this as on-disk format). However, my point is
why we increase the known bugs.

>> gmtime() also need to handle timezone actually.
>
> So, maybe another function name as unmktime?

Maybe. Um..., or time_to_tm()? I'm not sure.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
