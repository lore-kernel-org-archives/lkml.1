Return-Path: <linux-kernel-owner+w=401wt.eu-S964824AbXCSVN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964824AbXCSVN0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932869AbXCSVN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:13:26 -0400
Received: from smtp.nokia.com ([131.228.20.172]:25629 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932705AbXCSVNY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:13:24 -0400
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Matt Mackall <mpm@selenic.com>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20070319195442.GT4892@waste.org>
References: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
	 <20070318162720.GI10459@waste.org> <1174236579.17249.6.camel@sauron>
	 <20070318191812.GM4892@waste.org>
	 <20070318203149.GC29295@crusty.rchland.ibm.com>
	 <20070319170838.GP4892@waste.org>
	 <1174328188.30079.46.camel@zod.rchland.ibm.com>
	 <20070319195442.GT4892@waste.org>
Content-Type: text/plain; charset=utf-8
Date: Mon, 19 Mar 2007 23:06:33 +0200
Message-Id: <1174338393.17249.53.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 19 Mar 2007 21:06:33.0833 (UTC) FILETIME=[79596D90:01C76A6A]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070319230637-0B0DFBB0-2D7EA9F6/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-19 at 14:54 -0500, Matt Mackall wrote:
> The issue is 14000 lines of patch to make a parallel subsystem.

Parallel system exists since very long. One is
flash->SW_or_HW_FTL->all_blkdev_stuff. The other is MTD->JFFS2. Think
about _why_ there are 2 of them. Hint - reliability, performance. Your
ranting basically says that only the first one makes sense. This is not
true.

We enhance the second branch, not the first, please, realize this. Both
branches have their user base, and have always had.

>                      iSCSI/nbd(6)
>                           |
> filesystem {        swap  |  ext3        ext3     jffs2
>                       \   |   |            |       /
>                /       \  | dm-crypt->snapshot(5) /
> device mapper -|        \ \   |                  /
>                |         partitioning           /
>                |              |          partitioning(4)
>                |        wear leveling(3)  /
>                |              |          /
>                |      block concatenation
>                |       |    |    |     |
>                \      bad block remapping(2)   
>                        |    |    |     |
> MTD raw block {     raw block devices with no smarts(1)
>                       /     |     \      \
> hardware {         NAND    NAND   NAND   NAND

Matt, as I pointed in the first mail, flash != block device. In your
picture I see NAND->MTD raw block. So am I right that you assume that we
already have a decent FTL? The fact is that we do not.

Please, bear in mind that decent FTL is difficult and an FS on top of
FTL is slow, FTL hits performance considerably.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

