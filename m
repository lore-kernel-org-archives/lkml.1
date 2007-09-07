Return-Path: <linux-kernel-owner+w=401wt.eu-S1758233AbXIGFxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233AbXIGFxc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 01:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbXIGFxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 01:53:24 -0400
Received: from smtp.nokia.com ([131.228.20.173]:62042 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbXIGFxX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 01:53:23 -0400
Subject: Re: [PATCH try #2] Blackfin on-chip NAND Flash Controller driver
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: bryan.wu@analog.com
Cc: David Woodhouse <dwmw2@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mike Frysinger <vapier.adi@gmail.com>,
       Robin Getz <rgetz@blackfin.uclinux.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <1188885450.7074.7.camel@roc-laptop>
References: <1188885450.7074.7.camel@roc-laptop>
Content-Type: text/plain; charset=utf-8
Date: Fri, 07 Sep 2007 08:52:21 +0300
Message-Id: <1189144341.14370.77.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 07 Sep 2007 05:52:21.0782 (UTC) FILETIME=[4207AB60:01C7F113]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-04 at 13:57 +0800, Bryan Wu wrote:
> This is the driver for latest Blackfin on-chip nand flash controller
> 
>  - use nand_chip and mtd_info common nand driver interface
>  - provide both PIO and dma operation
>  - compiled with ezkit bf548 configuration
>  - use hardware 1-bit ECC
>  - tested with YAFFS2 and can mount YAFFS2 filesystem as rootfs
> 
> ChangeLog from try#1
>  - use hweight32() instead of count_bits()
>  - replace bf54x with bf5xx and BF54X with BF5XX
>  - compare against plat->page_size in 2 cases when enable hardware ECC
> 
> Signed-off-by: Bryan Wu <bryan.wu@analog.com>

Bryan,

I'd suggest you to test your NAND driver with the following NAND tests:

git://git.infradead.org/~ahunter/nand-tests.git

(http://git.infradead.org/?p=users/ahunter/nand-tests.git;a=summary)


You may want to avoid the torture test, but it is useful to run it with
limited amount of erase cycles to make sure your flash/driver survives
really high I/O load.For example, we caught occasional DMA transfer
problems while running the torture test for few days.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

