Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132AbYDAIDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbYDAIDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 04:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753466AbYDAICx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 04:02:53 -0400
Received: from mail.syneticon.net ([213.239.212.131]:53089 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbYDAICu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 04:02:50 -0400
Message-ID: <47F1EC20.6050600@wpkg.org>
Date: Tue, 01 Apr 2008 10:02:40 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, penberg@cs.helsinki.fi,
       =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>,
       ext-adrian.hunter@nokia.com, jwboyer@gmail.com,
       "Artem B. Bityutskiy" <dedekind@yandex.ru>
Subject: UBIFS vs Logfs (was [RFC PATCH] UBIFS - new flash file system)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy wrote:

> I've renamed the thread because I do not like this flamish discussion
> to me mixed with the technical one.
> 
> JÃ¶rn Engel wrote:
>> Shiny numbers!  Performance has improved significantly in the last six
>> month.  Still worth a closer look.
> We'll re-run them. Does logfs support write-back? Does it support compression?

For me, the motivators to wait for LogFS are mainly the facts that it
can work on traditional block devices, and not only on pure flash:

1. It works on normal block devices and it supports transparent compression

Today, a 64 GB SSD/flash-based media costs ~about the same as a 1 TB
hard disk. This makes flash very expensive to use; compression can
compensate that cost a bit (will depend on the usage, of course).

I believe there is no other Linux filesystem which can do transparent
compression on block devices.


2. It does wear-levelling also on normal block devices

Although it doesn't sound normal to do wear-levelling twice (most
flash-based block devices do wear-levelling on their own), I had a flash
corruption after just ~one month of using RAID bitmap on a IDE-flash
disk formatted with ext3. Apparently, device-level wear-levelling wasn't
spreading updates of RAID bitmap file well enough.

(...)

> This basically means it is unfinished. Handling dynamic bad blocks is a *must*
> if you are going to work on NAND, especially on MLC NAND which are not as
> reliable as SLC.
> I think you should bluntly say about this when you submit patches to prevent
> people from starting using it in production.

I too wouldn't use LogFS today in a production environment - it is still 
not feature complete and not widely tested.
I wouldn't use btrfs or ext4 today for the very same reason.


-- 
Tomasz Chmielewski
http://wpkg.org


