Return-Path: <linux-kernel-owner+w=401wt.eu-S1757197AbYDAIuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197AbYDAIuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 04:50:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754685AbYDAIuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 04:50:03 -0400
Received: from smtp.nokia.com ([192.100.122.230]:60555 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506AbYDAIuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 04:50:02 -0400
Message-ID: <47F1F644.4060000@yandex.ru>
Date: Tue, 01 Apr 2008 11:45:56 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Tomasz Chmielewski <mangoo@wpkg.org>
CC: LKML <linux-kernel@vger.kernel.org>, penberg@cs.helsinki.fi,
       =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>,
       ext-adrian.hunter@nokia.com, jwboyer@gmail.com
Subject: Re: UBIFS vs Logfs (was [RFC PATCH] UBIFS - new flash file system)
References: <47F1EC20.6050600@wpkg.org>
In-Reply-To: <47F1EC20.6050600@wpkg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 01 Apr 2008 08:49:46.0400 (UTC) FILETIME=[5639BA00:01C893D5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz Chmielewski wrote:
> For me, the motivators to wait for LogFS are mainly the facts that it
> can work on traditional block devices, and not only on pure flash:

Sorry Thomasz, for me this makes zero sense. There are _much_ better file
systems for block devices. UBIFS may work on top of a block device as
well (just needs few hacks to make it possible) - it is not a problem
at all, it is just _senseless_.

JFFS2/UBIFS/LogFS is a separate _class_ of file-systems. The are designed
for _flash_, which has completely different work model then block device.
They are _native_ flash file systems.
Here are more details: http://www.linux-mtd.infradead.org/faq/general.html#L_mtd_vs_hdd

The traditional FSes _cannot_ work on top of flash. The solution for this
is using FTL, which emulates a block device on top of flash. It _hides_ the
real device, and fakes a block device for you. And you can use traditional
FSes on top of that fake block device.

The whole _point_ of this separate class of FSes is because we believe
we may do much _better_ job if we use flash _natively_, instead of using
FTL. FTL is the place where you loose performance, reliability, and so on.

And you are saying about using a native flash FS on top of a block device
like an SD card. This is just not sane: SD card first emulates a block device
for you, looses performance at this point, then you again emulate a flash
on top of this, and suffer from this again.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
