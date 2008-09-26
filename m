Return-Path: <linux-kernel-owner+w=401wt.eu-S1753223AbYIZIUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbYIZIUn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 04:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbYIZIUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 04:20:00 -0400
Received: from smtp.nokia.com ([192.100.122.230]:21127 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbYIZIT6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 04:19:58 -0400
Subject: Re: [ANNOUNCE] [PATCH] [MTD] Flex-OneNAND MTD Driver available.
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Amit Kumar Sharma <amitsharma.9@samsung.com>
Cc: Kyungmin Park <kmpark@infradead.org>, apgmoorthy <moorthy.apg@samsung.com>,
       linux-mtd@lists.infradead.org,
       Kyungmin Park <kyungmin.park@samsung.com>,
       lkml <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <A09E9029F2344F78959A3E36179C468E@sisodomain.com>
References: <19198934.52871221827459790.JavaMail.weblogic@epml16>
	 <9c9fda240809220011w49c0875q804f836550ff3476@mail.gmail.com>
	 <000001c91e42$1aa86c50$3dd66c6b@sisodomain.com>
	 <9c9fda240809251731y48272a63j988e0001dc50d78@mail.gmail.com>
	 <1222404711.5012.5.camel@sauron>
	 <A09E9029F2344F78959A3E36179C468E@sisodomain.com>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 26 Sep 2008 11:19:36 +0300
Message-Id: <1222417176.5012.17.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 26 Sep 2008 08:19:40.0128 (UTC) FILETIME=[9F21FE00:01C91FB0]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-09-26 at 13:31 +0530, Amit Kumar Sharma wrote:
> Hi Artem
> 
> we have following erro message  if we maintain 64 bytes 
> eccpos.
> 
> /flash_eraseall -j /dev/mtd4
> ./flash_eraseall: /dev/mtd4: unable to get NAND oobinfo
> 
> ./nandwrite -j /dev/mtd2 /jffs2.img
> MEMSETOOBSEL: Inappropriate ioctl for device
> 
> but i think as OneNAND has hw ecc controller so Jffs2 will 
> not face any problem
> still i think mtd should consider for 128 bytes eccpos for 
> 4K page size.

Well, anyway, in Linux ABI is a holy cow, you cannot change it.
That is a tough rule. Old user-space binaries have to always
works.

Thus you may do one of:
1. Invent a new ioctl for 4KiB page NANDs
2. Add sysfs support
3. Just do not expose whole OOB as Kyungmin suggested

But I think assume dwmw2 would need to comment on this and
tell which approach would agree on.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

